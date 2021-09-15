pragma solidity ^0.6.8;

import { 
    TENDERMINT_LIGHT_PROTO_GLOBAL_ENUMS,
    Validator,
    SimpleValidator,
    BlockID,
    Vote,
    CanonicalBlockID,
    CanonicalPartSetHeader,
    CanonicalVote,
    Timestamp,
    TmHeader as LightBlock,
    SignedHeader,
    ConsensusState,
    MerkleRoot,
    Consensus,
    ValidatorSet,
    Commit,
    CommitSig,
	Duration
} from "../core/types/tendermint_light.sol";
import "./proto.sol";
import "./crypto.sol";

library tendermint {
    function toSimpleValidator(Validator.Data memory val) internal pure returns (SimpleValidator.Data memory) {
        return SimpleValidator.Data({
            pub_key: val.pub_key,
            voting_power: val.voting_power
        });
    }

    function toCanonicalBlockID(BlockID.Data memory blockID) internal pure returns (CanonicalBlockID.Data memory) {
        return CanonicalBlockID.Data({
            hash: blockID.hash,
            part_set_header: CanonicalPartSetHeader.Data({
                total: blockID.part_set_header.total,
                hash: blockID.part_set_header.hash
            })
        });
    }

    function toCanonicalVote(Vote.Data memory vote, string memory chainID) internal pure returns (CanonicalVote.Data memory) {
        return CanonicalVote.Data({
            Type: vote.Type,
            height: vote.height,
            round: int64(vote.round),
            block_id: toCanonicalBlockID(vote.block_id),
            timestamp: vote.timestamp,
            chain_id: chainID
        });
    }

    function toConsensusState(LightBlock.Data memory lightBlock) internal pure returns (ConsensusState.Data memory){
        return ConsensusState.Data({
            timestamp: lightBlock.signed_header.header.time,
            root: MerkleRoot.Data({ hash: lightBlock.signed_header.header.app_hash }),
            next_validators_hash: lightBlock.signed_header.header.next_validators_hash
        });
    }

    function toVote(Commit.Data memory commit, uint valIdx) internal pure returns (Vote.Data memory) {
        CommitSig.Data memory commitSig = commit.signatures[valIdx];

        return Vote.Data({
            Type: TENDERMINT_LIGHT_PROTO_GLOBAL_ENUMS.SignedMsgType.SIGNED_MSG_TYPE_PRECOMMIT,
            height: commit.height,
            round: commit.round,
            block_id: commit.block_id, // TODO: this is not exact copy
            timestamp: commitSig.timestamp,
            validator_address: commitSig.validator_address,
            validator_index: int32(valIdx), // TODO: check cast
            signature: commitSig.signature
        });
    }

    function isExpired(SignedHeader.Data memory header, Duration.Data memory trustingPeriod, Duration.Data memory currentTime) internal pure returns (bool) {
        Timestamp.Data memory expirationTime = Timestamp.Data({
            Seconds: header.header.time.Seconds + int64(trustingPeriod.Seconds),
            nanos: header.header.time.nanos
        });

        return GT(
            Timestamp.Data({Seconds: int64(currentTime.Seconds), nanos: 0}),
            expirationTime
        ); // TODO: GTE?
    }

    function isEqual(BlockID.Data memory b1, BlockID.Data memory b2) internal pure returns (bool) {
        if (keccak256(abi.encodePacked(b1.hash)) != keccak256(abi.encodePacked(b2.hash))) {
            return false;
        }

        if (b1.part_set_header.total != b2.part_set_header.total) {
            return false;
        }

        if (keccak256(abi.encodePacked(b1.part_set_header.hash)) != keccak256(abi.encodePacked(b2.part_set_header.hash))) {
            return false;
        }

        return true;
    }

    function isEqual(ConsensusState.Data memory cs1, ConsensusState.Data memory cs2) internal pure returns (bool) {
        return keccak256(abi.encodePacked(ConsensusState.encode(cs1))) == keccak256(abi.encodePacked(ConsensusState.encode(cs2)));
    }

    function GT(Timestamp.Data memory t1, Timestamp.Data memory t2) internal pure returns (bool) {
        if (t1.Seconds > t2.Seconds) {
            return true;
        }

        if (t1.Seconds == t2.Seconds && t1.nanos > t2.nanos) {
            return true;
        }

        return false;
    }

    function hash(SignedHeader.Data memory h) internal pure returns (bytes32) {
        require(h.header.validators_hash.length > 0, "validator hash can't be empty");

        bytes memory hbz = Consensus.encode(h.header.version);
        bytes memory pbt = Timestamp.encode(h.header.time);
        bytes memory bzbi = BlockID.encode(h.header.last_block_id);

        bytes[14] memory all = [
            hbz,
            proto.cdcEncode(h.header.chain_id),
            proto.cdcEncode(h.header.height),
            pbt,
            bzbi,
            proto.cdcEncode(h.header.last_commit_hash),
            proto.cdcEncode(h.header.data_hash),
            proto.cdcEncode(h.header.validators_hash),
            proto.cdcEncode(h.header.next_validators_hash),
            proto.cdcEncode(h.header.consensus_hash),
            proto.cdcEncode(h.header.app_hash),
            proto.cdcEncode(h.header.last_results_hash),
            proto.cdcEncode(h.header.evidence_hash),
            proto.cdcEncode(h.header.proposer_address)
        ];
        
        return crypto.merkleRootHash(all, 0, all.length);
    }

    function hash(ValidatorSet.Data memory vs) internal pure returns (bytes32) {
        return crypto.merkleRootHash(vs.validators, 0, vs.validators.length);
    }

    function getByAddress(ValidatorSet.Data memory vals, bytes memory addr) internal pure returns (uint index, bool found) {
        for (uint idx; idx < vals.validators.length; idx++) {
            if (keccak256(abi.encodePacked(vals.validators[idx].Address)) == keccak256(abi.encodePacked(addr))) {
                return (idx, true);
            }
        }

        return (0, false);
    }

    function getTotalVotingPower(ValidatorSet.Data memory vals) internal pure returns (int64) {
        if (vals.total_voting_power == 0) {
            // Update total voting power
            // TODO: This might be expensive, shouldn't we expect the total voting power already be calculated?

            // it seems you can't overflow addition in solidity:
            // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol#L92
            uint256 sum = 0;
	        uint256 maxInt64 = 1 << 63 -1;
	        uint256 maxTotalVotingPower = maxInt64 / 8;

            for (uint i = 0; i < vals.validators.length; i++) {
                sum += uint256(vals.validators[i].voting_power);
                require(sum <= maxTotalVotingPower, "total voting power should be guarded to not exceed");
            }

            vals.total_voting_power = int64(sum);
        }

        return vals.total_voting_power;
    }
}
