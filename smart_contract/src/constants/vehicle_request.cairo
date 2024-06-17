

use starknet::ContractAddress;

#[derive(Drop, Copy, Serde)]
pub struct Vehicle_Request {
    pub driver: ContractAddress,
    pub driver_age: u8,
    pub no_of_accidents: u8,
    pub violations: u8,
    pub vehicle_category: felt252,
    pub vehicle_age: u8,
    pub mileage: u32,
    pub safety_features: felt252,
    pub coverage_type: felt252,
    pub value: i32
}