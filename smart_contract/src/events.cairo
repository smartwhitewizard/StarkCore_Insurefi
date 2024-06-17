pub mod policy_initiated;
pub mod policy_renewal_event;

use core::starknet::event::{EventEmitter, };

use smart_contract::events::{
    policy_initiated::Policy_initiated, policy_renewal_event::Policy_renewed
};


#[event]
#[derive(Drop, starknet::Event)]
pub enum Events {
    
    Policy_initiated: Policy_initiated,
    Policy_renewed: Policy_renewed,
    
}
