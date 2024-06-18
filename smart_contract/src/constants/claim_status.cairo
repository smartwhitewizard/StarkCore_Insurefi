#[derive(Drop, Serde, starknet::Store)]
pub enum ClaimStatus {
    Processing,
    Approved,
    Claimed,
    Denied,
}
