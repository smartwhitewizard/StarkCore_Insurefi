use snforge_std::{
    declare, ContractClassTrait, cheat_caller_address, start_cheat_caller_address,
    stop_cheat_caller_address, CheatSpan, spy_events, SpyOn, EventSpy, EventAssertions
};
use smart_contract::automobile_policy::Automobile_calculator;
use smart_contract::automobile_policy::Iautomobile_insuranceDispatcherTrait;
use smart_contract::automobile_policy::Iautomobile_insuranceDispatcher;
use starknet::ContractAddress;
use core::traits::TryInto;


fn deploy_contract(name: ByteArray) -> ContractAddress {
    let admin_address: ContractAddress = 'admin'.try_into().unwrap();
    let contract = declare(name).unwrap();
    let (contract_address, _) = contract.deploy(@array![admin_address.into()]).unwrap();
    contract_address
}

#[test]
fn test_initial_owner() {
    let admin_address: ContractAddress = 'admin'.try_into().unwrap();
    let contract_address = deploy_contract("Automobile_calculator");
    let dispatcher = Iautomobile_insuranceDispatcher { contract_address };

    let initial_owner = dispatcher.get_owner();

    assert(initial_owner == admin_address, 'incorrect admin');
}

#[test]
fn test_for_vehicle_registration() {
    let admin_address: ContractAddress = 'admin'.try_into().unwrap();
    let contract_address = deploy_contract("Automobile_calculator");
    let dispatcher = Iautomobile_insuranceDispatcher { contract_address };


    cheat_caller_address(contract_address, admin_address, CheatSpan::Indefinite);
    let driver: ContractAddress = 'first_voter'.try_into().unwrap();
    let sf = 'sf2';
    let cv = 'collision';
    let ca = 'economy';
    let vehicle = dispatcher.register_vehicle(driver, 25, 2, 0, ca, 21, 20100, sf, cv, 30000 );

    let registered = dispatcher.get_specific_vehiclea(1);

    let age: bool = registered == 1; 

    assert(age, 'Did not registered Properly');

    assert(vehicle, 'Did not registered');

    let premium = dispatcher.generate_premium(1);

    let pre = premium == 67500;

    assert(pre, 'wrong math');

    // /////////// VEHICLE 2

    // let driver1: ContractAddress = 'DRIVER1'.try_into().unwrap();
    // let sf1 = 'all';
    // let cv1 = 'comprehensive';
    // let ca1 = 'luxury';

    let vehicle1 = dispatcher.register_vehicle(driver, 25, 2, 0, ca, 21, 20100, sf, cv, 30000 );

    let registered1 = dispatcher.get_specific_vehiclea(2);

    let age1: bool = registered1 == 2; 

    assert(age1, 'Did not registered Properly');

    assert(vehicle1, 'Did not registered');

    let premium1 = dispatcher.generate_premium(2);

    let pre1 = premium1 == 67500;

    assert(pre1, 'wrong math vehicle 2')
}

// #[test]
// fn test_for_candidate_registration() {
//     let admin_address: ContractAddress = 'admin'.try_into().unwrap();
//     let contract_address = deploy_contract("Voting");
//     let dispatcher = IVotingDispatcher { contract_address };

//     cheat_caller_address(contract_address, admin_address, CheatSpan::Indefinite);
//     let candidate_name: felt252 = 'Peter Obi';

//     let has_added = dispatcher.add_candidate(candidate_name);
//     assert(has_added, 'Did not add');
// }

// #[test]
// fn test_for_voting() {
//     let admin_address: ContractAddress = 'admin'.try_into().unwrap();
//     let contract_address = deploy_contract("Voting");
//     let dispatcher = IVotingDispatcher { contract_address };

//     start_cheat_caller_address(contract_address, admin_address);

//     let first_voter: ContractAddress = 'first_voter'.try_into().unwrap();
//     let is_registered = dispatcher.register_voter(first_voter);
//     assert(is_registered, 'Did not registered');

//     let candidate_name: felt252 = 'Peter Obi';
//     let has_added = dispatcher.add_candidate(candidate_name);
//     assert(has_added, 'Did not add');

//     stop_cheat_caller_address(contract_address);

//     start_cheat_caller_address(contract_address, first_voter);

//     let has_voted = dispatcher.vote(1);
//     assert(has_voted, 'Voting not proccessed');
// }