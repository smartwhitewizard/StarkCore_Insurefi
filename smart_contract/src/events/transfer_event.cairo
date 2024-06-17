use starknet::ContractAddress;

#[derive(Drop, starknet::Event)]
pub struct Transfer {
    #[key]
    pub from: ContractAddress,
    #[key]
    pub to: ContractAddress,
    pub value: u256,
}


#[derive(Drop, starknet::Event)]
pub struct TransferFrom {
    #[key]
    pub from: ContractAddress,
    #[key]
    pub initiator: ContractAddress,
    #[key]
    pub to: ContractAddress,
    pub value: u256,
}
