use starknet::ContractAddress;
use smart_contract::interfaces::i_automobile_insurance::I_automobile_insurance;
use smart_contract::events::policy_initiated::Policy_initiated;

#[derive(Drop, Copy, Serde)]
pub struct Vehicle_Request{
    pub driver: ContractAddress,
    pub driver_age: u8,
    pub no_of_accidents: u8,
    pub violations: u8,
    pub vehicle_category: felt252,
    pub vehicle_age: u8,
    pub mileage: u32,
    pub safety_features: felt252,
    pub coverage_type: felt252,
    pub value: i32
}

#[starknet::contract]
pub mod Automobile_calculator {
    use core::clone::Clone;
    // use smart_contract::automobile_policy::Iautomobile_insurance;
    use core::option::OptionTrait;
    use core::traits::Into;
    use core::starknet::event::EventEmitter;
    use super::ContractAddress;
    use starknet::{
        get_block_timestamp, contract_address_const, get_caller_address, get_contract_address
    };
    use super::Vehicle_Request;

    #[storage]
    struct Storage {
        policies: LegacyMap<u8, Vehicle>,
        claims: LegacyMap<u8, Claim>,
        voters_count: u16,
        vehicle_owner: LegacyMap<ContractAddress, Vehicle>,
        policiy_holder: LegacyMap<u8, ContractAddress>,
        policy_id_counter: u8,
        claimid: u8,
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

    #[derive(Drop, Serde, starknet::Store)]
    pub enum ClaimStatus {
        Claimed,
        Processing,
        Denied,
    }

