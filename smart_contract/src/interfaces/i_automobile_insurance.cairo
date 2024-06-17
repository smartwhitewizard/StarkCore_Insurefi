use smart_contract::constants::vehicle::Vehicle;
use starknet::{ContractAddress};
use smart_contract::constants::{vehicle_request::Vehicle_Request, claim_status::ClaimStatus};

use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::token::erc20::ERC20Component;
    // use openzeppelin::token::erc20::ERC20HooksEmptyImpl;
    use openzeppelin::upgrades::UpgradeableComponent;
    use openzeppelin::upgrades::interface::IUpgradeable;
    use starknet::ClassHash;

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
    fn mint(ref self: T, recipient: ContractAddress, amount: u256);
    fn burn(ref self: T,recipient: ContractAddress, amount: u256);
}