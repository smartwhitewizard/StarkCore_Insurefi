pub mod policy_initiated;
pub mod burn_event;
pub mod transfer_event;
pub mod approval_event;
pub mod mint_event;
pub mod policy_renewal_event;

use core::starknet::event::{EventEmitter, };

use smart_contract::events::{
    policy_initiated::Policy_initiated, burn_event::Burn, transfer_event::{Transfer, TransferFrom},
    approval_event::Approval, mint_event::Mint, policy_renewal_event::Policy_renewed
};


#[event]
#[derive(Drop, starknet::Event)]
pub enum Events {
    Transfer: Transfer,
    Approval: Approval,
    Mint: Mint,
    Burn: Burn,
    Policy_initiated: Policy_initiated,
    Policy_renewed: Policy_renewed,
    TransferFrom: TransferFrom,
}
