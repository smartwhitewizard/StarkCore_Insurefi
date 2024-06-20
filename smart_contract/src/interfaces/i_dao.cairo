

use starknet::ContractAddress;
use smart_contract::constants::claim::Claim;
use smart_contract::dao::Claim_Proposal;


#[starknet::interface]
pub trait I_Dao<T> {
    fn view_claim(self: @T, claim_id: u128) -> Claim_Proposal;
    fn get_all_claims(self: @T) -> Array::<Claim_Proposal>;  
    fn get_user_claims(self: @T, user_address: ContractAddress) -> Array::<Claim_Proposal>;  
    fn vote_on_proposal_claim(ref self: T, proposal_claim_id: u128, user_address: ContractAddress, decision: u8) -> bool;
    fn create_proposal(ref self: T, claim_amount: u256, user_address: ContractAddress, image: ByteArray) -> bool;
    fn set_automobile_insurance_address(ref self: T, automobile_insurance_address: ContractAddress) -> bool;
}