    #[derive(Drop, Copy, Serde, Clone, starknet::Store)]
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
        policy_is_active: bool,
        policy_holder: ContractAddress,
        claim_status: bool,
        img_url: felt252,
        voting_power: bool
    }
    #[derive(Drop, Serde, starknet::Store)]
    pub struct Claim {
        id: u8,
        policy_holder: ContractAddress,
        claim_amount: u256,
        claim_details: ByteArray,
        claim_status: ClaimStatus,
        accident_image: ByteArray,
        claim_vote: u32
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
        Policy_initiated: super::Policy_initiated,
        Policy_renewed: Policy_renewed,
        TransferFrom: TransferFrom,
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        #[key]
        from: ContractAddress,
        #[key]
        to: ContractAddress,
        value: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct TransferFrom {
        #[key]
        from: ContractAddress,
        #[key]
        initiator: ContractAddress,
        #[key]
        to: ContractAddress,
        value: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct Approval {
        #[key]
        owner: ContractAddress,
        #[key]
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

    // #[derive(Drop, starknet::Event)]
    // struct Policy_initiated {
    //     #[key]
    //     policy_id: u8,
    //     #[key]
    //     policy_holder: ContractAddress,
    // }

    #[derive(Drop, starknet::Event)]
    struct Policy_renewed {
        #[key]
        policy_id: u128,
        #[key]
        policy_holder: ContractAddress,
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
    impl Automobile_insuranceImpl of super::I_automobile_insurance<ContractState> {
        // register vehicle
        fn register_vehicle(
            ref self: ContractState, vehicle_request: Vehicle_Request
        ) -> bool {
            let id = self.policy_id_counter.read() + 1;
            //driver: ContractAddress, driver_age: u8, no_of_accidents:u8, violations: u8, vehicle_category: felt252, vehicle_age: u8, mileage: u32, safety_features: felt252, coverage_type: felt252, value: i32) 
            
            let vc = self.vehicleCategories.read(vehicle_request.vehicle_category);
            let sf = self.safetyFeatureAdjustments.read(vehicle_request.safety_features);
            let cv = self.coverageTypeMultipliers.read(vehicle_request.coverage_type);

            let vehicle_data: Vehicle = Vehicle {
                id: id,
                driver: vehicle_request.driver,
                driver_age: vehicle_request.driver_age,
                no_of_accidents: vehicle_request.no_of_accidents,
                violations: vehicle_request.violations,
                vehicle_age: vehicle_request.vehicle_age,
                milage: vehicle_request.mileage,
                vehicle_Category: vc,
                safety_features: sf,
                coverage_type: cv,
                value: vehicle_request.value,
                insured: false,
                premium: 0,
                policy_creation_date: 0,
                policy_termination_date: 0,
                policy_last_payment_date: 0,
                policy_is_active: false,
                policy_holder: vehicle_request.driver,
                claim_status: false,
                img_url: 'Blank',
                voting_power: false
            };

            self.policies.write(id, vehicle_data);
            self.policy_id_counter.write(id);
            self.emit(super::Policy_initiated { policy_id: id, policy_holder: vehicle_request.driver });

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

        fn get_specific_driver(self: @ContractState, id: u8) -> ContractAddress {
            let vehicle = self.policies.read(id);
            vehicle.driver
        }

        fn generate_premium(ref self: ContractState, policy_id: u8) -> u32 {
            let mut newPolicy = self.policies.read(policy_id);

            let category = newPolicy.vehicle_Category;

            let mut vehicle_risk = 0;
            let mut new_vehicle_risk = 0;
            let mut neww_risk = 0;
            let mut final_vehicle_risk = 0;

            // Using Category
            if (category > 140) {
                new_vehicle_risk = category + 10;
            } else {
                new_vehicle_risk = category - 5;
            }

            // Using Milage
            if (newPolicy.milage > 20000) {
                neww_risk = new_vehicle_risk + 5;
            } else {
                neww_risk = new_vehicle_risk;
            }

            // Using Age

            if (newPolicy.vehicle_age > 20) {
                vehicle_risk = neww_risk + 10;
            } else {
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
            if (newPolicy.driver_age < 25 || newPolicy.driver_age > 65) {
                drivers_risk_adjustment = new_driver_risk + 20;
            } else {
                drivers_risk_adjustment = new_driver_risk - 10;
            }

            //  Using Accident
            driver_ris = drivers_risk_adjustment + (newPolicy.no_of_accidents.into() * 15);

            // Using violations
            driver_final = driver_ris + (newPolicy.violations.into() * 10);

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

        fn initiate_policy(ref self: ContractState, policy_id: u8) -> bool {
            let mut generated_vehicle_policy = self.policies.read(policy_id);
            let active = generated_vehicle_policy.policy_is_active;
            assert(!active, 'Policy is already active');
            let bal = self.balanceOf(generated_vehicle_policy.driver);
            let contract_Address = get_contract_address();
            assert(bal >= generated_vehicle_policy.premium.into(), 'Insufficient balance');
            self.transfer(contract_Address, generated_vehicle_policy.premium.into());

            generated_vehicle_policy.policy_is_active = true;
            generated_vehicle_policy.voting_power = true;

            let voting = self.voters_count.read() + 1;
            self.voters_count.write(voting);

            generated_vehicle_policy.policy_creation_date = get_block_timestamp();
            generated_vehicle_policy.policy_termination_date = get_block_timestamp() + 60;
            generated_vehicle_policy.policy_last_payment_date = get_block_timestamp();

            self.policies.write(generated_vehicle_policy.id, generated_vehicle_policy);

            self
                .emit(
                    Policy_renewed {
                        policy_id: generated_vehicle_policy.id.into(),
                        policy_holder: generated_vehicle_policy.driver
                    }
                );
            true
        }


        fn file_claim(
            ref self: ContractState,
            id: u8,
            claim_amount: u256,
            claim_details: ByteArray,
            image: ByteArray
        ) -> bool {
            // self.is_expired(id);

            let active = self.is_expired(id);
            assert(active, 'Policy is not active');
            let mut generated_vehicle_policy = self.policies.read(id);
            generated_vehicle_policy.policy_is_active = false;
            let bal = self.balanceOf(generated_vehicle_policy.driver);

            assert(bal >= claim_amount.into(), 'Insufficient balance');

            let claim_id = self.claimid.read();

            let claim: Claim = Claim {
                id: claim_id,
                policy_holder: generated_vehicle_policy.driver,
                claim_amount: claim_amount,
                claim_details: claim_details,
                claim_status: ClaimStatus::Processing,
                accident_image: image,
                claim_vote: 1
            };
            self.claims.write(claim_id, claim);
            self.claimid.write(claim_id + 1);

            true
        }

        // RENEW POLICY
        fn renew_policy(ref self: ContractState, policy_id: u8) -> bool {
            let is_expired: bool = self.is_expired(policy_id);

            assert(is_expired, 'Policy is yet to expire');

            let mut generated_vehicle_policy = self.policies.read(policy_id);
            let bal = self.balanceOf(generated_vehicle_policy.driver);
            let contract_Address = get_contract_address();

            if bal >= generated_vehicle_policy.premium.into() {
                let has_transferred: bool = self
                    .transfer(contract_Address, generated_vehicle_policy.premium.into());

                assert(has_transferred, 'Failed to transfer premium');

                generated_vehicle_policy.policy_is_active = true;
                generated_vehicle_policy.voting_power = true;

                let voting = self.voters_count.read() + 1;
                self.voters_count.write(voting);

                generated_vehicle_policy.policy_creation_date = get_block_timestamp();
                generated_vehicle_policy.policy_termination_date = get_block_timestamp() + 60;
                generated_vehicle_policy.policy_last_payment_date = get_block_timestamp();

                self.policies.write(generated_vehicle_policy.id, generated_vehicle_policy);

                self
                    .emit(
                        Policy_renewed {
                            policy_id: generated_vehicle_policy.id.into(),
                            policy_holder: generated_vehicle_policy.driver
                        }
                    );
                return true;
            } else {
                println!("Insufficient balance");
                generated_vehicle_policy.policy_is_active = false;
                return false;
            }
        }
        //get owner
        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }


        ///////////////////////////////////
        /// THE CONTRACT IS ALSO ERC20 ///
        /// /////////////////////////////

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
            self._transfer(msg_sender, to, value);
            self.emit(Transfer { from: msg_sender, to: to, value: value });
            true
        }

        fn transferFrom(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, value: u256
        ) -> bool {
            let msg_sender = get_caller_address();
            let allowance = self.allowance(from, msg_sender);
            assert(allowance >= value, 'Insufficient allowance');
            self._transfer(from, to, value);
            self.allowances.write((from, msg_sender), allowance - value);
            self.emit(TransferFrom { from: from, initiator: msg_sender, to: to, value: value });
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

        fn set_categories(ref self: ContractState) {
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

        fn is_expired(ref self: ContractState, id: u8) -> bool {
            let mut generated_vehicle_policy = self.policies.read(id);
            let expirydate = generated_vehicle_policy.policy_termination_date;
            let now = get_block_timestamp();
            now > expirydate
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

