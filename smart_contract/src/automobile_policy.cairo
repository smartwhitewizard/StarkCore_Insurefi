use starknet::ContractAddress;

#[starknet::interface]
pub trait Iautomobile_insurance<T> {
    fn register_vehicle(ref self: T, driver: ContractAddress, driver_age: u8, no_of_accidents:u8, violations: u8, vehicle_category: felt252, vehicle_age: u8, mileage: u32, safety_features: felt252, coverage_type: felt252, value: i32) -> bool;
    fn generate_premium(ref self: T, policy_id: u8) -> u32;
    // fn initiate_policy(ref self: T, policy_id: u8) -> bool;
    fn get_owner(self: @T) -> ContractAddress;
    fn get_specific_vehicle(self: @T, id: u8) -> Automobile_calculator::Vehicle;
    fn get_specific_vehiclea(self: @T, id: u8) -> u8;


    fn name(self: @T) -> felt252;
    fn symbol(self: @T) -> felt252;
    fn decimals(self: @T) -> u8;
    fn totalSupply(self: @T) -> u256;
    fn balanceOf(self: @T, owner: ContractAddress) -> u256;

    fn transfer(ref self: T, to: ContractAddress, value: u256) -> bool;
    fn transferFrom(
        ref self: T, from: ContractAddress, to: ContractAddress, value: u256
    ) -> bool;
    fn approve(ref self: T, spender: ContractAddress, value: u256) -> bool;
    fn allowance(self: @T, owner: ContractAddress, spender: ContractAddress) -> u256;

    // Mint and Burn
    fn mint(ref self: T, to: ContractAddress, value: u256);
    fn burn(ref self: T, from: ContractAddress, value: u256);
   
}

#[starknet::contract]
pub mod Automobile_calculator {
use core::option::OptionTrait;
use core::traits::Into;
use core::starknet::event::EventEmitter;
use super::ContractAddress;
use starknet:: {get_block_timestamp, contract_address_const, get_caller_address};

    #[storage]
    struct Storage {
        policies: LegacyMap<u8, Vehicle>,
        // voters: Array<ContractAddress>,
        vehicle_owner: LegacyMap<ContractAddress, Vehicle>,
        policiy_holder: LegacyMap<u8, ContractAddress>,
        policy_id_counter: u8,
        owner: ContractAddress,
        safetyFeatureAdjustments: LegacyMap<felt252, i16>,
        coverageTypeMultipliers: LegacyMap<felt252, u16>,
        vehicleCategories: LegacyMap<felt252, i16>,
        name: felt252,
        symbol: felt252,
        decimals: u8,
        totalSupply: u256,
        balances: LegacyMap::<ContractAddress, u256>,
        allowances: LegacyMap::<(ContractAddress, ContractAddress), u256>,
    }

    #[derive(Drop,Serde, starknet::Store)]
    pub enum ClaimStatus {
        Claimed,
        Processing,
        Denied,
    }

    #[derive(Drop, Serde, starknet::Store)]
    pub struct Vehicle {
        id: u8,
        driver_age: u8,
        no_of_accidents: u8,
        violations: u8,
        vehicle_Category: i16,
        vehicle_age: u8,
        milage: u32,
        safety_features: i16,
        coverage_type: u16,
        value: i32,
        driver: ContractAddress,
        insured: bool,
        premium: u32,
        policy_creation_date: u64,
        policy_termination_date: u64,
        policy_last_payment_date: u64,
        policy_is_active:bool,
        policy_holder: ContractAddress,
        claim_status: bool,
        img_url:felt252,
        voting_power: bool

    }
    #[derive(Drop, Serde, starknet::Store)]
    pub struct Claim {
        id: u8,
        policy_holder: ContractAddress,
        claim_amount: u8,
        claim_details: ByteArray,
        claim_status: ClaimStatus,
        accident_image: felt252      

    }

    #[derive(Drop, Serde, starknet::Store)]
   pub trait Processing {
        fn process(self: ClaimStatus);
    }
    
