pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import "./IClient.sol";
import "./IBCHost.sol";
import "./IBCMsgs.sol";
import {
    TmHeader as LightBlock,
    ClientState,
    ConsensusState,
    SignedHeader,
    LightHeader,
    ValidatorSet,
    BlockID,
    Commit,
    Validator,
    CommitSig,
    Vote,
    TENDERMINT_LIGHT_PROTO_GLOBAL_ENUMS,
    CanonicalVote,
    CanonicalBlockID,
    CanonicalPartSetHeader,
    Timestamp,
    MerkleRoot,
    SimpleValidator,
    Consensus,
	Fraction,
	Duration
} from "./types/tendermint_light.sol";
import {GoogleProtobufAny as Any} from "./types/GoogleProtobufAny.sol";
import "../lib/Bytes.sol";
import "../lib/proto.sol";
import "../lib/crypto.sol";
import "../lib/tendermint.sol";
import "./IBCIdentifier.sol";

// TODO: look and handle possible overflows
// NOTE:  SimpleValidator encode must be > 0 encode (both secp256k1, sr25519)
// NOTE:  PubKey encode must be > 0 encode (both secp256k1, sr25519)
// NOTE:  CanonicalVote round encode must be > 0 encode
// NOTE:  Consensus both fields must be > 0
// NOTE:  BlockID both fields must be > 0
// NOTE:  PartSetHeader both fields must be > 0

