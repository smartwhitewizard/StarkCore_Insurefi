
use starknet::ContractAddress;

#[derive(Drop, starknet::Event)]
pub struct Burn {
    #[key]
    pub from: ContractAddress,
    pub value: u256,
}