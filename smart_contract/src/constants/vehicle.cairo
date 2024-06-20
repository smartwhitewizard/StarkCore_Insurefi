use starknet::ContractAddress;

#[derive(Drop, Copy, Serde, Clone, starknet::Store)]
pub struct Vehicle {
    pub id: u128,
    pub driver_age: u8,
    pub no_of_accidents: u8,
    pub violations: u8,
    pub vehicle_Category: i16,
    pub vehicle_age: u8,
    pub milage: u32,
    pub safety_features: i16,
    pub coverage_type: u16,
    pub value: i32,
    pub driver: ContractAddress,
    pub insured: bool,
    pub premium: u32,
    pub vehicle_policy: Vehicle_Policy,
    pub claim_status: bool,
    pub img_url: felt252,
    pub voting_power: bool
}



#[derive(Drop, Copy, Serde, starknet::Store)]
pub struct Vehicle_Policy {
    pub policy_creation_date: u64,
    pub policy_termination_date: u64,
    pub policy_last_payment_date: u64,
    pub policy_is_active: bool,
    pub policy_holder: ContractAddress,
}