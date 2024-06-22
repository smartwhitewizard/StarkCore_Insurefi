use smart_contract::constants::vehicle::Vehicle;
use smart_contract::constants::claim::Claim;
use starknet::{ContractAddress};
use smart_contract::constants::{vehicle_request::Vehicle_Request, claim_status::ClaimStatus};

use openzeppelin::access::ownable::OwnableComponent;
use openzeppelin::token::erc20::ERC20Component;
use openzeppelin::upgrades::UpgradeableComponent;
use openzeppelin::upgrades::interface::IUpgradeable;
use starknet::ClassHash;

#[starknet::interface]
pub trait I_automobile_insurance<T> {
    fn register_vehicle(ref self: T, vehicle_request: Vehicle_Request) -> bool;
    fn generate_premium(ref self: T, policy_id: u128) -> u32;
    fn initiate_policy(ref self: T, policy_id: u128) -> bool;
    fn renew_policy(ref self: T, policy_id: u128) -> bool;
    fn get_owner(self: @T) -> ContractAddress;
    fn get_specific_vehicle(self: @T, id: u128) -> Vehicle;
    fn get_specific_vehiclea(self: @T, id: u128) -> u128;
    fn get_specific_driver(self: @T, id: u128) -> ContractAddress;
    fn file_claim(
        ref self: T, id: u128, claim_amount: u256, claim_details: ByteArray, image: ByteArray
    ) -> bool;
    fn mint(ref self: T, recipient: ContractAddress, amount: u256);
    fn burn(ref self: T, recipient: ContractAddress, amount: u256);
    fn get_user_insurance(self: @T, user_address: ContractAddress) -> Array::<Vehicle>;
    fn set_dao_address(ref self: T, dao_address: ContractAddress) -> bool;
    fn get_number_of_user_vehicle_insured(self: @T, user_address: ContractAddress) -> u128;
    fn get_policies_count(self: @T) -> u128;
    fn finalize_and_execute_claim(ref self: T, claim_id: u128) -> bool;
    fn finalize_and_reject_claim(ref self: T, claim_id: u128) -> bool;
}
