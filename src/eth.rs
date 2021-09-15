use std::fs::File;
use std::io::BufReader;
use std::path::Path;
use std::error::Error;
use serde::{Deserialize, Serialize};
use web3::{
	contract::Contract,
	types::H160
};

#[derive(Deserialize, Serialize, Debug)]
pub struct ABI {
	abi: Vec<serde_json::Value>,
}

pub fn read_abi_from_file<P: AsRef<Path>>(path: P) -> Result<ABI, Box<dyn Error>> {
	let file = File::open(path)?;
	let reader = BufReader::new(file);

	let abi: ABI = serde_json::from_reader(reader)?;

	Ok(abi)
}

pub fn load_contract<'a, T: web3::Transport>(transport: &'a T, abipath: &'static str, address: &'static str) -> Contract<&'a T> {
	let web3 = web3::Web3::new(transport);
	let abi = read_abi_from_file(abipath).unwrap();
	let serialized_abi: Vec<u8> = serde_json::to_vec(&abi.abi).unwrap();

	let raw: Vec<u8> = hex::decode(&address[2..address.len()]).unwrap();
	let mut addr: [u8; 20] = Default::default();
	addr.copy_from_slice(&raw[0..20]);

	Contract::from_json(
		web3.eth(),
		H160::from(&addr),
		&serialized_abi,
	).unwrap()
}
