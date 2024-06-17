#[derive(Drop, Serde, starknet::Store)]
pub enum ClaimStatus {
    Claimed,
    Processing,
    Denied,
}
