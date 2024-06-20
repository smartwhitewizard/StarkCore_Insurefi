use starknet::{ContractAddress};
use smart_contract::constants::claim_status::ClaimStatus;

#[derive(Drop, Serde, starknet::Store)]
pub struct Claim {
    pub id: u128,
    pub policy_holder: ContractAddress,
    pub claim_amount: u256,
    pub claim_details: ByteArray,
    pub claim_status: ClaimStatus,
    pub accident_image: ByteArray,
    pub claim_vote: u32
}
