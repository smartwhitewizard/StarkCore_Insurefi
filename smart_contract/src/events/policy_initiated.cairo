
use starknet::ContractAddress;

#[derive(Drop, starknet::Event)]
pub struct Policy_initiated {
    #[key]
    pub policy_id: u8,
    #[key]
    pub policy_holder: ContractAddress,
}