#[derive(Drop, Serde, Clone, starknet::Store)]
pub enum ClaimStatus {
    Processing,
    Approved,
    Claimed,
    Denied,
}
