use smart_contract::automobile_policy::{Automobile_calculator::Vehicle, Vehicle_Request};
use starknet::{ContractAddress};

#[starknet::interface]
pub trait I_automobile_insurance<T> {
    fn register_vehicle(
        ref self: T,
        vehicle_request: Vehicle_Request
    ) -> bool;
    fn generate_premium(ref self: T, policy_id: u8) -> u32;
    fn initiate_policy(ref self: T, policy_id: u8) -> bool;
    fn renew_policy(ref self: T, policy_id: u8) -> bool;
    fn get_owner(self: @T) -> ContractAddress;
    fn get_specific_vehicle(self: @T, id: u8) -> Vehicle;
    fn get_specific_vehiclea(self: @T, id: u8) -> u8;
    fn get_specific_driver(self: @T, id: u8) -> ContractAddress;
    fn file_claim(
        ref self: T, id: u8, claim_amount: u256, claim_details: ByteArray, image: ByteArray
    ) -> bool;

    fn name(self: @T) -> felt252;
    fn symbol(self: @T) -> felt252;
    fn decimals(self: @T) -> u8;
    fn totalSupply(self: @T) -> u256;
    fn balanceOf(self: @T, owner: ContractAddress) -> u256;

    fn transfer(ref self: T, to: ContractAddress, value: u256) -> bool;
    fn transferFrom(ref self: T, from: ContractAddress, to: ContractAddress, value: u256) -> bool;
    fn approve(ref self: T, spender: ContractAddress, value: u256) -> bool;
    fn allowance(self: @T, owner: ContractAddress, spender: ContractAddress) -> u256;

    // Mint and Burn
    fn mint(ref self: T, to: ContractAddress, value: u256);
    fn burn(ref self: T, from: ContractAddress, value: u256);
}