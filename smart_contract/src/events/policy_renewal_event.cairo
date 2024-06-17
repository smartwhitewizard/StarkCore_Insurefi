use starknet::ContractAddress;

#[derive(Drop, starknet::Event)]
pub struct Policy_renewed {
    #[key]
    pub policy_id: u128,
    #[key]
    pub policy_holder: ContractAddress,
}
