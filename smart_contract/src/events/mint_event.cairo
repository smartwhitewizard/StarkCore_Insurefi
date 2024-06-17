use starknet::ContractAddress;

#[derive(Drop, starknet::Event)]
pub struct Mint {
    #[key]
    pub to: ContractAddress,
    pub value: u256,
}