contract TendermintClient is IClient {
    using Bytes for bytes;
    using tendermint for Vote.Data;
    using tendermint for Timestamp.Data;
    using tendermint for BlockID.Data;
    using tendermint for SignedHeader.Data;
    using tendermint for LightBlock.Data;
    using tendermint for ValidatorSet.Data;
    using tendermint for Commit.Data;
    using tendermint for ConsensusState.Data;

    // TODO: remove once stabilized code (used for debugging)
    event Log(string text, bytes data);
    event Log(string text, Vote.Data);
    event Log(string text, bool);
    event Log(string text, int64);
    event Log(string text, uint);
    event Log(string text, uint32);
    event Log(string text, uint64);
    event Log(string text, bytes32);
    event Log(string text);

    struct protoTypes {
        bytes32 clientState;
        bytes32 consensusState;
        bytes32 light_block;
    }

    protoTypes pts;

    constructor() public {
        // TODO The typeUrl should be defined in types/IBFT2Client.sol
        // The schema of typeUrl follows cosmos/cosmos-sdk/codec/types/any.go
        pts = protoTypes({
            clientState: keccak256(abi.encodePacked("/tendermint.types.ClientState")),
            consensusState: keccak256(abi.encodePacked("/tendermint.types.ConsensusState")),
            light_block: keccak256(abi.encodePacked("/tendermint.types.LightBlock"))
        });
    }

    /**
     * @dev getTimestampAtHeight returns the timestamp of the consensus state at the given height.
     */
    function getTimestampAtHeight(
        IBCHost host,
        string memory clientId,
        uint64 height
    ) public override view returns (uint64, bool) {
        (ConsensusState.Data memory consensusState, bool found) = getConsensusState(host, clientId, height);
        if (!found) {
            return (0, false);
        }
        return (uint64(consensusState.timestamp.Seconds), true); // TODO (added seconds)
    }

    function getLatestHeight(
        IBCHost host,
        string memory clientId
    ) public override view returns (uint64, bool) {
        (ClientState.Data memory clientState, bool found) = getClientState(host, clientId);
        if (!found) {
            return (0, false);
        }
        return (uint64(clientState.latest_height), true);
    }

    /**
     * @dev checkHeaderAndUpdateState checks if the provided header is valid
     */
    function checkHeaderAndUpdateState(
        IBCHost host,
        string memory clientId, 
        bytes memory clientStateBytes,
        bytes memory headerBytes
    ) public override returns (bytes memory newClientStateBytes, bytes memory newConsensusStateBytes, uint64 height) {
        LightBlock.Data memory lightBlock;
        ClientState.Data memory clientState;
        ConsensusState.Data memory trustedConsensusState;
        ConsensusState.Data memory prevConsState;
        bool ok;
        bool conflictingHeader;

        (lightBlock, ok) = unmarshalLightBlock(headerBytes);
        require(ok, "light block is invalid");

        // Check if the Client store already has a consensus state for the header's height
        // If the consensus state exists, and it matches the header then we return early
        // since header has already been submitted in a previous UpdateClient.
	    (prevConsState, ok) = getConsensusState(host, clientId, uint64(lightBlock.signed_header.header.height));
	    if (ok) {
	    	// This header has already been submitted and the necessary state is already stored
	    	// in client store, thus we can return early without further validation.
            if (prevConsState.isEqual(lightBlock.toConsensusState())) {
				return (clientStateBytes, marshalConsensusState(prevConsState), uint64(lightBlock.signed_header.header.height));
            }
	    	// A consensus state already exists for this height, but it does not match the provided header.
	    	// Thus, we must check that this header is valid, and if so we will freeze the client.
	    	conflictingHeader = true;
	    }
        
        (trustedConsensusState, ok) = getConsensusState(host, clientId, uint64(lightBlock.trusted_height));
        require(ok, "consensusState not found at trusted height");

        (clientState, ok) = unmarshalClientState(clientStateBytes);
        require(ok, "client state is invalid");

        checkValidity(clientState, trustedConsensusState, lightBlock, Duration.Data({Seconds: int64(now), nanos: 0})); // TODO: unsafe downcast to int64

	    // Header is different from existing consensus state and also valid, so freeze the client and return
	    if (conflictingHeader) {
            clientState.frozen_height = lightBlock.signed_header.header.height;
	    	return (
                marshalClientState(clientState),
                marshalConsensusState(lightBlock.toConsensusState()),
                uint64(lightBlock.signed_header.header.height)
            );
	    }

        // TODO: check consensus state monotonicity

        // update the consensus state from a new header and set processed time metadata
        if (lightBlock.signed_header.header.height > clientState.latest_height) {
            clientState.latest_height = lightBlock.signed_header.header.height;
        }

        return (marshalClientState(clientState), marshalConsensusState(lightBlock.toConsensusState()), uint64(clientState.latest_height));
    }

    function marshalClientState(ClientState.Data memory clientState) internal view returns (bytes memory) {
        Any.Data memory anyClientState;
        anyClientState.type_url = "/tendermint.types.ClientState";
        anyClientState.value = ClientState.encode(clientState);
        return Any.encode(anyClientState);
    }

    function marshalConsensusState(ConsensusState.Data memory consensusState) internal view returns (bytes memory) {
        Any.Data memory anyConsensusState;
        anyConsensusState.type_url = "/tendermint.types.ConsensusState";
        anyConsensusState.value = ConsensusState.encode(consensusState);
        return Any.encode(anyConsensusState);
    }

    function unmarshalLightBlock(bytes memory bz) internal view returns (LightBlock.Data memory header, bool ok) {
        Any.Data memory anyHeader = Any.decode(bz);
        if (keccak256(abi.encodePacked(anyHeader.type_url)) != pts.light_block) {
            return (header, false);
        }
        return (LightBlock.decode(anyHeader.value), true);
    }

    function unmarshalClientState(bytes memory bz) internal view returns (ClientState.Data memory clientState, bool ok) {
        Any.Data memory anyClientState = Any.decode(bz);
        if (keccak256(abi.encodePacked(anyClientState.type_url)) != pts.clientState) {
            return (clientState, false);
        }
        return (ClientState.decode(anyClientState.value), true);
    }

    function unmarshalConsensusState(bytes memory bz) internal view returns (ConsensusState.Data memory consensusState, bool ok) {
        Any.Data memory anyConsensusState = Any.decode(bz);
        if (keccak256(abi.encodePacked(anyConsensusState.type_url)) != pts.consensusState) {
            return (consensusState, false);
        }
        return (ConsensusState.decode(anyConsensusState.value), true);
    }

    /// State verification functions ///

    function verifyClientState(
        IBCHost host,
        string memory clientId,
        uint64 height,
        bytes memory prefix,
        string memory counterpartyClientIdentifier,
        bytes memory proof,
        bytes memory clientStateBytes
    ) public override view returns (bool) {
        ClientState.Data memory clientState;
        ConsensusState.Data memory consensusState;
        bool found;

        (clientState, found) = getClientState(host, clientId);
        if (!found) {
            return false;
        }
        if (!validateArgs(clientState, height, prefix, proof)) {
            return false;
        }
        (consensusState, found) = getConsensusState(host, clientId, height);
        if (!found) {
            return false;
        }
        return verifyMembership(proof, consensusState.root.hash.toBytes32(), prefix, IBCIdentifier.clientStateCommitmentSlot(counterpartyClientIdentifier), keccak256(clientStateBytes));
    }

    function verifyClientConsensusState(
        IBCHost host,
        string memory clientId,
        uint64 height,
        string memory counterpartyClientIdentifier,
        uint64 consensusHeight,
        bytes memory prefix,
        bytes memory proof,
        bytes memory consensusStateBytes // serialized with pb
    ) public override view returns (bool) {
        ClientState.Data memory clientState;
        ConsensusState.Data memory consensusState;
        bool found;

        (clientState, found) = getClientState(host, clientId);
        if (!found) {
            return false;
        }
        if (!validateArgs(clientState, height, prefix, proof)) {
            return false;
        }
        (consensusState, found) = getConsensusState(host, clientId, height);
        if (!found) {
            return false;
        }
        return verifyMembership(proof, consensusState.root.hash.toBytes32(), prefix, IBCIdentifier.consensusStateCommitmentSlot(counterpartyClientIdentifier, consensusHeight), keccak256(consensusStateBytes));
    }

    function verifyConnectionState(
        IBCHost host,
        string memory clientId,
        uint64 height,
        bytes memory prefix,
        bytes memory proof,
        string memory connectionId,
        bytes memory connectionBytes // serialized with pb
    ) public override view returns (bool) {
        ClientState.Data memory clientState;
        ConsensusState.Data memory consensusState;
        bool found;

        (clientState, found) = getClientState(host, clientId);
        if (!found) {
            return false;
        }
        if (!validateArgs(clientState, height, prefix, proof)) {
            return false;
        }
        (consensusState, found) = getConsensusState(host, clientId, height);
        if (!found) {
            return false;
        }
        return verifyMembership(proof, consensusState.root.hash.toBytes32(), prefix, IBCIdentifier.connectionCommitmentSlot(connectionId), keccak256(connectionBytes));
    }

    function verifyChannelState(
        IBCHost host,
        string memory clientId,
        uint64 height,
        bytes memory prefix,
        bytes memory proof,
        string memory portId,
        string memory channelId,
        bytes memory channelBytes // serialized with pb
    ) public override view returns (bool) {
        ClientState.Data memory clientState;
        ConsensusState.Data memory consensusState;
        bool found;

        (clientState, found) = getClientState(host, clientId);
        if (!found) {
            return false;
        }
        if (!validateArgs(clientState, height, prefix, proof)) {
            return false;
        }
        (consensusState, found) = getConsensusState(host, clientId, height);
        if (!found) {
            return false;
        }
        return verifyMembership(proof, consensusState.root.hash.toBytes32(), prefix, IBCIdentifier.channelCommitmentSlot(portId, channelId), keccak256(channelBytes));
    }

    function verifyPacketCommitment(
        IBCHost host,
        string memory clientId,
        uint64 height,
        bytes memory prefix,
        bytes memory proof,
        string memory portId,
        string memory channelId,
        uint64 sequence,
        bytes32 commitmentBytes
    ) public override view returns (bool) {
        ClientState.Data memory clientState;
        ConsensusState.Data memory consensusState;
        bool found;

        (clientState, found) = getClientState(host, clientId);
        if (!found) {
            return false;
        }
        if (!validateArgs(clientState, height, prefix, proof)) {
            return false;
        }
        (consensusState, found) = getConsensusState(host, clientId, height);
        if (!found) {
            return false;
        }
        return verifyMembership(proof, consensusState.root.hash.toBytes32(), prefix, IBCIdentifier.packetCommitmentSlot(portId, channelId, sequence), commitmentBytes);
    }

    function verifyPacketAcknowledgement(
        IBCHost host,
        string memory clientId,
        uint64 height,
        bytes memory prefix,
        bytes memory proof,
        string memory portId,
        string memory channelId,
        uint64 sequence,
        bytes memory acknowledgement
    ) public override view returns (bool) {
        ClientState.Data memory clientState = mustGetClientState(host, clientId);
        if (!validateArgs(clientState, height, prefix, proof)) {
            return false;
        }
        return verifyMembership(proof, mustGetConsensusState(host, clientId, height).root.hash.toBytes32(), prefix, IBCIdentifier.packetAcknowledgementCommitmentSlot(portId, channelId, sequence), host.makePacketAcknowledgementCommitment(acknowledgement));
    }

    /// tendermint verification functions ///

    // checkValidity checks if the Tendermint header is valid.
    function checkValidity(
        ClientState.Data memory clientState,
        ConsensusState.Data memory trustedConsensusState,
        LightBlock.Data memory lightBlock,
        Duration.Data memory currentTime
    ) internal {
        // checkTrustedHead
        // assert that trustedVals is NextValidators of last trusted header
        // to do this, we check that trustedVals.Hash() == consState.NextValidatorsHash
        require(
            lightBlock.trusted_validators.hash() == trustedConsensusState.next_validators_hash.toBytes32(),
            "headers trusted validators does not hash to latest trusted validators"
        );

	    // assert header height is newer than consensus state
        require(
            lightBlock.signed_header.header.height > lightBlock.trusted_height,
            "header height ≤ consensus state height"
        );

        // TODO: IsRevisionFormat(chaiID)

        LightHeader.Data memory lc;
        lc.chain_id = clientState.chain_id;
        lc.height = lightBlock.trusted_height;
        lc.time = trustedConsensusState.timestamp;
        lc.next_validators_hash = trustedConsensusState.next_validators_hash;

        ValidatorSet.Data memory trustedVals = lightBlock.trusted_validators;
        SignedHeader.Data memory trustedHeader;
        trustedHeader.header = lc;

        SignedHeader.Data memory untrustedHeader = lightBlock.signed_header;
        ValidatorSet.Data memory untrustedVals = lightBlock.validator_set;

        bool ok = verify(
			clientState,
            trustedHeader,
            trustedVals,
            untrustedHeader,
            untrustedVals,
            currentTime
        );

        require(ok, "failed to verify header");
    }

    function verify(
			ClientState.Data memory clientState,
            SignedHeader.Data memory trustedHeader,
            ValidatorSet.Data memory trustedVals,
            SignedHeader.Data memory untrustedHeader,
            ValidatorSet.Data memory untrustedVals,
            Duration.Data memory currentTime
    ) internal returns (bool) {
        if (untrustedHeader.header.height != trustedHeader.header.height+1) {
            return verifyNonAdjacent(
                trustedHeader,
                trustedVals,
                untrustedHeader,
                untrustedVals,
            	clientState.trusting_period,
                currentTime,
            	clientState.max_clock_drift,
            	clientState.trust_level
            );
        }

        return verifyAdjacent(
            trustedHeader,
            untrustedHeader,
            untrustedVals,
            clientState.trusting_period,
            currentTime,
            clientState.max_clock_drift
        );
    }

    function verifyNewHeaderAndVals(
            SignedHeader.Data memory untrustedHeader,
            ValidatorSet.Data memory untrustedVals,
            SignedHeader.Data memory trustedHeader,
            Duration.Data memory currentTime,
            Duration.Data memory maxClockDrift
    ) internal {
            // SignedHeader validate basic
            require(keccak256(abi.encodePacked(untrustedHeader.header.chain_id)) == keccak256(abi.encodePacked(trustedHeader.header.chain_id)), "header belongs to another chain");
            require(untrustedHeader.commit.height == untrustedHeader.header.height, "header and commit height mismatch");

            bytes32 untrustedHeaderBlockHash = untrustedHeader.hash();
            require(untrustedHeaderBlockHash == untrustedHeader.commit.block_id.hash.toBytes32(), "commit signs signs block failed");

            require(untrustedHeader.header.height > trustedHeader.header.height, "expected new header height to be greater than one of old header");
            require(untrustedHeader.header.time.GT(trustedHeader.header.time), "expected new header time to be after old header time");
            require(Timestamp.Data({
                Seconds: int64(currentTime.Seconds) + int64(maxClockDrift.Seconds), nanos: int32(currentTime.nanos) + int32(maxClockDrift.nanos)
            }).GT(untrustedHeader.header.time), "new header has time from the future");

            bytes32 validatorsHash = crypto.merkleRootHash(untrustedVals.validators, 0, untrustedVals.validators.length);
            require(untrustedHeader.header.validators_hash.toBytes32() == validatorsHash, "expected new header validators to match those that were supplied at height XX");
    }

    function verifyAdjacent(
            SignedHeader.Data memory trustedHeader,
            SignedHeader.Data memory untrustedHeader,
            ValidatorSet.Data memory untrustedVals,
            Duration.Data memory trustingPeriod,
            Duration.Data memory currentTime,
            Duration.Data memory maxClockDrift
    ) internal returns (bool) {
            require(untrustedHeader.header.height == trustedHeader.header.height+1, "headers must be adjacent in height");

            require(!trustedHeader.isExpired(trustingPeriod, currentTime), "header can't be expired");

	        verifyNewHeaderAndVals(
	        	untrustedHeader,
                untrustedVals,
	        	trustedHeader,
	        	currentTime,
                maxClockDrift
            );

	        // Check the validator hashes are the same
            require(untrustedHeader.header.validators_hash.toBytes32() == trustedHeader.header.next_validators_hash.toBytes32(), "expected old header next validators to match those from new header");

            // Ensure that +2/3 of new validators signed correctly.
            //if err := untrustedVals.VerifyCommitLight(trustedHeader.ChainID, untrustedHeader.Commit.BlockID,
            bool ok = verifyCommitLight(untrustedVals, trustedHeader.header.chain_id, untrustedHeader.commit.block_id, untrustedHeader.header.height, untrustedHeader.commit);

            return ok;
    }

    function verifyNonAdjacent(
            SignedHeader.Data memory trustedHeader,
            ValidatorSet.Data memory trustedVals,
            SignedHeader.Data memory untrustedHeader,
            ValidatorSet.Data memory untrustedVals,
            Duration.Data memory trustingPeriod,
            Duration.Data memory currentTime,
            Duration.Data memory maxClockDrift,
            Fraction.Data memory trustLevel
    ) internal returns (bool) {
        require(untrustedHeader.header.height != trustedHeader.header.height+1, "headers must be non adjacent in height");

        require(!trustedHeader.isExpired(trustingPeriod, currentTime), "header can't be expired");

	    verifyNewHeaderAndVals(
	    	untrustedHeader,
            untrustedVals,
	    	trustedHeader,
	    	currentTime,
            maxClockDrift
        );

        // Ensure that +`trustLevel` (default 1/3) or more of last trusted validators signed correctly.
        verifyCommitLightTrusting(trustedVals, trustedHeader.header.chain_id, untrustedHeader.commit, trustLevel);

        // Ensure that +2/3 of new validators signed correctly.
        //if err := untrustedVals.VerifyCommitLight(trustedHeader.ChainID, untrustedHeader.Commit.BlockID,
        bool ok = verifyCommitLight(untrustedVals, trustedHeader.header.chain_id, untrustedHeader.commit.block_id, untrustedHeader.header.height, untrustedHeader.commit);

        return ok;
    }

    function verifyCommitLightTrusting(
            ValidatorSet.Data memory trustedVals,
            string memory chainID,
            Commit.Data memory commit,
            Fraction.Data memory trustLevel
    ) internal returns (bool) {
        // sanity check
        require(trustLevel.denominator != 0, "trustLevel has zero Denominator");

        int64 talliedVotingPower = 0;
		bool[] memory seenVals = new bool[](trustedVals.validators.length);

        // TODO: unsafe multiplication?
        CommitSig.Data memory commitSig;
        uint256 totalVotingPowerMulByNumerator = uint256(trustedVals.total_voting_power) * uint256(trustLevel.numerator);
        uint256 votingPowerNeeded = totalVotingPowerMulByNumerator / uint256(trustLevel.denominator);

        for (uint idx = 0; idx < commit.signatures.length; idx++) {
            commitSig = commit.signatures[idx];

            // no need to verify absent or nil votes.
            if (commitSig.block_id_flag != TENDERMINT_LIGHT_PROTO_GLOBAL_ENUMS.BlockIDFlag.BLOCK_ID_FLAG_COMMIT) {
                continue;
            }

		    // We don't know the validators that committed this block, so we have to
		    // check for each vote if its validator is already known.
            // TODO: O(n^2)
            (uint valIdx, bool found) = trustedVals.getByAddress(commitSig.validator_address);
            if (found) {
				// check for double vote of validator on the same commit
				require(!seenVals[valIdx], "double vote of validator on the same commit");
				seenVals[valIdx] = true;

                Validator.Data memory val = trustedVals.validators[valIdx];

                // validate signature
                bytes memory message = voteSignBytesDelim(commit, chainID, idx);
                bytes memory pubkey = val.pub_key.ed25519;
                bytes memory sig = commitSig.signature;

				bool success = crypto.ed25519Verify(message, pubkey, sig);
				if (!success) {
					return false;
				}

                talliedVotingPower += val.voting_power;

                if (uint256(talliedVotingPower) > votingPowerNeeded) {
                    return true;
                }
            }
        }

        return false;
    }

    // VerifyCommitLight verifies +2/3 of the set had signed the given commit.
    //
    // This method is primarily used by the light client and does not check all the
    // signatures.
    function verifyCommitLight(
        ValidatorSet.Data memory vals,
        string memory chainID,
        BlockID.Data memory blockID,
        int64 height,
        Commit.Data memory commit
    ) internal returns (bool) {
        require(vals.validators.length == commit.signatures.length, "invalid commmit signatures");

        require(height == commit.height, "invalid commit height");

        require(commit.block_id.isEqual(blockID), "invalid commit -- wrong block ID");

        Validator.Data memory val;
        CommitSig.Data memory commitSig;

        int64 talliedVotingPower = 0;
        int64 votingPowerNeeded = vals.getTotalVotingPower() * 2 / 3;

        for (uint i = 0; i < commit.signatures.length; i++) {
            commitSig = commit.signatures[i];

            // no need to verify absent or nil votes.
            if (commitSig.block_id_flag != TENDERMINT_LIGHT_PROTO_GLOBAL_ENUMS.BlockIDFlag.BLOCK_ID_FLAG_COMMIT) {
                continue;
            }

            val = vals.validators[i];

            // validate signature
            bytes memory message = proto.encodeDelim(voteSignBytes(commit, chainID, i));
            bytes memory pubkey = val.pub_key.ed25519;
            bytes memory sig = commitSig.signature;

            bool success = crypto.ed25519Verify(message, pubkey, sig);

            // TODO: debug
            emit Log("message", message);
            emit Log("pubkey", val.pub_key.ed25519);
            emit Log("sig", commitSig.signature);
            emit Log("ed25519", success);

            if (!success) {
                return false;
            }

            talliedVotingPower += val.voting_power;

            if (talliedVotingPower > votingPowerNeeded) {
                return true;
            }
        }

        return false;
    }

    function voteSignBytes(Commit.Data memory commit, string memory chainID, uint idx) internal view returns (bytes memory) {
        Vote.Data memory vote;
        vote = commit.toVote(idx);

        return (CanonicalVote.encode(vote.toCanonicalVote(chainID)));
    }

	function voteSignBytesDelim(Commit.Data memory commit, string memory chainID, uint idx) internal view returns (bytes memory) {
		return proto.encodeDelim(voteSignBytes(commit, chainID, idx));
	}


    /// helper functions ///

    function getClientState(IBCHost host, string memory clientId) public view returns (ClientState.Data memory clientState, bool found) {
        bytes memory clientStateBytes;
        (clientStateBytes, found) = host.getClientState(clientId);
        if (!found) {
            return (clientState, false);
        }
        return (ClientState.decode(Any.decode(clientStateBytes).value), true);
    }

    function getConsensusState(IBCHost host, string memory clientId, uint64 height) public view returns (ConsensusState.Data memory consensusState, bool found) {
        bytes memory consensusStateBytes;
        (consensusStateBytes, found) = host.getConsensusState(clientId, height);
        if (!found) {
            return (consensusState, false);
        }
        return (ConsensusState.decode(Any.decode(consensusStateBytes).value), true);
    }

    function validateArgs(ClientState.Data memory cs, uint64 height, bytes memory prefix, bytes memory proof) internal pure returns (bool) {
        if (cs.latest_height < int64(height)) {
            return false;
        } else if (prefix.length == 0) {
            return false;
        } else if (proof.length == 0) {
            return false;
        }
        return true;
    }

    // NOTE: this is a workaround to avoid the error `Stack too deep` in caller side
    function mustGetClientState(IBCHost host, string memory clientId) internal view returns (ClientState.Data memory) {
        (ClientState.Data memory clientState, bool found) = getClientState(host, clientId);
        require(found, "client state not found");
        return clientState;
    }

    // NOTE: this is a workaround to avoid the error `Stack too deep` in caller side
    function mustGetConsensusState(IBCHost host, string memory clientId, uint64 height) internal view returns (ConsensusState.Data memory) {
        (ConsensusState.Data memory consensusState, bool found) = getConsensusState(host, clientId, height);
        require(found, "consensus state not found");
        return consensusState;
    }

    function verifyMembership(
        bytes memory proof,
        bytes32 root,
        bytes memory prefix,
        bytes32 slot,
        bytes32 expectedValue
    ) internal pure returns (bool) {
        return true;
    }
}
