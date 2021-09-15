#!/usr/bin/env bash
set -e

SOLPB_DIR_2="/home/admin/Projects/protobuf3-solidity/bin/"

rm -rf ./contracts/core/types/* 2>/dev/null
rm -rf /tmp/proto 2>/dev/null
cp -r ./proto /tmp/

mkdir -p contracts/core/types/gogoproto
echo "pragma solidity ^0.6.8;" > contracts/core/types/gogoproto/gogo.sol

if [ -z "$SOLPB_DIR" ]; then
    echo "variable SOLPB_DIR must be set"
    exit 1
fi

for file in $(find ./proto -name '*.proto')
do
  #TM=$(echo $file | grep -v "tendermint" -q)
  #if [[  $TM -eq 1 ]]; then continue; fi

  #TM=$(echo $file | grep "tendermint_light" )
  #echo $TM
  #if [[  $TM -eq 0 ]]; then continue; fi

  #if [[ "$file" == "./proto/tendermint_light.proto" ]]; then continue; fi
  if [[ "$file" == "./proto/app/App.proto" ]]; then continue; fi
  if [[ "$file" == "./proto/client/mock/MockClient.proto" ]]; then continue; fi
  # ^^ removing App.Proto and mock client helped truffle debug??

  echo "Generating "$file

  PP=/tmp
  sed -i "s/package tendermint.*;//g" $PP/$file 

  #set -x
  protoc -I$PP/proto -I "third_party/proto" -I${SOLPB_DIR}/protobuf-solidity/src/protoc/include --plugin=protoc-gen-sol=${SOLPB_DIR}/protobuf-solidity/src/protoc/plugin/gen_sol.py --"sol_out=gen_runtime=ProtoBufRuntime.sol&solc_version=0.6.8:$(pwd)/contracts/core/types/" $PP/$file

  #set -x
  #echo /tmp/$file
  #sed -E -i "s/\s\[\(gogoproto.*;/;/g" /tmp/$file
  #sed -i "s/option (gogoproto\..*) = false;//g" /tmp/$file;
  #sed -i "s/import \"gogoproto\/gogo.proto\";//g" /tmp/$file;
  #protoc -I "third_party/proto" -I/tmp/proto --plugin $SOLPB_DIR_2/protoc-gen-sol --sol_out . /tmp/$file

done




for file in $(find $(pwd)/contracts/core/types -name '*.sol')
do
    FFF=$(echo $(basename $file))
    if [ "$FFF" = "gogo.sol" ]; then continue; fi

    # comment out duplicates (for inner structs some functions are generated twice)
    sed -i '1823,1833 {s/^/\/\//}' contracts/core/types/descriptor.sol
    sed -i '1248,1258 {s/^/\/\//}' contracts/core/types/tendermint_light.sol
    sed -i '1229,1239 {s/^/\/\//}' contracts/core/types/tendermint_light.sol
    sed -i '3906,3916 {s/^/\/\//}' contracts/core/types/tendermint_light.sol
    sed -i '8500,8510 {s/^/\/\//}' contracts/core/types/tendermint_light.sol
    #sed -i '1442,1459 {s/^/\/\//}' contracts/core/types/tendermint_light.sol
    #sed -i '3073,3083 {s/^/\/\//}' contracts/core/types/tendermint_light.sol
    #sed -i '7648,7658 {s/^/\/\//}' contracts/core/types/tendermint_light.sol

    sed -i "s/google_protobuf_FieldDescriptorProto\./GoogleProtobufFieldDescriptorProto\./g" "contracts/core/types/$FFF"
    sed -i "s/tendermint_types\./TYPES_PROTO_GLOBAL_ENUMS\./g" "contracts/core/types/$FFF"
    sed -i "s/google_protobuf_FileOptions\./GoogleProtobufFileOptions\./g" "contracts/core/types/$FFF"
    sed -i "s/google_protobuf_FieldOptions\./GoogleProtobufFieldOptions\./g" "contracts/core/types/$FFF"
    sed -i "s/google_protobuf_MethodOptions\./GoogleProtobufMethodOptions\./g" "contracts/core/types/$FFF"


    sed -i "s/\/tendermint\/crypto//g" "contracts/core/types/$FFF"
    sed -i "s/\/tendermint\/version//g" "contracts/core/types/$FFF"
    sed -i "s/\/tendermint\/types//g" "contracts/core/types/$FFF"
    sed -i "s/\/google\/protobuf\/timestamp\.sol/\/timestamp\.sol/g" "contracts/core/types/$FFF"
    sed -i "s/TENDERMINT\/TYPES\/TYPES_PROTO_GLOBAL_ENUMS/TYPES_PROTO_GLOBAL_ENUMS/g" "contracts/core/types/$FFF"
done

# npx truffle compile
