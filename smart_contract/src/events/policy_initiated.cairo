
use starknet::ContractAddress;
// use starknet::event::EventEmitter;

#[derive(Drop, starknet::Event)]
pub struct Policy_initiated {
    #[key]
    pub policy_id: u8,
    #[key]
    pub policy_holder: ContractAddress,
}