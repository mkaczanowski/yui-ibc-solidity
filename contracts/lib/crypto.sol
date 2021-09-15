pragma solidity ^0.6.8;

import { Validator } from "../core/types/tendermint_light.sol";
import "./tendermint.sol";

library crypto {
    using tendermint for Validator.Data;

    function ed25519Verify(bytes memory message, bytes memory publicKey, bytes memory signature) internal view returns (bool) {
        require(signature.length == 64, "siganture length != 64");
        require(publicKey.length == 32, "pubkey length != 32");

        bytes memory all = abi.encodePacked(publicKey, signature, message);
        bytes32 result = 0x0000000000000000000000000000000000000000000000000000000000000001;

        assembly {
            let success := staticcall(gas(), 0xf3, add(all, 0x20), mload(all), result, 0x20)

            switch success
            case 0 {
                revert(0, "ed25519 precompile failed")
            } default {
                result := mload(result)
            }
        }

        // result > 0 is an error
        return (bytes32(0x0000000000000000000000000000000000000000000000000000000000000000) == result);
    }

    /***** MERKLE TREE *****/
    function emptyHash() internal pure returns (bytes32) {
        bytes memory data;
        return sha256(data);
    }

    // returns tmhash(0x00 || leaf)
    function leafHash(bytes memory leaf) internal pure returns (bytes32) {
        byte leafPrefix = 0x00;
        return sha256(abi.encodePacked(leafPrefix, leaf));
    }

    // returns tmhash(0x01 || left || right)
    function innerHash(bytes32 leaf, bytes32 right) internal pure returns (bytes32) {
        byte innerPrefix = 0x01;
        return sha256(abi.encodePacked(innerPrefix, leaf, right));
    }

    // getSplitPoint returns the largest power of 2 less than length
    function getSplitPoint(uint256 input) internal pure returns (uint) {
        // TODO: this could be more performant with bit shifitng magic
        // https://www.baeldung.com/java-largest-power-of-2-less-than-number
        require(input > 1, "invalid input");

        uint result = 1;
        for (uint i = input - 1; i > 1; i--) {
            if ((i & (i - 1)) == 0) {
                result = i;
                break;
            }
        }
        return result;
    }

    // merkleRootHash computes a Merkle tree where the leaves are validators,
    // in the provided order. It follows RFC-6962.
    function merkleRootHash(Validator.Data[] memory validators, uint start, uint total) internal pure returns (bytes32) {
        if (total == 0) {
            return emptyHash();
        } else if (total == 1) {
            bytes memory encodedValidator = SimpleValidator.encode(validators[start].toSimpleValidator());
            return leafHash(encodedValidator);
        }  else {
            uint k = getSplitPoint(total);
            bytes32 left = merkleRootHash(validators, start, k); // validators[:k]
            bytes32 right = merkleRootHash(validators, start+k, total-k); // validators[k:]
            return innerHash(left, right);
        }
    }

    // merkleRootHash computes a Merkle tree where the leaves are the byte slice,
    // in the provided order. It follows RFC-6962.
    function merkleRootHash(bytes[14] memory validators, uint start, uint total) internal pure returns (bytes32) {
        if (total == 0) {
            return emptyHash();
        } else if (total == 1) {
            return leafHash(validators[start]);
        }  else {
            uint k = getSplitPoint(total);
            bytes32 left = merkleRootHash(validators, start, k); // validators[:k]
            bytes32 right = merkleRootHash(validators, start+k, total-k); // validators[k:]
            return innerHash(left, right);
        }
    }
}