    // Events
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer: Transfer,
        Approval: Approval,
        Mint: Mint,
        Burn: Burn,
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        #[key]
        from: ContractAddress,
        to: ContractAddress,
        value: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct Approval {
        #[key]
        owner: ContractAddress,
        spender: ContractAddress,
        value: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct Mint {
        #[key]
        to: ContractAddress,
        value: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct Burn {
        #[key]
        from: ContractAddress,
        value: u256,
    }

   

    

    #[constructor]
    fn constructor(ref self: ContractState, initial_owner: ContractAddress) {
        self.owner.write(initial_owner);
         self.set_categories();
         self.name.write('INSUREFI');
        self.symbol.write('IFI');
        self.decimals.write(18);
    }


    #[abi(embed_v0)]
    impl Automobile_insuranceImpl of super::Iautomobile_insurance<ContractState> {
        // register vehicle
        fn register_vehicle(ref self: ContractState, driver: ContractAddress, driver_age: u8, no_of_accidents:u8, violations: u8, vehicle_category: felt252, vehicle_age: u8, mileage: u32, safety_features: felt252, coverage_type: felt252, value: i32) -> bool {
            let id = self.policy_id_counter.read() + 1;

            let vc = self.vehicleCategories.read(vehicle_category);
            let sf = self.safetyFeatureAdjustments.read(safety_features);
            let cv = self.coverageTypeMultipliers.read(coverage_type);

            let vehicle_data = Vehicle { id: id, driver: driver, driver_age: driver_age, no_of_accidents: no_of_accidents, violations: violations, vehicle_age: vehicle_age, milage:mileage, vehicle_Category: vc, safety_features: sf, coverage_type:cv, value: value, insured: false, premium: 0, policy_creation_date: 0, policy_termination_date: 0, policy_last_payment_date: 0, policy_is_active:false, policy_holder:driver, claim_status: false, img_url: 'Blank', voting_power: false};

            self.policies.write(id, vehicle_data);
            self.policy_id_counter.write(id);
            true
        }

        fn get_specific_vehicle(self: @ContractState, id: u8) -> Vehicle {
            let vehicle = self.policies.read(id);
            vehicle
        }

        fn get_specific_vehiclea(self: @ContractState, id: u8) -> u8 {
            let vehicle = self.policies.read(id);
            vehicle.id
        }

        fn generate_premium(ref self: ContractState, policy_id: u8) -> u32 {
            let mut newPolicy = self.policies.read(policy_id);

            let  category = newPolicy.vehicle_Category;

            let mut vehicle_risk = 0;
            let mut new_vehicle_risk = 0;
            let mut neww_risk = 0;
            let mut final_vehicle_risk = 0;

            // Using Category
            if (category > 140){
                new_vehicle_risk = category + 10;
            }
            else {
                 new_vehicle_risk = category - 5;
            }

            // Using Milage
            if(newPolicy.milage > 20000){
                neww_risk = new_vehicle_risk + 5;
            }
            else{
                neww_risk = new_vehicle_risk;
            }

            // Using Age

            if(newPolicy.vehicle_age > 20){
                vehicle_risk = neww_risk + 10;
            }
            else{
                vehicle_risk = neww_risk - 5;
            }

            // Finally adding Saftey Features

            final_vehicle_risk = vehicle_risk + newPolicy.safety_features;


            // drivers_risk_adjustment
            let mut drivers_risk_adjustment: i32 = 0;
            let mut new_driver_risk: i32 = 0;
            let mut driver_ris: i32 = 0;
            let mut driver_final: i32 = 0;

            //  Using Age
            if(newPolicy.driver_age < 25 || newPolicy.driver_age > 65){
                drivers_risk_adjustment = new_driver_risk + 20;
            }
            else{
                drivers_risk_adjustment = new_driver_risk - 10;
            }

            //  Using Accident
            driver_ris = drivers_risk_adjustment + (newPolicy.no_of_accidents.into() * 15);

            // Using violations
            driver_final =  driver_ris + (newPolicy.violations.into() * 10);
            
            ////////////////////////////////////////////////////////////////////////
            //                      CALCULATING PREMIUM
            /// //////////////////////////////////////////////////////////////////
            

            let premium3 = (100 + driver_final + final_vehicle_risk.into());

            let premium2 = (premium3 * newPolicy.value).try_into().unwrap() / 1000;

            let premium = (premium2 * newPolicy.coverage_type.into()) / 1000;

            newPolicy.premium = premium;
            
            self.policies.write(newPolicy.id, newPolicy);

            return premium * 100;           
        }

        // INITIATE POLICY

        // fn initiate_policy (ref self: ContractState, policy_id:u8) -> bool{
        //     let mut generated_policy = self.policies.read(policy_id);
        //     let active = generated_policy.policy_is_active;
        //     assert(!active, 'Policy is already active');

        //     /////////////////////////////////////////////////
        //     //  I NEED TO ACCEPT PAYMETS IN THIS FUNCTION  //
        //     ////////////////////////////////////////////////
            
        //    generated_policy.policy_is_active = true;
        //    generated_policy.voting_power = true;

        //    generated_policy.policy_creation_date = get_block_timestamp();
        //    generated_policy.policy_termination_date = get_block_timestamp() + 31536000; 
        //    generated_policy.policy_last_payment_date = get_block_timestamp();


        //     self.policies.write(generated_policy.id, generated_policy);
        //     true
        // }

        //get owner
        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }


        
        fn name(self: @ContractState) -> felt252 {
            self.name.read()
        }

        fn symbol(self: @ContractState) -> felt252 {
            self.symbol.read()
        }

        fn decimals(self: @ContractState) -> u8 {
            self.decimals.read()
        }

        fn totalSupply(self: @ContractState) -> u256 {
            self.totalSupply.read()
        }

        fn balanceOf(self: @ContractState, owner: ContractAddress) -> u256 {
            self.balances.read(owner)
        }

        fn allowance(
            self: @ContractState, owner: ContractAddress, spender: ContractAddress
        ) -> u256 {
            self.allowances.read((owner, spender))
        }

        fn transfer(ref self: ContractState, to: ContractAddress, value: u256) -> bool {
            let msg_sender = get_caller_address();
            self._transfer(msg_sender, to, value)
        }

        fn transferFrom(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, value: u256
        ) -> bool {
            let msg_sender = get_caller_address();
            let allowance = self.allowance(from, msg_sender);
            assert(allowance >= value, 'Insufficient allowance');
            self._transfer(from, to, value);
            self.allowances.write((from, msg_sender), allowance - value);
            true
        }

        fn approve(ref self: ContractState, spender: ContractAddress, value: u256) -> bool {
            let msg_sender = get_caller_address();
            self.allowances.write((msg_sender, spender), value);
            self.emit(Approval { owner: msg_sender, spender: spender, value: value, });
            true
        }

        // mint
        fn mint(ref self: ContractState, to: ContractAddress, value: u256) {
            let total_supply = self.totalSupply.read();
            self.totalSupply.write(total_supply + value);
            let balance = self.balances.read(to);
            self.balances.write(to, balance + value);
            self.emit(Mint { to: to, value: value, });
        }

        // burn
        fn burn(ref self: ContractState, from: ContractAddress, value: u256) {
            let balance = self.balances.read(from);
            assert(balance >= value, 'Insufficient balance');
            self.balances.write(from, balance - value);
            let total_supply = self.totalSupply.read();
            self.totalSupply.write(total_supply - value);
            self.emit(Burn { from: from, value: value, });
        }
                                                                       
    }

    
    impl ProcessingImpl of Processing {
        fn process(self: ClaimStatus) {
            match self {
                ClaimStatus::Claimed => { println!("quitting") },
                ClaimStatus::Processing => { println!("Processing") },
                ClaimStatus::Denied => { println!("Denied") },
            }
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn only_owner(self: @ContractState) {
            let caller = get_caller_address();
            assert(caller == self.owner.read(), 'Not the owner');
        }

        fn set_categories(ref self: ContractState){
            // self.only_owner();
            // Initializes safety feature adjustments.
            self.safetyFeatureAdjustments.write('sf1', -10);
            self.safetyFeatureAdjustments.write('sf2', -5);
            self.safetyFeatureAdjustments.write('sf3', -2);
            self.safetyFeatureAdjustments.write('sf4', -3);
            self.safetyFeatureAdjustments.write('all', -20);
            self.safetyFeatureAdjustments.write('three', -18);
    
            // // Initializes coverage type multipliers.
            self.coverageTypeMultipliers.write('comprehensive', 150);
            self.coverageTypeMultipliers.write('collision', 100);
            self.coverageTypeMultipliers.write('liability', 100);
            self.coverageTypeMultipliers.write('personalinjury', 120);
            
            // // Initializes vehicle category factors.
            self.vehicleCategories.write('economy', 100);
            self.vehicleCategories.write('mid_range', 120);
            self.vehicleCategories.write('suv', 130);
            self.vehicleCategories.write('commercial', 140);
            self.vehicleCategories.write('luxury', 150);
            self.vehicleCategories.write('sports', 200);
        
        }

        fn _transfer(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, value: u256
        ) -> bool {
            let address_zero: ContractAddress = contract_address_const::<0>();
            assert(from != address_zero, 'From address is zero');
            assert(to != address_zero, 'To address is zero');
            assert(value > 0, 'Value must be greater than zero');
            assert(self.balances.read(from) >= value, 'Insufficient balance');

            self.balances.write(from, self.balances.read(from) - value);
            self.balances.write(to, self.balances.read(to) + value);
            self.emit(Transfer { from, to, value });
            true
        }
    }
   
}


// Car 1 675
// Car 2 