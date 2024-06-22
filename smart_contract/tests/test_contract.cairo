use snforge_std::{
    declare, ContractClassTrait, cheat_caller_address, start_cheat_caller_address,
    stop_cheat_caller_address, CheatSpan, spy_events, SpyOn, EventSpy, EventAssertions
};
use smart_contract::automobile_policy::{Automobile_calculator, };
use smart_contract::constants::{vehicle_request::Vehicle_Request, };
use smart_contract::interfaces::i_automobile_insurance::I_automobile_insuranceDispatcherTrait;
use smart_contract::interfaces::i_automobile_insurance::I_automobile_insuranceDispatcher;
// use smart_contract::interfaces::i_dao::I_DaoDispatcherTrait;
// use smart_contract::interfaces::i_dao::I_DaoinsuranceDispatcher;
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
    let dispatcher = I_automobile_insuranceDispatcher { contract_address };

    let initial_owner = dispatcher.get_owner();

    assert(initial_owner == admin_address, 'incorrect admin');
}

fn generate_vehicle_request() -> Vehicle_Request {
    Vehicle_Request {
        driver: 'first_voter'.try_into().unwrap(),
        driver_age: 25,
        no_of_accidents: 2,
        violations: 0,
        vehicle_category: 'economy',
        vehicle_age: 21,
        mileage: 20100,
        safety_features: 'sf2',
        coverage_type: 'collision',
        value: 30000
    }
}

#[test]
fn test_for_vehicle_registration() {
let _admin_address: ContractAddress = 'admin'.try_into().unwrap();
    let contract_address = deploy_contract("Automobile_calculator");
    let contract_two_address = deploy_contract("Dao");
    
    let dispatcher = I_automobile_insuranceDispatcher { contract_address };

    let driver: ContractAddress = 'first_voter'.try_into().unwrap();
    cheat_caller_address(contract_address, driver, CheatSpan::Indefinite);

    let mut vehicle_request = generate_vehicle_request();
    vehicle_request.driver = driver;
    let vehicle = dispatcher.register_vehicle(vehicle_request);

    let registered = dispatcher.get_specific_vehiclea(1);

    let age: bool = registered == 1; 

    assert(age, 'Did not registered Properly');

    assert(vehicle, 'Did not registered');

    let premium = dispatcher.generate_premium(1);

    let pre = premium == 67500;

    assert(pre, 'wrong math');

    
    cheat_caller_address(contract_address, _admin_address, CheatSpan::Indefinite);
    dispatcher.mint(driver, 70000000);
    dispatcher.mint(_admin_address, 700000000000000);
    dispatcher.set_dao_address(contract_two_address);
   
    cheat_caller_address(contract_address, driver, CheatSpan::Indefinite);
    
    dispatcher.initiate_policy(1);
    
    let t: ByteArray = "I was in an accident";
    
    let r: ByteArray = "I was in an accident";
    
    
    
    dispatcher.file_claim(1, 6, t, r);
    
    cheat_caller_address(contract_address, _admin_address, CheatSpan::Indefinite);
    dispatcher.finalize_and_execute_claim(1);
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