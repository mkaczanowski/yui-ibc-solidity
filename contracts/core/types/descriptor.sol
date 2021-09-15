// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.8;
import "./ProtoBufRuntime.sol";
import "./GoogleProtobufAny.sol";

library GoogleProtobufFileDescriptorSet {


  //struct definition
  struct Data {
    GoogleProtobufFileDescriptorProto.Data[] file;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[2] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_file(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.file = new GoogleProtobufFileDescriptorProto.Data[](counters[1]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_file(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_file(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[2] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufFileDescriptorProto.Data memory x, uint256 sz) = _decode_GoogleProtobufFileDescriptorProto(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.file[r.file.length - counters[1]] = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufFileDescriptorProto(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufFileDescriptorProto.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufFileDescriptorProto.Data memory r, ) = GoogleProtobufFileDescriptorProto._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    for(i = 0; i < r.file.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        1,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufFileDescriptorProto._encode_nested(r.file[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    for(i = 0; i < r.file.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufFileDescriptorProto._estimate(r.file[i]));
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {

    for(uint256 i1 = 0; i1 < input.file.length; i1++) {
      output.file.push(input.file[i1]);
    }
    

  }


  //array helpers for File
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addFile(Data memory self, GoogleProtobufFileDescriptorProto.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufFileDescriptorProto.Data[] memory tmp = new GoogleProtobufFileDescriptorProto.Data[](self.file.length + 1);
    for (uint256 i = 0; i < self.file.length; i++) {
      tmp[i] = self.file[i];
    }
    tmp[self.file.length] = value;
    self.file = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufFileDescriptorSet

library GoogleProtobufFileDescriptorProto {


  //struct definition
  struct Data {
    string name;
    string package;
    string[] dependency;
    int32[] public_dependency;
    int32[] weak_dependency;
    GoogleProtobufDescriptorProto.Data[] message_type;
    GoogleProtobufEnumDescriptorProto.Data[] enum_type;
    GoogleProtobufServiceDescriptorProto.Data[] service;
    GoogleProtobufFieldDescriptorProto.Data[] extension;
    GoogleProtobufFileOptions.Data options;
    GoogleProtobufSourceCodeInfo.Data source_code_info;
    string syntax;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[13] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_name(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_package(pointer, bs, r, counters);
      }
      else if (fieldId == 3) {
        pointer += _read_dependency(pointer, bs, nil(), counters);
      }
      else if (fieldId == 10) {
        pointer += _read_public_dependency(pointer, bs, nil(), counters);
      }
      else if (fieldId == 11) {
        pointer += _read_weak_dependency(pointer, bs, nil(), counters);
      }
      else if (fieldId == 4) {
        pointer += _read_message_type(pointer, bs, nil(), counters);
      }
      else if (fieldId == 5) {
        pointer += _read_enum_type(pointer, bs, nil(), counters);
      }
      else if (fieldId == 6) {
        pointer += _read_service(pointer, bs, nil(), counters);
      }
      else if (fieldId == 7) {
        pointer += _read_extension(pointer, bs, nil(), counters);
      }
      else if (fieldId == 8) {
        pointer += _read_options(pointer, bs, r, counters);
      }
      else if (fieldId == 9) {
        pointer += _read_source_code_info(pointer, bs, r, counters);
      }
      else if (fieldId == 12) {
        pointer += _read_syntax(pointer, bs, r, counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.dependency = new string[](counters[3]);
    r.public_dependency = new int32[](counters[10]);
    r.weak_dependency = new int32[](counters[11]);
    r.message_type = new GoogleProtobufDescriptorProto.Data[](counters[4]);
    r.enum_type = new GoogleProtobufEnumDescriptorProto.Data[](counters[5]);
    r.service = new GoogleProtobufServiceDescriptorProto.Data[](counters[6]);
    r.extension = new GoogleProtobufFieldDescriptorProto.Data[](counters[7]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_name(pointer, bs, nil(), counters);
      }
      else if (fieldId == 2) {
        pointer += _read_package(pointer, bs, nil(), counters);
      }
      else if (fieldId == 3) {
        pointer += _read_dependency(pointer, bs, r, counters);
      }
      else if (fieldId == 10) {
        pointer += _read_public_dependency(pointer, bs, r, counters);
      }
      else if (fieldId == 11) {
        pointer += _read_weak_dependency(pointer, bs, r, counters);
      }
      else if (fieldId == 4) {
        pointer += _read_message_type(pointer, bs, r, counters);
      }
      else if (fieldId == 5) {
        pointer += _read_enum_type(pointer, bs, r, counters);
      }
      else if (fieldId == 6) {
        pointer += _read_service(pointer, bs, r, counters);
      }
      else if (fieldId == 7) {
        pointer += _read_extension(pointer, bs, r, counters);
      }
      else if (fieldId == 8) {
        pointer += _read_options(pointer, bs, nil(), counters);
      }
      else if (fieldId == 9) {
        pointer += _read_source_code_info(pointer, bs, nil(), counters);
      }
      else if (fieldId == 12) {
        pointer += _read_syntax(pointer, bs, nil(), counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_name(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[13] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.name = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_package(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[13] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.package = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_dependency(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[13] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[3] += 1;
    } else {
      r.dependency[r.dependency.length - counters[3]] = x;
      if (counters[3] > 0) counters[3] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_public_dependency(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[13] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[10] += 1;
    } else {
      r.public_dependency[r.public_dependency.length - counters[10]] = x;
      if (counters[10] > 0) counters[10] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_weak_dependency(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[13] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[11] += 1;
    } else {
      r.weak_dependency[r.weak_dependency.length - counters[11]] = x;
      if (counters[11] > 0) counters[11] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_message_type(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[13] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufDescriptorProto.Data memory x, uint256 sz) = _decode_GoogleProtobufDescriptorProto(p, bs);
    if (isNil(r)) {
      counters[4] += 1;
    } else {
      r.message_type[r.message_type.length - counters[4]] = x;
      if (counters[4] > 0) counters[4] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_enum_type(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[13] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufEnumDescriptorProto.Data memory x, uint256 sz) = _decode_GoogleProtobufEnumDescriptorProto(p, bs);
    if (isNil(r)) {
      counters[5] += 1;
    } else {
      r.enum_type[r.enum_type.length - counters[5]] = x;
      if (counters[5] > 0) counters[5] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_service(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[13] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufServiceDescriptorProto.Data memory x, uint256 sz) = _decode_GoogleProtobufServiceDescriptorProto(p, bs);
    if (isNil(r)) {
      counters[6] += 1;
    } else {
      r.service[r.service.length - counters[6]] = x;
      if (counters[6] > 0) counters[6] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_extension(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[13] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufFieldDescriptorProto.Data memory x, uint256 sz) = _decode_GoogleProtobufFieldDescriptorProto(p, bs);
    if (isNil(r)) {
      counters[7] += 1;
    } else {
      r.extension[r.extension.length - counters[7]] = x;
      if (counters[7] > 0) counters[7] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_options(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[13] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufFileOptions.Data memory x, uint256 sz) = _decode_GoogleProtobufFileOptions(p, bs);
    if (isNil(r)) {
      counters[8] += 1;
    } else {
      r.options = x;
      if (counters[8] > 0) counters[8] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_source_code_info(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[13] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufSourceCodeInfo.Data memory x, uint256 sz) = _decode_GoogleProtobufSourceCodeInfo(p, bs);
    if (isNil(r)) {
      counters[9] += 1;
    } else {
      r.source_code_info = x;
      if (counters[9] > 0) counters[9] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_syntax(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[13] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[12] += 1;
    } else {
      r.syntax = x;
      if (counters[12] > 0) counters[12] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufDescriptorProto(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufDescriptorProto.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufDescriptorProto.Data memory r, ) = GoogleProtobufDescriptorProto._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufEnumDescriptorProto(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufEnumDescriptorProto.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufEnumDescriptorProto.Data memory r, ) = GoogleProtobufEnumDescriptorProto._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufServiceDescriptorProto(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufServiceDescriptorProto.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufServiceDescriptorProto.Data memory r, ) = GoogleProtobufServiceDescriptorProto._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufFieldDescriptorProto(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufFieldDescriptorProto.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufFieldDescriptorProto.Data memory r, ) = GoogleProtobufFieldDescriptorProto._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufFileOptions(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufFileOptions.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufFileOptions.Data memory r, ) = GoogleProtobufFileOptions._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufSourceCodeInfo(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufSourceCodeInfo.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufSourceCodeInfo.Data memory r, ) = GoogleProtobufSourceCodeInfo._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.name, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      2,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.package, pointer, bs);
    for(i = 0; i < r.dependency.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        3,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += ProtoBufRuntime._encode_string(r.dependency[i], pointer, bs);
    }
    for(i = 0; i < r.public_dependency.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        10,
        ProtoBufRuntime.WireType.Varint,
        pointer,
        bs)
      ;
      pointer += ProtoBufRuntime._encode_int32(r.public_dependency[i], pointer, bs);
    }
    for(i = 0; i < r.weak_dependency.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        11,
        ProtoBufRuntime.WireType.Varint,
        pointer,
        bs)
      ;
      pointer += ProtoBufRuntime._encode_int32(r.weak_dependency[i], pointer, bs);
    }
    for(i = 0; i < r.message_type.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        4,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufDescriptorProto._encode_nested(r.message_type[i], pointer, bs);
    }
    for(i = 0; i < r.enum_type.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        5,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufEnumDescriptorProto._encode_nested(r.enum_type[i], pointer, bs);
    }
    for(i = 0; i < r.service.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        6,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufServiceDescriptorProto._encode_nested(r.service[i], pointer, bs);
    }
    for(i = 0; i < r.extension.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        7,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufFieldDescriptorProto._encode_nested(r.extension[i], pointer, bs);
    }
    pointer += ProtoBufRuntime._encode_key(
      8,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += GoogleProtobufFileOptions._encode_nested(r.options, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      9,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += GoogleProtobufSourceCodeInfo._encode_nested(r.source_code_info, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      12,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.syntax, pointer, bs);
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.name).length);
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.package).length);
    for(i = 0; i < r.dependency.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.dependency[i]).length);
    }
    for(i = 0; i < r.public_dependency.length; i++) {
      e += 1 + ProtoBufRuntime._sz_int32(r.public_dependency[i]);
    }
    for(i = 0; i < r.weak_dependency.length; i++) {
      e += 1 + ProtoBufRuntime._sz_int32(r.weak_dependency[i]);
    }
    for(i = 0; i < r.message_type.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufDescriptorProto._estimate(r.message_type[i]));
    }
    for(i = 0; i < r.enum_type.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufEnumDescriptorProto._estimate(r.enum_type[i]));
    }
    for(i = 0; i < r.service.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufServiceDescriptorProto._estimate(r.service[i]));
    }
    for(i = 0; i < r.extension.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufFieldDescriptorProto._estimate(r.extension[i]));
    }
    e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufFileOptions._estimate(r.options));
    e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufSourceCodeInfo._estimate(r.source_code_info));
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.syntax).length);
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.name = input.name;
    output.package = input.package;
    output.dependency = input.dependency;
    output.public_dependency = input.public_dependency;
    output.weak_dependency = input.weak_dependency;

    for(uint256 i4 = 0; i4 < input.message_type.length; i4++) {
      output.message_type.push(input.message_type[i4]);
    }
    

    for(uint256 i5 = 0; i5 < input.enum_type.length; i5++) {
      output.enum_type.push(input.enum_type[i5]);
    }
    

    for(uint256 i6 = 0; i6 < input.service.length; i6++) {
      output.service.push(input.service[i6]);
    }
    

    for(uint256 i7 = 0; i7 < input.extension.length; i7++) {
      output.extension.push(input.extension[i7]);
    }
    
    GoogleProtobufFileOptions.store(input.options, output.options);
    GoogleProtobufSourceCodeInfo.store(input.source_code_info, output.source_code_info);
    output.syntax = input.syntax;

  }


  //array helpers for Dependency
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addDependency(Data memory self, string memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    string[] memory tmp = new string[](self.dependency.length + 1);
    for (uint256 i = 0; i < self.dependency.length; i++) {
      tmp[i] = self.dependency[i];
    }
    tmp[self.dependency.length] = value;
    self.dependency = tmp;
  }

  //array helpers for PublicDependency
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addPublicDependency(Data memory self, int32  value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    int32[] memory tmp = new int32[](self.public_dependency.length + 1);
    for (uint256 i = 0; i < self.public_dependency.length; i++) {
      tmp[i] = self.public_dependency[i];
    }
    tmp[self.public_dependency.length] = value;
    self.public_dependency = tmp;
  }

  //array helpers for WeakDependency
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addWeakDependency(Data memory self, int32  value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    int32[] memory tmp = new int32[](self.weak_dependency.length + 1);
    for (uint256 i = 0; i < self.weak_dependency.length; i++) {
      tmp[i] = self.weak_dependency[i];
    }
    tmp[self.weak_dependency.length] = value;
    self.weak_dependency = tmp;
  }

  //array helpers for MessageType
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addMessageType(Data memory self, GoogleProtobufDescriptorProto.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufDescriptorProto.Data[] memory tmp = new GoogleProtobufDescriptorProto.Data[](self.message_type.length + 1);
    for (uint256 i = 0; i < self.message_type.length; i++) {
      tmp[i] = self.message_type[i];
    }
    tmp[self.message_type.length] = value;
    self.message_type = tmp;
  }

  //array helpers for EnumType
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addEnumType(Data memory self, GoogleProtobufEnumDescriptorProto.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufEnumDescriptorProto.Data[] memory tmp = new GoogleProtobufEnumDescriptorProto.Data[](self.enum_type.length + 1);
    for (uint256 i = 0; i < self.enum_type.length; i++) {
      tmp[i] = self.enum_type[i];
    }
    tmp[self.enum_type.length] = value;
    self.enum_type = tmp;
  }

  //array helpers for Service
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addService(Data memory self, GoogleProtobufServiceDescriptorProto.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufServiceDescriptorProto.Data[] memory tmp = new GoogleProtobufServiceDescriptorProto.Data[](self.service.length + 1);
    for (uint256 i = 0; i < self.service.length; i++) {
      tmp[i] = self.service[i];
    }
    tmp[self.service.length] = value;
    self.service = tmp;
  }

  //array helpers for Extension
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addExtension(Data memory self, GoogleProtobufFieldDescriptorProto.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufFieldDescriptorProto.Data[] memory tmp = new GoogleProtobufFieldDescriptorProto.Data[](self.extension.length + 1);
    for (uint256 i = 0; i < self.extension.length; i++) {
      tmp[i] = self.extension[i];
    }
    tmp[self.extension.length] = value;
    self.extension = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufFileDescriptorProto

library GoogleProtobufDescriptorProto {


  //struct definition
  struct Data {
    string name;
    GoogleProtobufFieldDescriptorProto.Data[] field;
    GoogleProtobufFieldDescriptorProto.Data[] extension;
    GoogleProtobufDescriptorProto.Data[] nested_type;
    GoogleProtobufEnumDescriptorProto.Data[] enum_type;
    GoogleProtobufDescriptorProtoExtensionRange.Data[] extension_range;
    GoogleProtobufOneofDescriptorProto.Data[] oneof_decl;
    GoogleProtobufMessageOptions.Data options;
    GoogleProtobufDescriptorProtoReservedRange.Data[] reserved_range;
    string[] reserved_name;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[11] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_name(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_field(pointer, bs, nil(), counters);
      }
      else if (fieldId == 6) {
        pointer += _read_extension(pointer, bs, nil(), counters);
      }
      else if (fieldId == 3) {
        pointer += _read_nested_type(pointer, bs, nil(), counters);
      }
      else if (fieldId == 4) {
        pointer += _read_enum_type(pointer, bs, nil(), counters);
      }
      else if (fieldId == 5) {
        pointer += _read_extension_range(pointer, bs, nil(), counters);
      }
      else if (fieldId == 8) {
        pointer += _read_oneof_decl(pointer, bs, nil(), counters);
      }
      else if (fieldId == 7) {
        pointer += _read_options(pointer, bs, r, counters);
      }
      else if (fieldId == 9) {
        pointer += _read_reserved_range(pointer, bs, nil(), counters);
      }
      else if (fieldId == 10) {
        pointer += _read_reserved_name(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.field = new GoogleProtobufFieldDescriptorProto.Data[](counters[2]);
    r.extension = new GoogleProtobufFieldDescriptorProto.Data[](counters[6]);
    r.nested_type = new GoogleProtobufDescriptorProto.Data[](counters[3]);
    r.enum_type = new GoogleProtobufEnumDescriptorProto.Data[](counters[4]);
    r.extension_range = new GoogleProtobufDescriptorProtoExtensionRange.Data[](counters[5]);
    r.oneof_decl = new GoogleProtobufOneofDescriptorProto.Data[](counters[8]);
    r.reserved_range = new GoogleProtobufDescriptorProtoReservedRange.Data[](counters[9]);
    r.reserved_name = new string[](counters[10]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_name(pointer, bs, nil(), counters);
      }
      else if (fieldId == 2) {
        pointer += _read_field(pointer, bs, r, counters);
      }
      else if (fieldId == 6) {
        pointer += _read_extension(pointer, bs, r, counters);
      }
      else if (fieldId == 3) {
        pointer += _read_nested_type(pointer, bs, r, counters);
      }
      else if (fieldId == 4) {
        pointer += _read_enum_type(pointer, bs, r, counters);
      }
      else if (fieldId == 5) {
        pointer += _read_extension_range(pointer, bs, r, counters);
      }
      else if (fieldId == 8) {
        pointer += _read_oneof_decl(pointer, bs, r, counters);
      }
      else if (fieldId == 7) {
        pointer += _read_options(pointer, bs, nil(), counters);
      }
      else if (fieldId == 9) {
        pointer += _read_reserved_range(pointer, bs, r, counters);
      }
      else if (fieldId == 10) {
        pointer += _read_reserved_name(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_name(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[11] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.name = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_field(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[11] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufFieldDescriptorProto.Data memory x, uint256 sz) = _decode_GoogleProtobufFieldDescriptorProto(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.field[r.field.length - counters[2]] = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_extension(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[11] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufFieldDescriptorProto.Data memory x, uint256 sz) = _decode_GoogleProtobufFieldDescriptorProto(p, bs);
    if (isNil(r)) {
      counters[6] += 1;
    } else {
      r.extension[r.extension.length - counters[6]] = x;
      if (counters[6] > 0) counters[6] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_nested_type(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[11] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufDescriptorProto.Data memory x, uint256 sz) = _decode_GoogleProtobufDescriptorProto(p, bs);
    if (isNil(r)) {
      counters[3] += 1;
    } else {
      r.nested_type[r.nested_type.length - counters[3]] = x;
      if (counters[3] > 0) counters[3] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_enum_type(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[11] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufEnumDescriptorProto.Data memory x, uint256 sz) = _decode_GoogleProtobufEnumDescriptorProto(p, bs);
    if (isNil(r)) {
      counters[4] += 1;
    } else {
      r.enum_type[r.enum_type.length - counters[4]] = x;
      if (counters[4] > 0) counters[4] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_extension_range(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[11] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufDescriptorProtoExtensionRange.Data memory x, uint256 sz) = _decode_GoogleProtobufDescriptorProtoExtensionRange(p, bs);
    if (isNil(r)) {
      counters[5] += 1;
    } else {
      r.extension_range[r.extension_range.length - counters[5]] = x;
      if (counters[5] > 0) counters[5] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_oneof_decl(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[11] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufOneofDescriptorProto.Data memory x, uint256 sz) = _decode_GoogleProtobufOneofDescriptorProto(p, bs);
    if (isNil(r)) {
      counters[8] += 1;
    } else {
      r.oneof_decl[r.oneof_decl.length - counters[8]] = x;
      if (counters[8] > 0) counters[8] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_options(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[11] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufMessageOptions.Data memory x, uint256 sz) = _decode_GoogleProtobufMessageOptions(p, bs);
    if (isNil(r)) {
      counters[7] += 1;
    } else {
      r.options = x;
      if (counters[7] > 0) counters[7] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_reserved_range(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[11] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufDescriptorProtoReservedRange.Data memory x, uint256 sz) = _decode_GoogleProtobufDescriptorProtoReservedRange(p, bs);
    if (isNil(r)) {
      counters[9] += 1;
    } else {
      r.reserved_range[r.reserved_range.length - counters[9]] = x;
      if (counters[9] > 0) counters[9] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_reserved_name(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[11] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[10] += 1;
    } else {
      r.reserved_name[r.reserved_name.length - counters[10]] = x;
      if (counters[10] > 0) counters[10] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
//////////////  function _decode_GoogleProtobufFieldDescriptorProto(uint256 p, bytes memory bs)
//////////////    internal
//////////////    pure
//////////////    returns (GoogleProtobufFieldDescriptorProto.Data memory, uint)
//////////////  {
//////////////    uint256 pointer = p;
//////////////    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
//////////////    pointer += bytesRead;
//////////////    (GoogleProtobufFieldDescriptorProto.Data memory r, ) = GoogleProtobufFieldDescriptorProto._decode(pointer, bs, sz);
//////////////    return (r, sz + bytesRead);
//////////////  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufFieldDescriptorProto(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufFieldDescriptorProto.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufFieldDescriptorProto.Data memory r, ) = GoogleProtobufFieldDescriptorProto._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufDescriptorProto(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufDescriptorProto.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufDescriptorProto.Data memory r, ) = GoogleProtobufDescriptorProto._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufEnumDescriptorProto(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufEnumDescriptorProto.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufEnumDescriptorProto.Data memory r, ) = GoogleProtobufEnumDescriptorProto._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufDescriptorProtoExtensionRange(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufDescriptorProtoExtensionRange.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufDescriptorProtoExtensionRange.Data memory r, ) = GoogleProtobufDescriptorProtoExtensionRange._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufOneofDescriptorProto(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufOneofDescriptorProto.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufOneofDescriptorProto.Data memory r, ) = GoogleProtobufOneofDescriptorProto._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufMessageOptions(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufMessageOptions.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufMessageOptions.Data memory r, ) = GoogleProtobufMessageOptions._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufDescriptorProtoReservedRange(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufDescriptorProtoReservedRange.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufDescriptorProtoReservedRange.Data memory r, ) = GoogleProtobufDescriptorProtoReservedRange._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.name, pointer, bs);
    for(i = 0; i < r.field.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        2,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufFieldDescriptorProto._encode_nested(r.field[i], pointer, bs);
    }
    for(i = 0; i < r.extension.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        6,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufFieldDescriptorProto._encode_nested(r.extension[i], pointer, bs);
    }
    for(i = 0; i < r.nested_type.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        3,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufDescriptorProto._encode_nested(r.nested_type[i], pointer, bs);
    }
    for(i = 0; i < r.enum_type.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        4,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufEnumDescriptorProto._encode_nested(r.enum_type[i], pointer, bs);
    }
    for(i = 0; i < r.extension_range.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        5,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufDescriptorProtoExtensionRange._encode_nested(r.extension_range[i], pointer, bs);
    }
    for(i = 0; i < r.oneof_decl.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        8,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufOneofDescriptorProto._encode_nested(r.oneof_decl[i], pointer, bs);
    }
    pointer += ProtoBufRuntime._encode_key(
      7,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += GoogleProtobufMessageOptions._encode_nested(r.options, pointer, bs);
    for(i = 0; i < r.reserved_range.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        9,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufDescriptorProtoReservedRange._encode_nested(r.reserved_range[i], pointer, bs);
    }
    for(i = 0; i < r.reserved_name.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        10,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += ProtoBufRuntime._encode_string(r.reserved_name[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.name).length);
    for(i = 0; i < r.field.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufFieldDescriptorProto._estimate(r.field[i]));
    }
    for(i = 0; i < r.extension.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufFieldDescriptorProto._estimate(r.extension[i]));
    }
    for(i = 0; i < r.nested_type.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufDescriptorProto._estimate(r.nested_type[i]));
    }
    for(i = 0; i < r.enum_type.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufEnumDescriptorProto._estimate(r.enum_type[i]));
    }
    for(i = 0; i < r.extension_range.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufDescriptorProtoExtensionRange._estimate(r.extension_range[i]));
    }
    for(i = 0; i < r.oneof_decl.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufOneofDescriptorProto._estimate(r.oneof_decl[i]));
    }
    e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufMessageOptions._estimate(r.options));
    for(i = 0; i < r.reserved_range.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufDescriptorProtoReservedRange._estimate(r.reserved_range[i]));
    }
    for(i = 0; i < r.reserved_name.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.reserved_name[i]).length);
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.name = input.name;

    for(uint256 i2 = 0; i2 < input.field.length; i2++) {
      output.field.push(input.field[i2]);
    }
    

    for(uint256 i6 = 0; i6 < input.extension.length; i6++) {
      output.extension.push(input.extension[i6]);
    }
    

    for(uint256 i3 = 0; i3 < input.nested_type.length; i3++) {
      output.nested_type.push(input.nested_type[i3]);
    }
    

    for(uint256 i4 = 0; i4 < input.enum_type.length; i4++) {
      output.enum_type.push(input.enum_type[i4]);
    }
    

    for(uint256 i5 = 0; i5 < input.extension_range.length; i5++) {
      output.extension_range.push(input.extension_range[i5]);
    }
    

    for(uint256 i8 = 0; i8 < input.oneof_decl.length; i8++) {
      output.oneof_decl.push(input.oneof_decl[i8]);
    }
    
    GoogleProtobufMessageOptions.store(input.options, output.options);

    for(uint256 i9 = 0; i9 < input.reserved_range.length; i9++) {
      output.reserved_range.push(input.reserved_range[i9]);
    }
    
    output.reserved_name = input.reserved_name;

  }


  //array helpers for Field
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addField(Data memory self, GoogleProtobufFieldDescriptorProto.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufFieldDescriptorProto.Data[] memory tmp = new GoogleProtobufFieldDescriptorProto.Data[](self.field.length + 1);
    for (uint256 i = 0; i < self.field.length; i++) {
      tmp[i] = self.field[i];
    }
    tmp[self.field.length] = value;
    self.field = tmp;
  }

  //array helpers for Extension
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addExtension(Data memory self, GoogleProtobufFieldDescriptorProto.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufFieldDescriptorProto.Data[] memory tmp = new GoogleProtobufFieldDescriptorProto.Data[](self.extension.length + 1);
    for (uint256 i = 0; i < self.extension.length; i++) {
      tmp[i] = self.extension[i];
    }
    tmp[self.extension.length] = value;
    self.extension = tmp;
  }

  //array helpers for NestedType
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addNestedType(Data memory self, GoogleProtobufDescriptorProto.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufDescriptorProto.Data[] memory tmp = new GoogleProtobufDescriptorProto.Data[](self.nested_type.length + 1);
    for (uint256 i = 0; i < self.nested_type.length; i++) {
      tmp[i] = self.nested_type[i];
    }
    tmp[self.nested_type.length] = value;
    self.nested_type = tmp;
  }

  //array helpers for EnumType
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addEnumType(Data memory self, GoogleProtobufEnumDescriptorProto.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufEnumDescriptorProto.Data[] memory tmp = new GoogleProtobufEnumDescriptorProto.Data[](self.enum_type.length + 1);
    for (uint256 i = 0; i < self.enum_type.length; i++) {
      tmp[i] = self.enum_type[i];
    }
    tmp[self.enum_type.length] = value;
    self.enum_type = tmp;
  }

  //array helpers for ExtensionRange
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addExtensionRange(Data memory self, GoogleProtobufDescriptorProtoExtensionRange.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufDescriptorProtoExtensionRange.Data[] memory tmp = new GoogleProtobufDescriptorProtoExtensionRange.Data[](self.extension_range.length + 1);
    for (uint256 i = 0; i < self.extension_range.length; i++) {
      tmp[i] = self.extension_range[i];
    }
    tmp[self.extension_range.length] = value;
    self.extension_range = tmp;
  }

  //array helpers for OneofDecl
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addOneofDecl(Data memory self, GoogleProtobufOneofDescriptorProto.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufOneofDescriptorProto.Data[] memory tmp = new GoogleProtobufOneofDescriptorProto.Data[](self.oneof_decl.length + 1);
    for (uint256 i = 0; i < self.oneof_decl.length; i++) {
      tmp[i] = self.oneof_decl[i];
    }
    tmp[self.oneof_decl.length] = value;
    self.oneof_decl = tmp;
  }

  //array helpers for ReservedRange
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addReservedRange(Data memory self, GoogleProtobufDescriptorProtoReservedRange.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufDescriptorProtoReservedRange.Data[] memory tmp = new GoogleProtobufDescriptorProtoReservedRange.Data[](self.reserved_range.length + 1);
    for (uint256 i = 0; i < self.reserved_range.length; i++) {
      tmp[i] = self.reserved_range[i];
    }
    tmp[self.reserved_range.length] = value;
    self.reserved_range = tmp;
  }

  //array helpers for ReservedName
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addReservedName(Data memory self, string memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    string[] memory tmp = new string[](self.reserved_name.length + 1);
    for (uint256 i = 0; i < self.reserved_name.length; i++) {
      tmp[i] = self.reserved_name[i];
    }
    tmp[self.reserved_name.length] = value;
    self.reserved_name = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufDescriptorProto

library GoogleProtobufDescriptorProtoExtensionRange {


  //struct definition
  struct Data {
    int32 start;
    int32 end;
    GoogleProtobufExtensionRangeOptions.Data options;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[4] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_start(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_end(pointer, bs, r, counters);
      }
      else if (fieldId == 3) {
        pointer += _read_options(pointer, bs, r, counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_start(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[4] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.start = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_end(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[4] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.end = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_options(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[4] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufExtensionRangeOptions.Data memory x, uint256 sz) = _decode_GoogleProtobufExtensionRangeOptions(p, bs);
    if (isNil(r)) {
      counters[3] += 1;
    } else {
      r.options = x;
      if (counters[3] > 0) counters[3] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufExtensionRangeOptions(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufExtensionRangeOptions.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufExtensionRangeOptions.Data memory r, ) = GoogleProtobufExtensionRangeOptions._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_int32(r.start, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      2,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_int32(r.end, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      3,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += GoogleProtobufExtensionRangeOptions._encode_nested(r.options, pointer, bs);
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;
    e += 1 + ProtoBufRuntime._sz_int32(r.start);
    e += 1 + ProtoBufRuntime._sz_int32(r.end);
    e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufExtensionRangeOptions._estimate(r.options));
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.start = input.start;
    output.end = input.end;
    GoogleProtobufExtensionRangeOptions.store(input.options, output.options);

  }



  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufDescriptorProtoExtensionRange

library GoogleProtobufDescriptorProtoReservedRange {


  //struct definition
  struct Data {
    int32 start;
    int32 end;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[3] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_start(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_end(pointer, bs, r, counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_start(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[3] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.start = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_end(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[3] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.end = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_int32(r.start, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      2,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_int32(r.end, pointer, bs);
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;
    e += 1 + ProtoBufRuntime._sz_int32(r.start);
    e += 1 + ProtoBufRuntime._sz_int32(r.end);
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.start = input.start;
    output.end = input.end;

  }



  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufDescriptorProtoReservedRange

library GoogleProtobufExtensionRangeOptions {


  //struct definition
  struct Data {
    GoogleProtobufUninterpretedOption.Data[] uninterpreted_option;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[1000] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.uninterpreted_option = new GoogleProtobufUninterpretedOption.Data[](counters[999]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_uninterpreted_option(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufUninterpretedOption.Data memory x, uint256 sz) = _decode_GoogleProtobufUninterpretedOption(p, bs);
    if (isNil(r)) {
      counters[999] += 1;
    } else {
      r.uninterpreted_option[r.uninterpreted_option.length - counters[999]] = x;
      if (counters[999] > 0) counters[999] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufUninterpretedOption(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufUninterpretedOption.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufUninterpretedOption.Data memory r, ) = GoogleProtobufUninterpretedOption._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        999,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufUninterpretedOption._encode_nested(r.uninterpreted_option[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      e += 2 + ProtoBufRuntime._sz_lendelim(GoogleProtobufUninterpretedOption._estimate(r.uninterpreted_option[i]));
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {

    for(uint256 i999 = 0; i999 < input.uninterpreted_option.length; i999++) {
      output.uninterpreted_option.push(input.uninterpreted_option[i999]);
    }
    

  }


  //array helpers for UninterpretedOption
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addUninterpretedOption(Data memory self, GoogleProtobufUninterpretedOption.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufUninterpretedOption.Data[] memory tmp = new GoogleProtobufUninterpretedOption.Data[](self.uninterpreted_option.length + 1);
    for (uint256 i = 0; i < self.uninterpreted_option.length; i++) {
      tmp[i] = self.uninterpreted_option[i];
    }
    tmp[self.uninterpreted_option.length] = value;
    self.uninterpreted_option = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufExtensionRangeOptions

library GoogleProtobufFieldDescriptorProto {

  //enum definition
  // Solidity enum definitions
  enum Type {
    TYPE_DOUBLE,
    TYPE_FLOAT,
    TYPE_INT64,
    TYPE_UINT64,
    TYPE_INT32,
    TYPE_FIXED64,
    TYPE_FIXED32,
    TYPE_BOOL,
    TYPE_STRING,
    TYPE_GROUP,
    TYPE_MESSAGE,
    TYPE_BYTES,
    TYPE_UINT32,
    TYPE_ENUM,
    TYPE_SFIXED32,
    TYPE_SFIXED64,
    TYPE_SINT32,
    TYPE_SINT64
  }


  // Solidity enum encoder
  function encode_Type(Type x) internal pure returns (int64) {
    
    if (x == Type.TYPE_DOUBLE) {
      return 1;
    }

    if (x == Type.TYPE_FLOAT) {
      return 2;
    }

    if (x == Type.TYPE_INT64) {
      return 3;
    }

    if (x == Type.TYPE_UINT64) {
      return 4;
    }

    if (x == Type.TYPE_INT32) {
      return 5;
    }

    if (x == Type.TYPE_FIXED64) {
      return 6;
    }

    if (x == Type.TYPE_FIXED32) {
      return 7;
    }

    if (x == Type.TYPE_BOOL) {
      return 8;
    }

    if (x == Type.TYPE_STRING) {
      return 9;
    }

    if (x == Type.TYPE_GROUP) {
      return 10;
    }

    if (x == Type.TYPE_MESSAGE) {
      return 11;
    }

    if (x == Type.TYPE_BYTES) {
      return 12;
    }

    if (x == Type.TYPE_UINT32) {
      return 13;
    }

    if (x == Type.TYPE_ENUM) {
      return 14;
    }

    if (x == Type.TYPE_SFIXED32) {
      return 15;
    }

    if (x == Type.TYPE_SFIXED64) {
      return 16;
    }

    if (x == Type.TYPE_SINT32) {
      return 17;
    }

    if (x == Type.TYPE_SINT64) {
      return 18;
    }
    revert();
  }


  // Solidity enum decoder
  function decode_Type(int64 x) internal pure returns (Type) {
    
    if (x == 1) {
      return Type.TYPE_DOUBLE;
    }

    if (x == 2) {
      return Type.TYPE_FLOAT;
    }

    if (x == 3) {
      return Type.TYPE_INT64;
    }

    if (x == 4) {
      return Type.TYPE_UINT64;
    }

    if (x == 5) {
      return Type.TYPE_INT32;
    }

    if (x == 6) {
      return Type.TYPE_FIXED64;
    }

    if (x == 7) {
      return Type.TYPE_FIXED32;
    }

    if (x == 8) {
      return Type.TYPE_BOOL;
    }

    if (x == 9) {
      return Type.TYPE_STRING;
    }

    if (x == 10) {
      return Type.TYPE_GROUP;
    }

    if (x == 11) {
      return Type.TYPE_MESSAGE;
    }

    if (x == 12) {
      return Type.TYPE_BYTES;
    }

    if (x == 13) {
      return Type.TYPE_UINT32;
    }

    if (x == 14) {
      return Type.TYPE_ENUM;
    }

    if (x == 15) {
      return Type.TYPE_SFIXED32;
    }

    if (x == 16) {
      return Type.TYPE_SFIXED64;
    }

    if (x == 17) {
      return Type.TYPE_SINT32;
    }

    if (x == 18) {
      return Type.TYPE_SINT64;
    }
    revert();
  }


  // Solidity enum definitions
  enum Label {
    LABEL_OPTIONAL,
    LABEL_REQUIRED,
    LABEL_REPEATED
  }


  // Solidity enum encoder
  function encode_Label(Label x) internal pure returns (int64) {
    
    if (x == Label.LABEL_OPTIONAL) {
      return 1;
    }

    if (x == Label.LABEL_REQUIRED) {
      return 2;
    }

    if (x == Label.LABEL_REPEATED) {
      return 3;
    }
    revert();
  }


  // Solidity enum decoder
  function decode_Label(int64 x) internal pure returns (Label) {
    
    if (x == 1) {
      return Label.LABEL_OPTIONAL;
    }

    if (x == 2) {
      return Label.LABEL_REQUIRED;
    }

    if (x == 3) {
      return Label.LABEL_REPEATED;
    }
    revert();
  }


  //struct definition
  struct Data {
    string name;
    int32 number;
    GoogleProtobufFieldDescriptorProto.Label label;
    GoogleProtobufFieldDescriptorProto.Type Type;
    string type_name;
    string extendee;
    string default_value;
    int32 oneof_index;
    string json_name;
    GoogleProtobufFieldOptions.Data options;
    bool proto3_optional;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[18] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_name(pointer, bs, r, counters);
      }
      else if (fieldId == 3) {
        pointer += _read_number(pointer, bs, r, counters);
      }
      else if (fieldId == 4) {
        pointer += _read_label(pointer, bs, r, counters);
      }
      else if (fieldId == 5) {
        pointer += _read_Type(pointer, bs, r, counters);
      }
      else if (fieldId == 6) {
        pointer += _read_type_name(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_extendee(pointer, bs, r, counters);
      }
      else if (fieldId == 7) {
        pointer += _read_default_value(pointer, bs, r, counters);
      }
      else if (fieldId == 9) {
        pointer += _read_oneof_index(pointer, bs, r, counters);
      }
      else if (fieldId == 10) {
        pointer += _read_json_name(pointer, bs, r, counters);
      }
      else if (fieldId == 8) {
        pointer += _read_options(pointer, bs, r, counters);
      }
      else if (fieldId == 17) {
        pointer += _read_proto3_optional(pointer, bs, r, counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_name(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[18] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.name = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_number(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[18] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[3] += 1;
    } else {
      r.number = x;
      if (counters[3] > 0) counters[3] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_label(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[18] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int64 tmp, uint256 sz) = ProtoBufRuntime._decode_enum(p, bs);
    GoogleProtobufFieldDescriptorProto.Label x = GoogleProtobufFieldDescriptorProto.decode_Label(tmp);
    if (isNil(r)) {
      counters[4] += 1;
    } else {
      r.label = x;
      if(counters[4] > 0) counters[4] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_Type(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[18] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int64 tmp, uint256 sz) = ProtoBufRuntime._decode_enum(p, bs);
    GoogleProtobufFieldDescriptorProto.Type x = GoogleProtobufFieldDescriptorProto.decode_Type(tmp);
    if (isNil(r)) {
      counters[5] += 1;
    } else {
      r.Type = x;
      if(counters[5] > 0) counters[5] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_type_name(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[18] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[6] += 1;
    } else {
      r.type_name = x;
      if (counters[6] > 0) counters[6] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_extendee(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[18] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.extendee = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_default_value(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[18] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[7] += 1;
    } else {
      r.default_value = x;
      if (counters[7] > 0) counters[7] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_oneof_index(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[18] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[9] += 1;
    } else {
      r.oneof_index = x;
      if (counters[9] > 0) counters[9] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_json_name(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[18] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[10] += 1;
    } else {
      r.json_name = x;
      if (counters[10] > 0) counters[10] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_options(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[18] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufFieldOptions.Data memory x, uint256 sz) = _decode_GoogleProtobufFieldOptions(p, bs);
    if (isNil(r)) {
      counters[8] += 1;
    } else {
      r.options = x;
      if (counters[8] > 0) counters[8] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_proto3_optional(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[18] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[17] += 1;
    } else {
      r.proto3_optional = x;
      if (counters[17] > 0) counters[17] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufFieldOptions(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufFieldOptions.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufFieldOptions.Data memory r, ) = GoogleProtobufFieldOptions._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.name, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      3,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_int32(r.number, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      4,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    int64 _enum_label = GoogleProtobufFieldDescriptorProto.encode_Label(r.label);
    pointer += ProtoBufRuntime._encode_enum(_enum_label, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      5,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    int64 _enum_Type = GoogleProtobufFieldDescriptorProto.encode_Type(r.Type);
    pointer += ProtoBufRuntime._encode_enum(_enum_Type, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      6,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.type_name, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      2,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.extendee, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      7,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.default_value, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      9,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_int32(r.oneof_index, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      10,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.json_name, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      8,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += GoogleProtobufFieldOptions._encode_nested(r.options, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      17,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.proto3_optional, pointer, bs);
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.name).length);
    e += 1 + ProtoBufRuntime._sz_int32(r.number);
    e += 1 + ProtoBufRuntime._sz_enum(GoogleProtobufFieldDescriptorProto.encode_Label(r.label));
    e += 1 + ProtoBufRuntime._sz_enum(GoogleProtobufFieldDescriptorProto.encode_Type(r.Type));
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.type_name).length);
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.extendee).length);
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.default_value).length);
    e += 1 + ProtoBufRuntime._sz_int32(r.oneof_index);
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.json_name).length);
    e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufFieldOptions._estimate(r.options));
    e += 2 + 1;
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.name = input.name;
    output.number = input.number;
    output.label = input.label;
    output.Type = input.Type;
    output.type_name = input.type_name;
    output.extendee = input.extendee;
    output.default_value = input.default_value;
    output.oneof_index = input.oneof_index;
    output.json_name = input.json_name;
    GoogleProtobufFieldOptions.store(input.options, output.options);
    output.proto3_optional = input.proto3_optional;

  }



  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufFieldDescriptorProto

library GoogleProtobufOneofDescriptorProto {


  //struct definition
  struct Data {
    string name;
    GoogleProtobufOneofOptions.Data options;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[3] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_name(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_options(pointer, bs, r, counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_name(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[3] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.name = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_options(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[3] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufOneofOptions.Data memory x, uint256 sz) = _decode_GoogleProtobufOneofOptions(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.options = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufOneofOptions(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufOneofOptions.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufOneofOptions.Data memory r, ) = GoogleProtobufOneofOptions._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.name, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      2,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += GoogleProtobufOneofOptions._encode_nested(r.options, pointer, bs);
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.name).length);
    e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufOneofOptions._estimate(r.options));
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.name = input.name;
    GoogleProtobufOneofOptions.store(input.options, output.options);

  }



  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufOneofDescriptorProto

library GoogleProtobufEnumDescriptorProto {


  //struct definition
  struct Data {
    string name;
    GoogleProtobufEnumValueDescriptorProto.Data[] value;
    GoogleProtobufEnumOptions.Data options;
    GoogleProtobufEnumDescriptorProtoEnumReservedRange.Data[] reserved_range;
    string[] reserved_name;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[6] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_name(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_value(pointer, bs, nil(), counters);
      }
      else if (fieldId == 3) {
        pointer += _read_options(pointer, bs, r, counters);
      }
      else if (fieldId == 4) {
        pointer += _read_reserved_range(pointer, bs, nil(), counters);
      }
      else if (fieldId == 5) {
        pointer += _read_reserved_name(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.value = new GoogleProtobufEnumValueDescriptorProto.Data[](counters[2]);
    r.reserved_range = new GoogleProtobufEnumDescriptorProtoEnumReservedRange.Data[](counters[4]);
    r.reserved_name = new string[](counters[5]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_name(pointer, bs, nil(), counters);
      }
      else if (fieldId == 2) {
        pointer += _read_value(pointer, bs, r, counters);
      }
      else if (fieldId == 3) {
        pointer += _read_options(pointer, bs, nil(), counters);
      }
      else if (fieldId == 4) {
        pointer += _read_reserved_range(pointer, bs, r, counters);
      }
      else if (fieldId == 5) {
        pointer += _read_reserved_name(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_name(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[6] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.name = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_value(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[6] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufEnumValueDescriptorProto.Data memory x, uint256 sz) = _decode_GoogleProtobufEnumValueDescriptorProto(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.value[r.value.length - counters[2]] = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_options(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[6] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufEnumOptions.Data memory x, uint256 sz) = _decode_GoogleProtobufEnumOptions(p, bs);
    if (isNil(r)) {
      counters[3] += 1;
    } else {
      r.options = x;
      if (counters[3] > 0) counters[3] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_reserved_range(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[6] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufEnumDescriptorProtoEnumReservedRange.Data memory x, uint256 sz) = _decode_GoogleProtobufEnumDescriptorProtoEnumReservedRange(p, bs);
    if (isNil(r)) {
      counters[4] += 1;
    } else {
      r.reserved_range[r.reserved_range.length - counters[4]] = x;
      if (counters[4] > 0) counters[4] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_reserved_name(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[6] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[5] += 1;
    } else {
      r.reserved_name[r.reserved_name.length - counters[5]] = x;
      if (counters[5] > 0) counters[5] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufEnumValueDescriptorProto(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufEnumValueDescriptorProto.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufEnumValueDescriptorProto.Data memory r, ) = GoogleProtobufEnumValueDescriptorProto._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufEnumOptions(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufEnumOptions.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufEnumOptions.Data memory r, ) = GoogleProtobufEnumOptions._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufEnumDescriptorProtoEnumReservedRange(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufEnumDescriptorProtoEnumReservedRange.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufEnumDescriptorProtoEnumReservedRange.Data memory r, ) = GoogleProtobufEnumDescriptorProtoEnumReservedRange._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.name, pointer, bs);
    for(i = 0; i < r.value.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        2,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufEnumValueDescriptorProto._encode_nested(r.value[i], pointer, bs);
    }
    pointer += ProtoBufRuntime._encode_key(
      3,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += GoogleProtobufEnumOptions._encode_nested(r.options, pointer, bs);
    for(i = 0; i < r.reserved_range.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        4,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufEnumDescriptorProtoEnumReservedRange._encode_nested(r.reserved_range[i], pointer, bs);
    }
    for(i = 0; i < r.reserved_name.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        5,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += ProtoBufRuntime._encode_string(r.reserved_name[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.name).length);
    for(i = 0; i < r.value.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufEnumValueDescriptorProto._estimate(r.value[i]));
    }
    e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufEnumOptions._estimate(r.options));
    for(i = 0; i < r.reserved_range.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufEnumDescriptorProtoEnumReservedRange._estimate(r.reserved_range[i]));
    }
    for(i = 0; i < r.reserved_name.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.reserved_name[i]).length);
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.name = input.name;

    for(uint256 i2 = 0; i2 < input.value.length; i2++) {
      output.value.push(input.value[i2]);
    }
    
    GoogleProtobufEnumOptions.store(input.options, output.options);

    for(uint256 i4 = 0; i4 < input.reserved_range.length; i4++) {
      output.reserved_range.push(input.reserved_range[i4]);
    }
    
    output.reserved_name = input.reserved_name;

  }


  //array helpers for Value
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addValue(Data memory self, GoogleProtobufEnumValueDescriptorProto.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufEnumValueDescriptorProto.Data[] memory tmp = new GoogleProtobufEnumValueDescriptorProto.Data[](self.value.length + 1);
    for (uint256 i = 0; i < self.value.length; i++) {
      tmp[i] = self.value[i];
    }
    tmp[self.value.length] = value;
    self.value = tmp;
  }

  //array helpers for ReservedRange
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addReservedRange(Data memory self, GoogleProtobufEnumDescriptorProtoEnumReservedRange.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufEnumDescriptorProtoEnumReservedRange.Data[] memory tmp = new GoogleProtobufEnumDescriptorProtoEnumReservedRange.Data[](self.reserved_range.length + 1);
    for (uint256 i = 0; i < self.reserved_range.length; i++) {
      tmp[i] = self.reserved_range[i];
    }
    tmp[self.reserved_range.length] = value;
    self.reserved_range = tmp;
  }

  //array helpers for ReservedName
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addReservedName(Data memory self, string memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    string[] memory tmp = new string[](self.reserved_name.length + 1);
    for (uint256 i = 0; i < self.reserved_name.length; i++) {
      tmp[i] = self.reserved_name[i];
    }
    tmp[self.reserved_name.length] = value;
    self.reserved_name = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufEnumDescriptorProto

library GoogleProtobufEnumDescriptorProtoEnumReservedRange {


  //struct definition
  struct Data {
    int32 start;
    int32 end;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[3] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_start(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_end(pointer, bs, r, counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_start(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[3] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.start = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_end(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[3] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.end = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_int32(r.start, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      2,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_int32(r.end, pointer, bs);
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;
    e += 1 + ProtoBufRuntime._sz_int32(r.start);
    e += 1 + ProtoBufRuntime._sz_int32(r.end);
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.start = input.start;
    output.end = input.end;

  }



  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufEnumDescriptorProtoEnumReservedRange

library GoogleProtobufEnumValueDescriptorProto {


  //struct definition
  struct Data {
    string name;
    int32 number;
    GoogleProtobufEnumValueOptions.Data options;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[4] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_name(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_number(pointer, bs, r, counters);
      }
      else if (fieldId == 3) {
        pointer += _read_options(pointer, bs, r, counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_name(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[4] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.name = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_number(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[4] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.number = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_options(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[4] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufEnumValueOptions.Data memory x, uint256 sz) = _decode_GoogleProtobufEnumValueOptions(p, bs);
    if (isNil(r)) {
      counters[3] += 1;
    } else {
      r.options = x;
      if (counters[3] > 0) counters[3] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufEnumValueOptions(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufEnumValueOptions.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufEnumValueOptions.Data memory r, ) = GoogleProtobufEnumValueOptions._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.name, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      2,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_int32(r.number, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      3,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += GoogleProtobufEnumValueOptions._encode_nested(r.options, pointer, bs);
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.name).length);
    e += 1 + ProtoBufRuntime._sz_int32(r.number);
    e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufEnumValueOptions._estimate(r.options));
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.name = input.name;
    output.number = input.number;
    GoogleProtobufEnumValueOptions.store(input.options, output.options);

  }



  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufEnumValueDescriptorProto

library GoogleProtobufServiceDescriptorProto {


  //struct definition
  struct Data {
    string name;
    GoogleProtobufMethodDescriptorProto.Data[] method;
    GoogleProtobufServiceOptions.Data options;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[4] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_name(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_method(pointer, bs, nil(), counters);
      }
      else if (fieldId == 3) {
        pointer += _read_options(pointer, bs, r, counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.method = new GoogleProtobufMethodDescriptorProto.Data[](counters[2]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_name(pointer, bs, nil(), counters);
      }
      else if (fieldId == 2) {
        pointer += _read_method(pointer, bs, r, counters);
      }
      else if (fieldId == 3) {
        pointer += _read_options(pointer, bs, nil(), counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_name(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[4] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.name = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_method(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[4] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufMethodDescriptorProto.Data memory x, uint256 sz) = _decode_GoogleProtobufMethodDescriptorProto(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.method[r.method.length - counters[2]] = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_options(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[4] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufServiceOptions.Data memory x, uint256 sz) = _decode_GoogleProtobufServiceOptions(p, bs);
    if (isNil(r)) {
      counters[3] += 1;
    } else {
      r.options = x;
      if (counters[3] > 0) counters[3] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufMethodDescriptorProto(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufMethodDescriptorProto.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufMethodDescriptorProto.Data memory r, ) = GoogleProtobufMethodDescriptorProto._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }

  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufServiceOptions(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufServiceOptions.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufServiceOptions.Data memory r, ) = GoogleProtobufServiceOptions._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.name, pointer, bs);
    for(i = 0; i < r.method.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        2,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufMethodDescriptorProto._encode_nested(r.method[i], pointer, bs);
    }
    pointer += ProtoBufRuntime._encode_key(
      3,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += GoogleProtobufServiceOptions._encode_nested(r.options, pointer, bs);
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.name).length);
    for(i = 0; i < r.method.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufMethodDescriptorProto._estimate(r.method[i]));
    }
    e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufServiceOptions._estimate(r.options));
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.name = input.name;

    for(uint256 i2 = 0; i2 < input.method.length; i2++) {
      output.method.push(input.method[i2]);
    }
    
    GoogleProtobufServiceOptions.store(input.options, output.options);

  }


  //array helpers for Method
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addMethod(Data memory self, GoogleProtobufMethodDescriptorProto.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufMethodDescriptorProto.Data[] memory tmp = new GoogleProtobufMethodDescriptorProto.Data[](self.method.length + 1);
    for (uint256 i = 0; i < self.method.length; i++) {
      tmp[i] = self.method[i];
    }
    tmp[self.method.length] = value;
    self.method = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufServiceDescriptorProto

library GoogleProtobufMethodDescriptorProto {


  //struct definition
  struct Data {
    string name;
    string input_type;
    string output_type;
    GoogleProtobufMethodOptions.Data options;
    bool client_streaming;
    bool server_streaming;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[7] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_name(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_input_type(pointer, bs, r, counters);
      }
      else if (fieldId == 3) {
        pointer += _read_output_type(pointer, bs, r, counters);
      }
      else if (fieldId == 4) {
        pointer += _read_options(pointer, bs, r, counters);
      }
      else if (fieldId == 5) {
        pointer += _read_client_streaming(pointer, bs, r, counters);
      }
      else if (fieldId == 6) {
        pointer += _read_server_streaming(pointer, bs, r, counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_name(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[7] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.name = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_input_type(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[7] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.input_type = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_output_type(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[7] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[3] += 1;
    } else {
      r.output_type = x;
      if (counters[3] > 0) counters[3] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_options(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[7] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufMethodOptions.Data memory x, uint256 sz) = _decode_GoogleProtobufMethodOptions(p, bs);
    if (isNil(r)) {
      counters[4] += 1;
    } else {
      r.options = x;
      if (counters[4] > 0) counters[4] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_client_streaming(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[7] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[5] += 1;
    } else {
      r.client_streaming = x;
      if (counters[5] > 0) counters[5] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_server_streaming(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[7] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[6] += 1;
    } else {
      r.server_streaming = x;
      if (counters[6] > 0) counters[6] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufMethodOptions(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufMethodOptions.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufMethodOptions.Data memory r, ) = GoogleProtobufMethodOptions._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.name, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      2,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.input_type, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      3,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.output_type, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      4,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += GoogleProtobufMethodOptions._encode_nested(r.options, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      5,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.client_streaming, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      6,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.server_streaming, pointer, bs);
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.name).length);
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.input_type).length);
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.output_type).length);
    e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufMethodOptions._estimate(r.options));
    e += 1 + 1;
    e += 1 + 1;
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.name = input.name;
    output.input_type = input.input_type;
    output.output_type = input.output_type;
    GoogleProtobufMethodOptions.store(input.options, output.options);
    output.client_streaming = input.client_streaming;
    output.server_streaming = input.server_streaming;

  }



  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufMethodDescriptorProto

library GoogleProtobufFileOptions {

  //enum definition
  // Solidity enum definitions
  enum OptimizeMode {
    SPEED,
    CODE_SIZE,
    LITE_RUNTIME
  }


  // Solidity enum encoder
  function encode_OptimizeMode(OptimizeMode x) internal pure returns (int64) {
    
    if (x == OptimizeMode.SPEED) {
      return 1;
    }

    if (x == OptimizeMode.CODE_SIZE) {
      return 2;
    }

    if (x == OptimizeMode.LITE_RUNTIME) {
      return 3;
    }
    revert();
  }


  // Solidity enum decoder
  function decode_OptimizeMode(int64 x) internal pure returns (OptimizeMode) {
    
    if (x == 1) {
      return OptimizeMode.SPEED;
    }

    if (x == 2) {
      return OptimizeMode.CODE_SIZE;
    }

    if (x == 3) {
      return OptimizeMode.LITE_RUNTIME;
    }
    revert();
  }


  //struct definition
  struct Data {
    string java_package;
    string java_outer_classname;
    bool java_multiple_files;
    bool java_generate_equals_and_hash;
    bool java_string_check_utf8;
    GoogleProtobufFileOptions.OptimizeMode optimize_for;
    string go_package;
    bool cc_generic_services;
    bool java_generic_services;
    bool py_generic_services;
    bool php_generic_services;
    bool deprecated;
    bool cc_enable_arenas;
    string objc_class_prefix;
    string csharp_namespace;
    string swift_prefix;
    string php_class_prefix;
    string php_namespace;
    string php_metadata_namespace;
    string ruby_package;
    GoogleProtobufUninterpretedOption.Data[] uninterpreted_option;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[1000] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_java_package(pointer, bs, r, counters);
      }
      else if (fieldId == 8) {
        pointer += _read_java_outer_classname(pointer, bs, r, counters);
      }
      else if (fieldId == 10) {
        pointer += _read_java_multiple_files(pointer, bs, r, counters);
      }
      else if (fieldId == 20) {
        pointer += _read_java_generate_equals_and_hash(pointer, bs, r, counters);
      }
      else if (fieldId == 27) {
        pointer += _read_java_string_check_utf8(pointer, bs, r, counters);
      }
      else if (fieldId == 9) {
        pointer += _read_optimize_for(pointer, bs, r, counters);
      }
      else if (fieldId == 11) {
        pointer += _read_go_package(pointer, bs, r, counters);
      }
      else if (fieldId == 16) {
        pointer += _read_cc_generic_services(pointer, bs, r, counters);
      }
      else if (fieldId == 17) {
        pointer += _read_java_generic_services(pointer, bs, r, counters);
      }
      else if (fieldId == 18) {
        pointer += _read_py_generic_services(pointer, bs, r, counters);
      }
      else if (fieldId == 42) {
        pointer += _read_php_generic_services(pointer, bs, r, counters);
      }
      else if (fieldId == 23) {
        pointer += _read_deprecated(pointer, bs, r, counters);
      }
      else if (fieldId == 31) {
        pointer += _read_cc_enable_arenas(pointer, bs, r, counters);
      }
      else if (fieldId == 36) {
        pointer += _read_objc_class_prefix(pointer, bs, r, counters);
      }
      else if (fieldId == 37) {
        pointer += _read_csharp_namespace(pointer, bs, r, counters);
      }
      else if (fieldId == 39) {
        pointer += _read_swift_prefix(pointer, bs, r, counters);
      }
      else if (fieldId == 40) {
        pointer += _read_php_class_prefix(pointer, bs, r, counters);
      }
      else if (fieldId == 41) {
        pointer += _read_php_namespace(pointer, bs, r, counters);
      }
      else if (fieldId == 44) {
        pointer += _read_php_metadata_namespace(pointer, bs, r, counters);
      }
      else if (fieldId == 45) {
        pointer += _read_ruby_package(pointer, bs, r, counters);
      }
      else if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.uninterpreted_option = new GoogleProtobufUninterpretedOption.Data[](counters[999]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_java_package(pointer, bs, nil(), counters);
      }
      else if (fieldId == 8) {
        pointer += _read_java_outer_classname(pointer, bs, nil(), counters);
      }
      else if (fieldId == 10) {
        pointer += _read_java_multiple_files(pointer, bs, nil(), counters);
      }
      else if (fieldId == 20) {
        pointer += _read_java_generate_equals_and_hash(pointer, bs, nil(), counters);
      }
      else if (fieldId == 27) {
        pointer += _read_java_string_check_utf8(pointer, bs, nil(), counters);
      }
      else if (fieldId == 9) {
        pointer += _read_optimize_for(pointer, bs, nil(), counters);
      }
      else if (fieldId == 11) {
        pointer += _read_go_package(pointer, bs, nil(), counters);
      }
      else if (fieldId == 16) {
        pointer += _read_cc_generic_services(pointer, bs, nil(), counters);
      }
      else if (fieldId == 17) {
        pointer += _read_java_generic_services(pointer, bs, nil(), counters);
      }
      else if (fieldId == 18) {
        pointer += _read_py_generic_services(pointer, bs, nil(), counters);
      }
      else if (fieldId == 42) {
        pointer += _read_php_generic_services(pointer, bs, nil(), counters);
      }
      else if (fieldId == 23) {
        pointer += _read_deprecated(pointer, bs, nil(), counters);
      }
      else if (fieldId == 31) {
        pointer += _read_cc_enable_arenas(pointer, bs, nil(), counters);
      }
      else if (fieldId == 36) {
        pointer += _read_objc_class_prefix(pointer, bs, nil(), counters);
      }
      else if (fieldId == 37) {
        pointer += _read_csharp_namespace(pointer, bs, nil(), counters);
      }
      else if (fieldId == 39) {
        pointer += _read_swift_prefix(pointer, bs, nil(), counters);
      }
      else if (fieldId == 40) {
        pointer += _read_php_class_prefix(pointer, bs, nil(), counters);
      }
      else if (fieldId == 41) {
        pointer += _read_php_namespace(pointer, bs, nil(), counters);
      }
      else if (fieldId == 44) {
        pointer += _read_php_metadata_namespace(pointer, bs, nil(), counters);
      }
      else if (fieldId == 45) {
        pointer += _read_ruby_package(pointer, bs, nil(), counters);
      }
      else if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_java_package(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.java_package = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_java_outer_classname(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[8] += 1;
    } else {
      r.java_outer_classname = x;
      if (counters[8] > 0) counters[8] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_java_multiple_files(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[10] += 1;
    } else {
      r.java_multiple_files = x;
      if (counters[10] > 0) counters[10] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_java_generate_equals_and_hash(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[20] += 1;
    } else {
      r.java_generate_equals_and_hash = x;
      if (counters[20] > 0) counters[20] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_java_string_check_utf8(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[27] += 1;
    } else {
      r.java_string_check_utf8 = x;
      if (counters[27] > 0) counters[27] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_optimize_for(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int64 tmp, uint256 sz) = ProtoBufRuntime._decode_enum(p, bs);
    GoogleProtobufFileOptions.OptimizeMode x = GoogleProtobufFileOptions.decode_OptimizeMode(tmp);
    if (isNil(r)) {
      counters[9] += 1;
    } else {
      r.optimize_for = x;
      if(counters[9] > 0) counters[9] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_go_package(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[11] += 1;
    } else {
      r.go_package = x;
      if (counters[11] > 0) counters[11] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_cc_generic_services(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[16] += 1;
    } else {
      r.cc_generic_services = x;
      if (counters[16] > 0) counters[16] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_java_generic_services(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[17] += 1;
    } else {
      r.java_generic_services = x;
      if (counters[17] > 0) counters[17] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_py_generic_services(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[18] += 1;
    } else {
      r.py_generic_services = x;
      if (counters[18] > 0) counters[18] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_php_generic_services(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[42] += 1;
    } else {
      r.php_generic_services = x;
      if (counters[42] > 0) counters[42] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_deprecated(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[23] += 1;
    } else {
      r.deprecated = x;
      if (counters[23] > 0) counters[23] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_cc_enable_arenas(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[31] += 1;
    } else {
      r.cc_enable_arenas = x;
      if (counters[31] > 0) counters[31] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_objc_class_prefix(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[36] += 1;
    } else {
      r.objc_class_prefix = x;
      if (counters[36] > 0) counters[36] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_csharp_namespace(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[37] += 1;
    } else {
      r.csharp_namespace = x;
      if (counters[37] > 0) counters[37] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_swift_prefix(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[39] += 1;
    } else {
      r.swift_prefix = x;
      if (counters[39] > 0) counters[39] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_php_class_prefix(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[40] += 1;
    } else {
      r.php_class_prefix = x;
      if (counters[40] > 0) counters[40] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_php_namespace(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[41] += 1;
    } else {
      r.php_namespace = x;
      if (counters[41] > 0) counters[41] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_php_metadata_namespace(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[44] += 1;
    } else {
      r.php_metadata_namespace = x;
      if (counters[44] > 0) counters[44] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_ruby_package(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[45] += 1;
    } else {
      r.ruby_package = x;
      if (counters[45] > 0) counters[45] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_uninterpreted_option(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufUninterpretedOption.Data memory x, uint256 sz) = _decode_GoogleProtobufUninterpretedOption(p, bs);
    if (isNil(r)) {
      counters[999] += 1;
    } else {
      r.uninterpreted_option[r.uninterpreted_option.length - counters[999]] = x;
      if (counters[999] > 0) counters[999] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufUninterpretedOption(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufUninterpretedOption.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufUninterpretedOption.Data memory r, ) = GoogleProtobufUninterpretedOption._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.java_package, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      8,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.java_outer_classname, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      10,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.java_multiple_files, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      20,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.java_generate_equals_and_hash, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      27,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.java_string_check_utf8, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      9,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    int64 _enum_optimize_for = GoogleProtobufFileOptions.encode_OptimizeMode(r.optimize_for);
    pointer += ProtoBufRuntime._encode_enum(_enum_optimize_for, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      11,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.go_package, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      16,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.cc_generic_services, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      17,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.java_generic_services, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      18,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.py_generic_services, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      42,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.php_generic_services, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      23,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.deprecated, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      31,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.cc_enable_arenas, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      36,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.objc_class_prefix, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      37,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.csharp_namespace, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      39,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.swift_prefix, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      40,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.php_class_prefix, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      41,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.php_namespace, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      44,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.php_metadata_namespace, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      45,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.ruby_package, pointer, bs);
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        999,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufUninterpretedOption._encode_nested(r.uninterpreted_option[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.java_package).length);
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.java_outer_classname).length);
    e += 1 + 1;
    e += 2 + 1;
    e += 2 + 1;
    e += 1 + ProtoBufRuntime._sz_enum(GoogleProtobufFileOptions.encode_OptimizeMode(r.optimize_for));
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.go_package).length);
    e += 2 + 1;
    e += 2 + 1;
    e += 2 + 1;
    e += 2 + 1;
    e += 2 + 1;
    e += 2 + 1;
    e += 2 + ProtoBufRuntime._sz_lendelim(bytes(r.objc_class_prefix).length);
    e += 2 + ProtoBufRuntime._sz_lendelim(bytes(r.csharp_namespace).length);
    e += 2 + ProtoBufRuntime._sz_lendelim(bytes(r.swift_prefix).length);
    e += 2 + ProtoBufRuntime._sz_lendelim(bytes(r.php_class_prefix).length);
    e += 2 + ProtoBufRuntime._sz_lendelim(bytes(r.php_namespace).length);
    e += 2 + ProtoBufRuntime._sz_lendelim(bytes(r.php_metadata_namespace).length);
    e += 2 + ProtoBufRuntime._sz_lendelim(bytes(r.ruby_package).length);
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      e += 2 + ProtoBufRuntime._sz_lendelim(GoogleProtobufUninterpretedOption._estimate(r.uninterpreted_option[i]));
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.java_package = input.java_package;
    output.java_outer_classname = input.java_outer_classname;
    output.java_multiple_files = input.java_multiple_files;
    output.java_generate_equals_and_hash = input.java_generate_equals_and_hash;
    output.java_string_check_utf8 = input.java_string_check_utf8;
    output.optimize_for = input.optimize_for;
    output.go_package = input.go_package;
    output.cc_generic_services = input.cc_generic_services;
    output.java_generic_services = input.java_generic_services;
    output.py_generic_services = input.py_generic_services;
    output.php_generic_services = input.php_generic_services;
    output.deprecated = input.deprecated;
    output.cc_enable_arenas = input.cc_enable_arenas;
    output.objc_class_prefix = input.objc_class_prefix;
    output.csharp_namespace = input.csharp_namespace;
    output.swift_prefix = input.swift_prefix;
    output.php_class_prefix = input.php_class_prefix;
    output.php_namespace = input.php_namespace;
    output.php_metadata_namespace = input.php_metadata_namespace;
    output.ruby_package = input.ruby_package;

    for(uint256 i999 = 0; i999 < input.uninterpreted_option.length; i999++) {
      output.uninterpreted_option.push(input.uninterpreted_option[i999]);
    }
    

  }


  //array helpers for UninterpretedOption
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addUninterpretedOption(Data memory self, GoogleProtobufUninterpretedOption.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufUninterpretedOption.Data[] memory tmp = new GoogleProtobufUninterpretedOption.Data[](self.uninterpreted_option.length + 1);
    for (uint256 i = 0; i < self.uninterpreted_option.length; i++) {
      tmp[i] = self.uninterpreted_option[i];
    }
    tmp[self.uninterpreted_option.length] = value;
    self.uninterpreted_option = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufFileOptions

library GoogleProtobufMessageOptions {


  //struct definition
  struct Data {
    bool message_set_wire_format;
    bool no_standard_descriptor_accessor;
    bool deprecated;
    bool map_entry;
    GoogleProtobufUninterpretedOption.Data[] uninterpreted_option;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[1000] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_message_set_wire_format(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_no_standard_descriptor_accessor(pointer, bs, r, counters);
      }
      else if (fieldId == 3) {
        pointer += _read_deprecated(pointer, bs, r, counters);
      }
      else if (fieldId == 7) {
        pointer += _read_map_entry(pointer, bs, r, counters);
      }
      else if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.uninterpreted_option = new GoogleProtobufUninterpretedOption.Data[](counters[999]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_message_set_wire_format(pointer, bs, nil(), counters);
      }
      else if (fieldId == 2) {
        pointer += _read_no_standard_descriptor_accessor(pointer, bs, nil(), counters);
      }
      else if (fieldId == 3) {
        pointer += _read_deprecated(pointer, bs, nil(), counters);
      }
      else if (fieldId == 7) {
        pointer += _read_map_entry(pointer, bs, nil(), counters);
      }
      else if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_message_set_wire_format(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.message_set_wire_format = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_no_standard_descriptor_accessor(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.no_standard_descriptor_accessor = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_deprecated(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[3] += 1;
    } else {
      r.deprecated = x;
      if (counters[3] > 0) counters[3] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_map_entry(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[7] += 1;
    } else {
      r.map_entry = x;
      if (counters[7] > 0) counters[7] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_uninterpreted_option(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufUninterpretedOption.Data memory x, uint256 sz) = _decode_GoogleProtobufUninterpretedOption(p, bs);
    if (isNil(r)) {
      counters[999] += 1;
    } else {
      r.uninterpreted_option[r.uninterpreted_option.length - counters[999]] = x;
      if (counters[999] > 0) counters[999] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufUninterpretedOption(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufUninterpretedOption.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufUninterpretedOption.Data memory r, ) = GoogleProtobufUninterpretedOption._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.message_set_wire_format, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      2,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.no_standard_descriptor_accessor, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      3,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.deprecated, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      7,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.map_entry, pointer, bs);
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        999,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufUninterpretedOption._encode_nested(r.uninterpreted_option[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    e += 1 + 1;
    e += 1 + 1;
    e += 1 + 1;
    e += 1 + 1;
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      e += 2 + ProtoBufRuntime._sz_lendelim(GoogleProtobufUninterpretedOption._estimate(r.uninterpreted_option[i]));
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.message_set_wire_format = input.message_set_wire_format;
    output.no_standard_descriptor_accessor = input.no_standard_descriptor_accessor;
    output.deprecated = input.deprecated;
    output.map_entry = input.map_entry;

    for(uint256 i999 = 0; i999 < input.uninterpreted_option.length; i999++) {
      output.uninterpreted_option.push(input.uninterpreted_option[i999]);
    }
    

  }


  //array helpers for UninterpretedOption
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addUninterpretedOption(Data memory self, GoogleProtobufUninterpretedOption.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufUninterpretedOption.Data[] memory tmp = new GoogleProtobufUninterpretedOption.Data[](self.uninterpreted_option.length + 1);
    for (uint256 i = 0; i < self.uninterpreted_option.length; i++) {
      tmp[i] = self.uninterpreted_option[i];
    }
    tmp[self.uninterpreted_option.length] = value;
    self.uninterpreted_option = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufMessageOptions

library GoogleProtobufFieldOptions {

  //enum definition
  // Solidity enum definitions
  enum CType {
    STRING,
    CORD,
    STRING_PIECE
  }


  // Solidity enum encoder
  function encode_CType(CType x) internal pure returns (int64) {
    
    if (x == CType.STRING) {
      return 0;
    }

    if (x == CType.CORD) {
      return 1;
    }

    if (x == CType.STRING_PIECE) {
      return 2;
    }
    revert();
  }


  // Solidity enum decoder
  function decode_CType(int64 x) internal pure returns (CType) {
    
    if (x == 0) {
      return CType.STRING;
    }

    if (x == 1) {
      return CType.CORD;
    }

    if (x == 2) {
      return CType.STRING_PIECE;
    }
    revert();
  }


  // Solidity enum definitions
  enum JSType {
    JS_NORMAL,
    JS_STRING,
    JS_NUMBER
  }


  // Solidity enum encoder
  function encode_JSType(JSType x) internal pure returns (int64) {
    
    if (x == JSType.JS_NORMAL) {
      return 0;
    }

    if (x == JSType.JS_STRING) {
      return 1;
    }

    if (x == JSType.JS_NUMBER) {
      return 2;
    }
    revert();
  }


  // Solidity enum decoder
  function decode_JSType(int64 x) internal pure returns (JSType) {
    
    if (x == 0) {
      return JSType.JS_NORMAL;
    }

    if (x == 1) {
      return JSType.JS_STRING;
    }

    if (x == 2) {
      return JSType.JS_NUMBER;
    }
    revert();
  }


  //struct definition
  struct Data {
    GoogleProtobufFieldOptions.CType ctype;
    bool packed;
    GoogleProtobufFieldOptions.JSType jstype;
    bool lazy;
    bool deprecated;
    bool weak;
    GoogleProtobufUninterpretedOption.Data[] uninterpreted_option;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[1000] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_ctype(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_packed(pointer, bs, r, counters);
      }
      else if (fieldId == 6) {
        pointer += _read_jstype(pointer, bs, r, counters);
      }
      else if (fieldId == 5) {
        pointer += _read_lazy(pointer, bs, r, counters);
      }
      else if (fieldId == 3) {
        pointer += _read_deprecated(pointer, bs, r, counters);
      }
      else if (fieldId == 10) {
        pointer += _read_weak(pointer, bs, r, counters);
      }
      else if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.uninterpreted_option = new GoogleProtobufUninterpretedOption.Data[](counters[999]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_ctype(pointer, bs, nil(), counters);
      }
      else if (fieldId == 2) {
        pointer += _read_packed(pointer, bs, nil(), counters);
      }
      else if (fieldId == 6) {
        pointer += _read_jstype(pointer, bs, nil(), counters);
      }
      else if (fieldId == 5) {
        pointer += _read_lazy(pointer, bs, nil(), counters);
      }
      else if (fieldId == 3) {
        pointer += _read_deprecated(pointer, bs, nil(), counters);
      }
      else if (fieldId == 10) {
        pointer += _read_weak(pointer, bs, nil(), counters);
      }
      else if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_ctype(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int64 tmp, uint256 sz) = ProtoBufRuntime._decode_enum(p, bs);
    GoogleProtobufFieldOptions.CType x = GoogleProtobufFieldOptions.decode_CType(tmp);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.ctype = x;
      if(counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_packed(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.packed = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_jstype(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int64 tmp, uint256 sz) = ProtoBufRuntime._decode_enum(p, bs);
    GoogleProtobufFieldOptions.JSType x = GoogleProtobufFieldOptions.decode_JSType(tmp);
    if (isNil(r)) {
      counters[6] += 1;
    } else {
      r.jstype = x;
      if(counters[6] > 0) counters[6] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_lazy(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[5] += 1;
    } else {
      r.lazy = x;
      if (counters[5] > 0) counters[5] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_deprecated(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[3] += 1;
    } else {
      r.deprecated = x;
      if (counters[3] > 0) counters[3] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_weak(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[10] += 1;
    } else {
      r.weak = x;
      if (counters[10] > 0) counters[10] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_uninterpreted_option(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufUninterpretedOption.Data memory x, uint256 sz) = _decode_GoogleProtobufUninterpretedOption(p, bs);
    if (isNil(r)) {
      counters[999] += 1;
    } else {
      r.uninterpreted_option[r.uninterpreted_option.length - counters[999]] = x;
      if (counters[999] > 0) counters[999] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufUninterpretedOption(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufUninterpretedOption.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufUninterpretedOption.Data memory r, ) = GoogleProtobufUninterpretedOption._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    int64 _enum_ctype = GoogleProtobufFieldOptions.encode_CType(r.ctype);
    pointer += ProtoBufRuntime._encode_enum(_enum_ctype, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      2,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.packed, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      6,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    int64 _enum_jstype = GoogleProtobufFieldOptions.encode_JSType(r.jstype);
    pointer += ProtoBufRuntime._encode_enum(_enum_jstype, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      5,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.lazy, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      3,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.deprecated, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      10,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.weak, pointer, bs);
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        999,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufUninterpretedOption._encode_nested(r.uninterpreted_option[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    e += 1 + ProtoBufRuntime._sz_enum(GoogleProtobufFieldOptions.encode_CType(r.ctype));
    e += 1 + 1;
    e += 1 + ProtoBufRuntime._sz_enum(GoogleProtobufFieldOptions.encode_JSType(r.jstype));
    e += 1 + 1;
    e += 1 + 1;
    e += 1 + 1;
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      e += 2 + ProtoBufRuntime._sz_lendelim(GoogleProtobufUninterpretedOption._estimate(r.uninterpreted_option[i]));
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.ctype = input.ctype;
    output.packed = input.packed;
    output.jstype = input.jstype;
    output.lazy = input.lazy;
    output.deprecated = input.deprecated;
    output.weak = input.weak;

    for(uint256 i999 = 0; i999 < input.uninterpreted_option.length; i999++) {
      output.uninterpreted_option.push(input.uninterpreted_option[i999]);
    }
    

  }


  //array helpers for UninterpretedOption
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addUninterpretedOption(Data memory self, GoogleProtobufUninterpretedOption.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufUninterpretedOption.Data[] memory tmp = new GoogleProtobufUninterpretedOption.Data[](self.uninterpreted_option.length + 1);
    for (uint256 i = 0; i < self.uninterpreted_option.length; i++) {
      tmp[i] = self.uninterpreted_option[i];
    }
    tmp[self.uninterpreted_option.length] = value;
    self.uninterpreted_option = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufFieldOptions

library GoogleProtobufOneofOptions {


  //struct definition
  struct Data {
    GoogleProtobufUninterpretedOption.Data[] uninterpreted_option;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[1000] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.uninterpreted_option = new GoogleProtobufUninterpretedOption.Data[](counters[999]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_uninterpreted_option(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufUninterpretedOption.Data memory x, uint256 sz) = _decode_GoogleProtobufUninterpretedOption(p, bs);
    if (isNil(r)) {
      counters[999] += 1;
    } else {
      r.uninterpreted_option[r.uninterpreted_option.length - counters[999]] = x;
      if (counters[999] > 0) counters[999] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufUninterpretedOption(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufUninterpretedOption.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufUninterpretedOption.Data memory r, ) = GoogleProtobufUninterpretedOption._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        999,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufUninterpretedOption._encode_nested(r.uninterpreted_option[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      e += 2 + ProtoBufRuntime._sz_lendelim(GoogleProtobufUninterpretedOption._estimate(r.uninterpreted_option[i]));
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {

    for(uint256 i999 = 0; i999 < input.uninterpreted_option.length; i999++) {
      output.uninterpreted_option.push(input.uninterpreted_option[i999]);
    }
    

  }


  //array helpers for UninterpretedOption
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addUninterpretedOption(Data memory self, GoogleProtobufUninterpretedOption.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufUninterpretedOption.Data[] memory tmp = new GoogleProtobufUninterpretedOption.Data[](self.uninterpreted_option.length + 1);
    for (uint256 i = 0; i < self.uninterpreted_option.length; i++) {
      tmp[i] = self.uninterpreted_option[i];
    }
    tmp[self.uninterpreted_option.length] = value;
    self.uninterpreted_option = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufOneofOptions

library GoogleProtobufEnumOptions {


  //struct definition
  struct Data {
    bool allow_alias;
    bool deprecated;
    GoogleProtobufUninterpretedOption.Data[] uninterpreted_option;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[1000] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 2) {
        pointer += _read_allow_alias(pointer, bs, r, counters);
      }
      else if (fieldId == 3) {
        pointer += _read_deprecated(pointer, bs, r, counters);
      }
      else if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.uninterpreted_option = new GoogleProtobufUninterpretedOption.Data[](counters[999]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 2) {
        pointer += _read_allow_alias(pointer, bs, nil(), counters);
      }
      else if (fieldId == 3) {
        pointer += _read_deprecated(pointer, bs, nil(), counters);
      }
      else if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_allow_alias(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.allow_alias = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_deprecated(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[3] += 1;
    } else {
      r.deprecated = x;
      if (counters[3] > 0) counters[3] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_uninterpreted_option(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufUninterpretedOption.Data memory x, uint256 sz) = _decode_GoogleProtobufUninterpretedOption(p, bs);
    if (isNil(r)) {
      counters[999] += 1;
    } else {
      r.uninterpreted_option[r.uninterpreted_option.length - counters[999]] = x;
      if (counters[999] > 0) counters[999] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufUninterpretedOption(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufUninterpretedOption.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufUninterpretedOption.Data memory r, ) = GoogleProtobufUninterpretedOption._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    pointer += ProtoBufRuntime._encode_key(
      2,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.allow_alias, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      3,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.deprecated, pointer, bs);
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        999,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufUninterpretedOption._encode_nested(r.uninterpreted_option[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    e += 1 + 1;
    e += 1 + 1;
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      e += 2 + ProtoBufRuntime._sz_lendelim(GoogleProtobufUninterpretedOption._estimate(r.uninterpreted_option[i]));
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.allow_alias = input.allow_alias;
    output.deprecated = input.deprecated;

    for(uint256 i999 = 0; i999 < input.uninterpreted_option.length; i999++) {
      output.uninterpreted_option.push(input.uninterpreted_option[i999]);
    }
    

  }


  //array helpers for UninterpretedOption
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addUninterpretedOption(Data memory self, GoogleProtobufUninterpretedOption.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufUninterpretedOption.Data[] memory tmp = new GoogleProtobufUninterpretedOption.Data[](self.uninterpreted_option.length + 1);
    for (uint256 i = 0; i < self.uninterpreted_option.length; i++) {
      tmp[i] = self.uninterpreted_option[i];
    }
    tmp[self.uninterpreted_option.length] = value;
    self.uninterpreted_option = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufEnumOptions

library GoogleProtobufEnumValueOptions {


  //struct definition
  struct Data {
    bool deprecated;
    GoogleProtobufUninterpretedOption.Data[] uninterpreted_option;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[1000] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_deprecated(pointer, bs, r, counters);
      }
      else if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.uninterpreted_option = new GoogleProtobufUninterpretedOption.Data[](counters[999]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_deprecated(pointer, bs, nil(), counters);
      }
      else if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_deprecated(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.deprecated = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_uninterpreted_option(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufUninterpretedOption.Data memory x, uint256 sz) = _decode_GoogleProtobufUninterpretedOption(p, bs);
    if (isNil(r)) {
      counters[999] += 1;
    } else {
      r.uninterpreted_option[r.uninterpreted_option.length - counters[999]] = x;
      if (counters[999] > 0) counters[999] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufUninterpretedOption(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufUninterpretedOption.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufUninterpretedOption.Data memory r, ) = GoogleProtobufUninterpretedOption._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.deprecated, pointer, bs);
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        999,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufUninterpretedOption._encode_nested(r.uninterpreted_option[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    e += 1 + 1;
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      e += 2 + ProtoBufRuntime._sz_lendelim(GoogleProtobufUninterpretedOption._estimate(r.uninterpreted_option[i]));
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.deprecated = input.deprecated;

    for(uint256 i999 = 0; i999 < input.uninterpreted_option.length; i999++) {
      output.uninterpreted_option.push(input.uninterpreted_option[i999]);
    }
    

  }


  //array helpers for UninterpretedOption
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addUninterpretedOption(Data memory self, GoogleProtobufUninterpretedOption.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufUninterpretedOption.Data[] memory tmp = new GoogleProtobufUninterpretedOption.Data[](self.uninterpreted_option.length + 1);
    for (uint256 i = 0; i < self.uninterpreted_option.length; i++) {
      tmp[i] = self.uninterpreted_option[i];
    }
    tmp[self.uninterpreted_option.length] = value;
    self.uninterpreted_option = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufEnumValueOptions

library GoogleProtobufServiceOptions {


  //struct definition
  struct Data {
    bool deprecated;
    GoogleProtobufUninterpretedOption.Data[] uninterpreted_option;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[1000] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 33) {
        pointer += _read_deprecated(pointer, bs, r, counters);
      }
      else if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.uninterpreted_option = new GoogleProtobufUninterpretedOption.Data[](counters[999]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 33) {
        pointer += _read_deprecated(pointer, bs, nil(), counters);
      }
      else if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_deprecated(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[33] += 1;
    } else {
      r.deprecated = x;
      if (counters[33] > 0) counters[33] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_uninterpreted_option(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufUninterpretedOption.Data memory x, uint256 sz) = _decode_GoogleProtobufUninterpretedOption(p, bs);
    if (isNil(r)) {
      counters[999] += 1;
    } else {
      r.uninterpreted_option[r.uninterpreted_option.length - counters[999]] = x;
      if (counters[999] > 0) counters[999] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufUninterpretedOption(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufUninterpretedOption.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufUninterpretedOption.Data memory r, ) = GoogleProtobufUninterpretedOption._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    pointer += ProtoBufRuntime._encode_key(
      33,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.deprecated, pointer, bs);
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        999,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufUninterpretedOption._encode_nested(r.uninterpreted_option[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    e += 2 + 1;
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      e += 2 + ProtoBufRuntime._sz_lendelim(GoogleProtobufUninterpretedOption._estimate(r.uninterpreted_option[i]));
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.deprecated = input.deprecated;

    for(uint256 i999 = 0; i999 < input.uninterpreted_option.length; i999++) {
      output.uninterpreted_option.push(input.uninterpreted_option[i999]);
    }
    

  }


  //array helpers for UninterpretedOption
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addUninterpretedOption(Data memory self, GoogleProtobufUninterpretedOption.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufUninterpretedOption.Data[] memory tmp = new GoogleProtobufUninterpretedOption.Data[](self.uninterpreted_option.length + 1);
    for (uint256 i = 0; i < self.uninterpreted_option.length; i++) {
      tmp[i] = self.uninterpreted_option[i];
    }
    tmp[self.uninterpreted_option.length] = value;
    self.uninterpreted_option = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufServiceOptions

library GoogleProtobufMethodOptions {

  //enum definition
  // Solidity enum definitions
  enum IdempotencyLevel {
    IDEMPOTENCY_UNKNOWN,
    NO_SIDE_EFFECTS,
    IDEMPOTENT
  }


  // Solidity enum encoder
  function encode_IdempotencyLevel(IdempotencyLevel x) internal pure returns (int64) {
    
    if (x == IdempotencyLevel.IDEMPOTENCY_UNKNOWN) {
      return 0;
    }

    if (x == IdempotencyLevel.NO_SIDE_EFFECTS) {
      return 1;
    }

    if (x == IdempotencyLevel.IDEMPOTENT) {
      return 2;
    }
    revert();
  }


  // Solidity enum decoder
  function decode_IdempotencyLevel(int64 x) internal pure returns (IdempotencyLevel) {
    
    if (x == 0) {
      return IdempotencyLevel.IDEMPOTENCY_UNKNOWN;
    }

    if (x == 1) {
      return IdempotencyLevel.NO_SIDE_EFFECTS;
    }

    if (x == 2) {
      return IdempotencyLevel.IDEMPOTENT;
    }
    revert();
  }


  //struct definition
  struct Data {
    bool deprecated;
    GoogleProtobufMethodOptions.IdempotencyLevel idempotency_level;
    GoogleProtobufUninterpretedOption.Data[] uninterpreted_option;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[1000] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 33) {
        pointer += _read_deprecated(pointer, bs, r, counters);
      }
      else if (fieldId == 34) {
        pointer += _read_idempotency_level(pointer, bs, r, counters);
      }
      else if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.uninterpreted_option = new GoogleProtobufUninterpretedOption.Data[](counters[999]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 33) {
        pointer += _read_deprecated(pointer, bs, nil(), counters);
      }
      else if (fieldId == 34) {
        pointer += _read_idempotency_level(pointer, bs, nil(), counters);
      }
      else if (fieldId == 999) {
        pointer += _read_uninterpreted_option(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_deprecated(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[33] += 1;
    } else {
      r.deprecated = x;
      if (counters[33] > 0) counters[33] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_idempotency_level(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int64 tmp, uint256 sz) = ProtoBufRuntime._decode_enum(p, bs);
    GoogleProtobufMethodOptions.IdempotencyLevel x = GoogleProtobufMethodOptions.decode_IdempotencyLevel(tmp);
    if (isNil(r)) {
      counters[34] += 1;
    } else {
      r.idempotency_level = x;
      if(counters[34] > 0) counters[34] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_uninterpreted_option(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[1000] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufUninterpretedOption.Data memory x, uint256 sz) = _decode_GoogleProtobufUninterpretedOption(p, bs);
    if (isNil(r)) {
      counters[999] += 1;
    } else {
      r.uninterpreted_option[r.uninterpreted_option.length - counters[999]] = x;
      if (counters[999] > 0) counters[999] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufUninterpretedOption(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufUninterpretedOption.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufUninterpretedOption.Data memory r, ) = GoogleProtobufUninterpretedOption._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    pointer += ProtoBufRuntime._encode_key(
      33,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.deprecated, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      34,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    int64 _enum_idempotency_level = GoogleProtobufMethodOptions.encode_IdempotencyLevel(r.idempotency_level);
    pointer += ProtoBufRuntime._encode_enum(_enum_idempotency_level, pointer, bs);
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        999,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufUninterpretedOption._encode_nested(r.uninterpreted_option[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    e += 2 + 1;
    e += 2 + ProtoBufRuntime._sz_enum(GoogleProtobufMethodOptions.encode_IdempotencyLevel(r.idempotency_level));
    for(i = 0; i < r.uninterpreted_option.length; i++) {
      e += 2 + ProtoBufRuntime._sz_lendelim(GoogleProtobufUninterpretedOption._estimate(r.uninterpreted_option[i]));
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.deprecated = input.deprecated;
    output.idempotency_level = input.idempotency_level;

    for(uint256 i999 = 0; i999 < input.uninterpreted_option.length; i999++) {
      output.uninterpreted_option.push(input.uninterpreted_option[i999]);
    }
    

  }


  //array helpers for UninterpretedOption
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addUninterpretedOption(Data memory self, GoogleProtobufUninterpretedOption.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufUninterpretedOption.Data[] memory tmp = new GoogleProtobufUninterpretedOption.Data[](self.uninterpreted_option.length + 1);
    for (uint256 i = 0; i < self.uninterpreted_option.length; i++) {
      tmp[i] = self.uninterpreted_option[i];
    }
    tmp[self.uninterpreted_option.length] = value;
    self.uninterpreted_option = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufMethodOptions

library GoogleProtobufUninterpretedOption {


  //struct definition
  struct Data {
    GoogleProtobufUninterpretedOptionNamePart.Data[] name;
    string identifier_value;
    uint64 positive_int_value;
    int64 negative_int_value;
    int64 double_value;
    bytes string_value;
    string aggregate_value;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[9] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 2) {
        pointer += _read_name(pointer, bs, nil(), counters);
      }
      else if (fieldId == 3) {
        pointer += _read_identifier_value(pointer, bs, r, counters);
      }
      else if (fieldId == 4) {
        pointer += _read_positive_int_value(pointer, bs, r, counters);
      }
      else if (fieldId == 5) {
        pointer += _read_negative_int_value(pointer, bs, r, counters);
      }
      else if (fieldId == 6) {
        pointer += _read_double_value(pointer, bs, r, counters);
      }
      else if (fieldId == 7) {
        pointer += _read_string_value(pointer, bs, r, counters);
      }
      else if (fieldId == 8) {
        pointer += _read_aggregate_value(pointer, bs, r, counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.name = new GoogleProtobufUninterpretedOptionNamePart.Data[](counters[2]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 2) {
        pointer += _read_name(pointer, bs, r, counters);
      }
      else if (fieldId == 3) {
        pointer += _read_identifier_value(pointer, bs, nil(), counters);
      }
      else if (fieldId == 4) {
        pointer += _read_positive_int_value(pointer, bs, nil(), counters);
      }
      else if (fieldId == 5) {
        pointer += _read_negative_int_value(pointer, bs, nil(), counters);
      }
      else if (fieldId == 6) {
        pointer += _read_double_value(pointer, bs, nil(), counters);
      }
      else if (fieldId == 7) {
        pointer += _read_string_value(pointer, bs, nil(), counters);
      }
      else if (fieldId == 8) {
        pointer += _read_aggregate_value(pointer, bs, nil(), counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_name(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[9] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufUninterpretedOptionNamePart.Data memory x, uint256 sz) = _decode_GoogleProtobufUninterpretedOptionNamePart(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.name[r.name.length - counters[2]] = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_identifier_value(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[9] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[3] += 1;
    } else {
      r.identifier_value = x;
      if (counters[3] > 0) counters[3] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_positive_int_value(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[9] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (uint64 x, uint256 sz) = ProtoBufRuntime._decode_uint64(p, bs);
    if (isNil(r)) {
      counters[4] += 1;
    } else {
      r.positive_int_value = x;
      if (counters[4] > 0) counters[4] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_negative_int_value(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[9] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int64 x, uint256 sz) = ProtoBufRuntime._decode_int64(p, bs);
    if (isNil(r)) {
      counters[5] += 1;
    } else {
      r.negative_int_value = x;
      if (counters[5] > 0) counters[5] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_double_value(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[9] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int64 x, uint256 sz) = ProtoBufRuntime._decode_int64(p, bs);
    if (isNil(r)) {
      counters[6] += 1;
    } else {
      r.double_value = x;
      if (counters[6] > 0) counters[6] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_string_value(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[9] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
    if (isNil(r)) {
      counters[7] += 1;
    } else {
      r.string_value = x;
      if (counters[7] > 0) counters[7] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_aggregate_value(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[9] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[8] += 1;
    } else {
      r.aggregate_value = x;
      if (counters[8] > 0) counters[8] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufUninterpretedOptionNamePart(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufUninterpretedOptionNamePart.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufUninterpretedOptionNamePart.Data memory r, ) = GoogleProtobufUninterpretedOptionNamePart._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    for(i = 0; i < r.name.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        2,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufUninterpretedOptionNamePart._encode_nested(r.name[i], pointer, bs);
    }
    pointer += ProtoBufRuntime._encode_key(
      3,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.identifier_value, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      4,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_uint64(r.positive_int_value, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      5,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_int64(r.negative_int_value, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      6,
      ProtoBufRuntime.WireType.Fixed64,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_int64(r.double_value, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      7,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bytes(r.string_value, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      8,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.aggregate_value, pointer, bs);
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    for(i = 0; i < r.name.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufUninterpretedOptionNamePart._estimate(r.name[i]));
    }
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.identifier_value).length);
    e += 1 + ProtoBufRuntime._sz_uint64(r.positive_int_value);
    e += 1 + ProtoBufRuntime._sz_int64(r.negative_int_value);
    e += 1 + 8;
    e += 1 + ProtoBufRuntime._sz_lendelim(r.string_value.length);
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.aggregate_value).length);
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {

    for(uint256 i2 = 0; i2 < input.name.length; i2++) {
      output.name.push(input.name[i2]);
    }
    
    output.identifier_value = input.identifier_value;
    output.positive_int_value = input.positive_int_value;
    output.negative_int_value = input.negative_int_value;
    output.double_value = input.double_value;
    output.string_value = input.string_value;
    output.aggregate_value = input.aggregate_value;

  }


  //array helpers for Name
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addName(Data memory self, GoogleProtobufUninterpretedOptionNamePart.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufUninterpretedOptionNamePart.Data[] memory tmp = new GoogleProtobufUninterpretedOptionNamePart.Data[](self.name.length + 1);
    for (uint256 i = 0; i < self.name.length; i++) {
      tmp[i] = self.name[i];
    }
    tmp[self.name.length] = value;
    self.name = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufUninterpretedOption

library GoogleProtobufUninterpretedOptionNamePart {


  //struct definition
  struct Data {
    string name_part;
    bool is_extension;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[3] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_name_part(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_is_extension(pointer, bs, r, counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_name_part(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[3] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.name_part = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_is_extension(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[3] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.is_extension = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    
    pointer += ProtoBufRuntime._encode_key(
      1,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.name_part, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      2,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_bool(r.is_extension, pointer, bs);
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.name_part).length);
    e += 1 + 1;
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.name_part = input.name_part;
    output.is_extension = input.is_extension;

  }



  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufUninterpretedOptionNamePart

library GoogleProtobufSourceCodeInfo {


  //struct definition
  struct Data {
    GoogleProtobufSourceCodeInfoLocation.Data[] location;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[2] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_location(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.location = new GoogleProtobufSourceCodeInfoLocation.Data[](counters[1]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_location(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_location(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[2] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufSourceCodeInfoLocation.Data memory x, uint256 sz) = _decode_GoogleProtobufSourceCodeInfoLocation(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.location[r.location.length - counters[1]] = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufSourceCodeInfoLocation(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufSourceCodeInfoLocation.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufSourceCodeInfoLocation.Data memory r, ) = GoogleProtobufSourceCodeInfoLocation._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    for(i = 0; i < r.location.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        1,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufSourceCodeInfoLocation._encode_nested(r.location[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    for(i = 0; i < r.location.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufSourceCodeInfoLocation._estimate(r.location[i]));
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {

    for(uint256 i1 = 0; i1 < input.location.length; i1++) {
      output.location.push(input.location[i1]);
    }
    

  }


  //array helpers for Location
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addLocation(Data memory self, GoogleProtobufSourceCodeInfoLocation.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufSourceCodeInfoLocation.Data[] memory tmp = new GoogleProtobufSourceCodeInfoLocation.Data[](self.location.length + 1);
    for (uint256 i = 0; i < self.location.length; i++) {
      tmp[i] = self.location[i];
    }
    tmp[self.location.length] = value;
    self.location = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufSourceCodeInfo

library GoogleProtobufSourceCodeInfoLocation {


  //struct definition
  struct Data {
    int32[] path;
    int32[] span;
    string leading_comments;
    string trailing_comments;
    string[] leading_detached_comments;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[7] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_path(pointer, bs, nil(), counters);
      }
      else if (fieldId == 2) {
        pointer += _read_span(pointer, bs, nil(), counters);
      }
      else if (fieldId == 3) {
        pointer += _read_leading_comments(pointer, bs, r, counters);
      }
      else if (fieldId == 4) {
        pointer += _read_trailing_comments(pointer, bs, r, counters);
      }
      else if (fieldId == 6) {
        pointer += _read_leading_detached_comments(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.path = new int32[](counters[1]);
    r.span = new int32[](counters[2]);
    r.leading_detached_comments = new string[](counters[6]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_path(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_span(pointer, bs, r, counters);
      }
      else if (fieldId == 3) {
        pointer += _read_leading_comments(pointer, bs, nil(), counters);
      }
      else if (fieldId == 4) {
        pointer += _read_trailing_comments(pointer, bs, nil(), counters);
      }
      else if (fieldId == 6) {
        pointer += _read_leading_detached_comments(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_path(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[7] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.path[r.path.length - counters[1]] = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_span(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[7] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.span[r.span.length - counters[2]] = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_leading_comments(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[7] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[3] += 1;
    } else {
      r.leading_comments = x;
      if (counters[3] > 0) counters[3] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_trailing_comments(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[7] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[4] += 1;
    } else {
      r.trailing_comments = x;
      if (counters[4] > 0) counters[4] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_leading_detached_comments(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[7] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[6] += 1;
    } else {
      r.leading_detached_comments[r.leading_detached_comments.length - counters[6]] = x;
      if (counters[6] > 0) counters[6] -= 1;
    }
    return sz;
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    for(i = 0; i < r.path.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        1,
        ProtoBufRuntime.WireType.Varint,
        pointer,
        bs)
      ;
      pointer += ProtoBufRuntime._encode_int32(r.path[i], pointer, bs);
    }
    for(i = 0; i < r.span.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        2,
        ProtoBufRuntime.WireType.Varint,
        pointer,
        bs)
      ;
      pointer += ProtoBufRuntime._encode_int32(r.span[i], pointer, bs);
    }
    pointer += ProtoBufRuntime._encode_key(
      3,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.leading_comments, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      4,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.trailing_comments, pointer, bs);
    for(i = 0; i < r.leading_detached_comments.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        6,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += ProtoBufRuntime._encode_string(r.leading_detached_comments[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    for(i = 0; i < r.path.length; i++) {
      e += 1 + ProtoBufRuntime._sz_int32(r.path[i]);
    }
    for(i = 0; i < r.span.length; i++) {
      e += 1 + ProtoBufRuntime._sz_int32(r.span[i]);
    }
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.leading_comments).length);
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.trailing_comments).length);
    for(i = 0; i < r.leading_detached_comments.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.leading_detached_comments[i]).length);
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.path = input.path;
    output.span = input.span;
    output.leading_comments = input.leading_comments;
    output.trailing_comments = input.trailing_comments;
    output.leading_detached_comments = input.leading_detached_comments;

  }


  //array helpers for Path
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addPath(Data memory self, int32  value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    int32[] memory tmp = new int32[](self.path.length + 1);
    for (uint256 i = 0; i < self.path.length; i++) {
      tmp[i] = self.path[i];
    }
    tmp[self.path.length] = value;
    self.path = tmp;
  }

  //array helpers for Span
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addSpan(Data memory self, int32  value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    int32[] memory tmp = new int32[](self.span.length + 1);
    for (uint256 i = 0; i < self.span.length; i++) {
      tmp[i] = self.span[i];
    }
    tmp[self.span.length] = value;
    self.span = tmp;
  }

  //array helpers for LeadingDetachedComments
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addLeadingDetachedComments(Data memory self, string memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    string[] memory tmp = new string[](self.leading_detached_comments.length + 1);
    for (uint256 i = 0; i < self.leading_detached_comments.length; i++) {
      tmp[i] = self.leading_detached_comments[i];
    }
    tmp[self.leading_detached_comments.length] = value;
    self.leading_detached_comments = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufSourceCodeInfoLocation

library GoogleProtobufGeneratedCodeInfo {


  //struct definition
  struct Data {
    GoogleProtobufGeneratedCodeInfoAnnotation.Data[] annotation;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[2] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_annotation(pointer, bs, nil(), counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.annotation = new GoogleProtobufGeneratedCodeInfoAnnotation.Data[](counters[1]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_annotation(pointer, bs, r, counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_annotation(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[2] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (GoogleProtobufGeneratedCodeInfoAnnotation.Data memory x, uint256 sz) = _decode_GoogleProtobufGeneratedCodeInfoAnnotation(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.annotation[r.annotation.length - counters[1]] = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  // struct decoder
  /**
   * @dev The decoder for reading a inner struct field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The decoded inner-struct
   * @return The number of bytes used to decode
   */
  function _decode_GoogleProtobufGeneratedCodeInfoAnnotation(uint256 p, bytes memory bs)
    internal
    pure
    returns (GoogleProtobufGeneratedCodeInfoAnnotation.Data memory, uint)
  {
    uint256 pointer = p;
    (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
    pointer += bytesRead;
    (GoogleProtobufGeneratedCodeInfoAnnotation.Data memory r, ) = GoogleProtobufGeneratedCodeInfoAnnotation._decode(pointer, bs, sz);
    return (r, sz + bytesRead);
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    for(i = 0; i < r.annotation.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        1,
        ProtoBufRuntime.WireType.LengthDelim,
        pointer,
        bs)
      ;
      pointer += GoogleProtobufGeneratedCodeInfoAnnotation._encode_nested(r.annotation[i], pointer, bs);
    }
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    for(i = 0; i < r.annotation.length; i++) {
      e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufGeneratedCodeInfoAnnotation._estimate(r.annotation[i]));
    }
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {

    for(uint256 i1 = 0; i1 < input.annotation.length; i1++) {
      output.annotation.push(input.annotation[i1]);
    }
    

  }


  //array helpers for Annotation
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addAnnotation(Data memory self, GoogleProtobufGeneratedCodeInfoAnnotation.Data memory value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    GoogleProtobufGeneratedCodeInfoAnnotation.Data[] memory tmp = new GoogleProtobufGeneratedCodeInfoAnnotation.Data[](self.annotation.length + 1);
    for (uint256 i = 0; i < self.annotation.length; i++) {
      tmp[i] = self.annotation[i];
    }
    tmp[self.annotation.length] = value;
    self.annotation = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufGeneratedCodeInfo

library GoogleProtobufGeneratedCodeInfoAnnotation {


  //struct definition
  struct Data {
    int32[] path;
    string source_file;
    int32 begin;
    int32 end;
  }

  // Decoder section

  /**
   * @dev The main decoder for memory
   * @param bs The bytes array to be decoded
   * @return The decoded struct
   */
  function decode(bytes memory bs) internal pure returns (Data memory) {
    (Data memory x, ) = _decode(32, bs, bs.length);
    return x;
  }

  /**
   * @dev The main decoder for storage
   * @param self The in-storage struct
   * @param bs The bytes array to be decoded
   */
  function decode(Data storage self, bytes memory bs) internal {
    (Data memory x, ) = _decode(32, bs, bs.length);
    store(x, self);
  }
  // inner decoder

  /**
   * @dev The decoder for internal usage
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param sz The number of bytes expected
   * @return The decoded struct
   * @return The number of bytes decoded
   */
  function _decode(uint256 p, bytes memory bs, uint256 sz)
    internal
    pure
    returns (Data memory, uint)
  {
    Data memory r;
    uint[5] memory counters;
    uint256 fieldId;
    ProtoBufRuntime.WireType wireType;
    uint256 bytesRead;
    uint256 offset = p;
    uint256 pointer = p;
    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_path(pointer, bs, nil(), counters);
      }
      else if (fieldId == 2) {
        pointer += _read_source_file(pointer, bs, r, counters);
      }
      else if (fieldId == 3) {
        pointer += _read_begin(pointer, bs, r, counters);
      }
      else if (fieldId == 4) {
        pointer += _read_end(pointer, bs, r, counters);
      }
      
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }

    }
    pointer = offset;
    r.path = new int32[](counters[1]);

    while (pointer < offset + sz) {
      (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
      pointer += bytesRead;
      if (fieldId == 1) {
        pointer += _read_path(pointer, bs, r, counters);
      }
      else if (fieldId == 2) {
        pointer += _read_source_file(pointer, bs, nil(), counters);
      }
      else if (fieldId == 3) {
        pointer += _read_begin(pointer, bs, nil(), counters);
      }
      else if (fieldId == 4) {
        pointer += _read_end(pointer, bs, nil(), counters);
      }
      else {
        if (wireType == ProtoBufRuntime.WireType.Fixed64) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed64(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Fixed32) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_fixed32(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.Varint) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_varint(pointer, bs);
          pointer += size;
        }
        if (wireType == ProtoBufRuntime.WireType.LengthDelim) {
          uint256 size;
          (, size) = ProtoBufRuntime._decode_lendelim(pointer, bs);
          pointer += size;
        }
      }
    }
    return (r, sz);
  }

  // field readers

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_path(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[5] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[1] += 1;
    } else {
      r.path[r.path.length - counters[1]] = x;
      if (counters[1] > 0) counters[1] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_source_file(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[5] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
    if (isNil(r)) {
      counters[2] += 1;
    } else {
      r.source_file = x;
      if (counters[2] > 0) counters[2] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_begin(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[5] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[3] += 1;
    } else {
      r.begin = x;
      if (counters[3] > 0) counters[3] -= 1;
    }
    return sz;
  }

  /**
   * @dev The decoder for reading a field
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @param r The in-memory struct
   * @param counters The counters for repeated fields
   * @return The number of bytes decoded
   */
  function _read_end(
    uint256 p,
    bytes memory bs,
    Data memory r,
    uint[5] memory counters
  ) internal pure returns (uint) {
    /**
     * if `r` is NULL, then only counting the number of fields.
     */
    (int32 x, uint256 sz) = ProtoBufRuntime._decode_int32(p, bs);
    if (isNil(r)) {
      counters[4] += 1;
    } else {
      r.end = x;
      if (counters[4] > 0) counters[4] -= 1;
    }
    return sz;
  }


  // Encoder section

  /**
   * @dev The main encoder for memory
   * @param r The struct to be encoded
   * @return The encoded byte array
   */
  function encode(Data memory r) internal pure returns (bytes memory) {
    bytes memory bs = new bytes(_estimate(r));
    uint256 sz = _encode(r, 32, bs);
    assembly {
      mstore(bs, sz)
    }
    return bs;
  }
  // inner encoder

  /**
   * @dev The encoder for internal usage
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    uint256 offset = p;
    uint256 pointer = p;
    uint256 i;
    for(i = 0; i < r.path.length; i++) {
      pointer += ProtoBufRuntime._encode_key(
        1,
        ProtoBufRuntime.WireType.Varint,
        pointer,
        bs)
      ;
      pointer += ProtoBufRuntime._encode_int32(r.path[i], pointer, bs);
    }
    pointer += ProtoBufRuntime._encode_key(
      2,
      ProtoBufRuntime.WireType.LengthDelim,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_string(r.source_file, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      3,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_int32(r.begin, pointer, bs);
    pointer += ProtoBufRuntime._encode_key(
      4,
      ProtoBufRuntime.WireType.Varint,
      pointer,
      bs
    );
    pointer += ProtoBufRuntime._encode_int32(r.end, pointer, bs);
    return pointer - offset;
  }
  // nested encoder

  /**
   * @dev The encoder for inner struct
   * @param r The struct to be encoded
   * @param p The offset of bytes array to start decode
   * @param bs The bytes array to be decoded
   * @return The number of bytes encoded
   */
  function _encode_nested(Data memory r, uint256 p, bytes memory bs)
    internal
    pure
    returns (uint)
  {
    /**
     * First encoded `r` into a temporary array, and encode the actual size used.
     * Then copy the temporary array into `bs`.
     */
    uint256 offset = p;
    uint256 pointer = p;
    bytes memory tmp = new bytes(_estimate(r));
    uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
    uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
    uint256 size = _encode(r, 32, tmp);
    pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
    ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
    pointer += size;
    delete tmp;
    return pointer - offset;
  }
  // estimator

  /**
   * @dev The estimator for a struct
   * @param r The struct to be encoded
   * @return The number of bytes encoded in estimation
   */
  function _estimate(
    Data memory r
  ) internal pure returns (uint) {
    uint256 e;uint256 i;
    for(i = 0; i < r.path.length; i++) {
      e += 1 + ProtoBufRuntime._sz_int32(r.path[i]);
    }
    e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.source_file).length);
    e += 1 + ProtoBufRuntime._sz_int32(r.begin);
    e += 1 + ProtoBufRuntime._sz_int32(r.end);
    return e;
  }

  //store function
  /**
   * @dev Store in-memory struct to storage
   * @param input The in-memory struct
   * @param output The in-storage struct
   */
  function store(Data memory input, Data storage output) internal {
    output.path = input.path;
    output.source_file = input.source_file;
    output.begin = input.begin;
    output.end = input.end;

  }


  //array helpers for Path
  /**
   * @dev Add value to an array
   * @param self The in-memory struct
   * @param value The value to add
   */
  function addPath(Data memory self, int32  value) internal pure {
    /**
     * First resize the array. Then add the new element to the end.
     */
    int32[] memory tmp = new int32[](self.path.length + 1);
    for (uint256 i = 0; i < self.path.length; i++) {
      tmp[i] = self.path[i];
    }
    tmp[self.path.length] = value;
    self.path = tmp;
  }


  //utility functions
  /**
   * @dev Return an empty struct
   * @return r The empty struct
   */
  function nil() internal pure returns (Data memory r) {
    assembly {
      r := 0
    }
  }

  /**
   * @dev Test whether a struct is empty
   * @param x The struct to be tested
   * @return r True if it is empty
   */
  function isNil(Data memory x) internal pure returns (bool r) {
    assembly {
      r := iszero(x)
    }
  }
}
//library GoogleProtobufGeneratedCodeInfoAnnotation