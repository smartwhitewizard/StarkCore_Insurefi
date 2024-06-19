use starknet::ContractAddress;
use smart_contract::interfaces::i_automobile_insurance::I_automobile_insurance;

#[starknet::contract]
pub mod Automobile_calculator {
    use smart_contract::interfaces::i_automobile_insurance::I_automobile_insurance;
    use core::clone::Clone;
    use core::option::OptionTrait;
    use core::traits::Into;
    use core::starknet::event::EventEmitter;
    use super::ContractAddress;
    use starknet::{
        get_block_timestamp, contract_address_const, get_caller_address, get_contract_address
    };

    use smart_contract::events::{
        policy_initiated::Policy_initiated, policy_renewal_event::Policy_renewed
    };

    use smart_contract::constants::{
        vehicle_request::Vehicle_Request, claim_status::ClaimStatus, vehicle::{Vehicle, Vehicle_Policy},
        claim::Claim
    };

    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::token::erc20::ERC20Component;
    // use openzeppelin::token::erc20::ERC20HooksEmptyImpl;
    use openzeppelin::upgrades::UpgradeableComponent;
    use openzeppelin::upgrades::interface::IUpgradeable;
    use starknet::ClassHash;


    component!(path: ERC20Component, storage: erc20, event: ERC20Event);
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: UpgradeableComponent, storage: upgradeable, event: UpgradeableEvent);

    #[abi(embed_v0)]
    impl ERC20MixinImpl = ERC20Component::ERC20MixinImpl<ContractState>;
    #[abi(embed_v0)]
    impl OwnableMixinImpl = OwnableComponent::OwnableMixinImpl<ContractState>;

    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;
    impl UpgradeableInternalImpl = UpgradeableComponent::InternalImpl<ContractState>;


    #[storage]
    struct Storage {
        policies: LegacyMap<u8, Vehicle>,
        claims: LegacyMap<u8, Claim>,
        voters_count: u16,
        policiy_holder: LegacyMap<ContractAddress, Vehicle>,
        // policiy_holder: LegacyMap<u8, ContractAddress>,
        policy_id_counter: u8,
        claimid: u8,
        owner: ContractAddress,
        safetyFeatureAdjustments: LegacyMap<felt252, i16>,
        coverageTypeMultipliers: LegacyMap<felt252, u16>,
        vehicleCategories: LegacyMap<felt252, i16>,
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        upgradeable: UpgradeableComponent::Storage,
    }

    #[derive(Drop, Serde, starknet::Store)]
    pub trait Processing {
        fn process(self: ClaimStatus);
    }
    // Events
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event,
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        #[flat]
        UpgradeableEvent: UpgradeableComponent::Event,
        Policy_initiated: Policy_initiated,
        Policy_renewed: Policy_renewed,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.owner.write(owner);
        self.set_categories();
        self.erc20.initializer("InsureFiToken", "IFI");
        self.ownable.initializer(owner);
    }

    #[abi(embed_v0)]
    impl Automobile_insuranceImpl of super::I_automobile_insurance<ContractState> {
        // register vehicle
        fn register_vehicle(ref self: ContractState, vehicle_request: Vehicle_Request) -> bool {
            let id = self.policy_id_counter.read() + 1;
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
                vehicle_policy: Vehicle_Policy {
                    policy_creation_date: 0,
                    policy_termination_date: 0,
                    policy_last_payment_date: 0,
                    policy_is_active: false,
                    policy_holder: vehicle_request.driver,
                },
                claim_status: false,
                img_url: 'Blank',
                voting_power: false
            };

            self.policies.write(id, vehicle_data);
            self.policy_id_counter.write(id);
            self.emit(Policy_initiated { policy_id: id, policy_holder: vehicle_request.driver });

            true
        }

        fn get_specific_vehicle(self: @ContractState, id: u8) -> Vehicle {
            self.policies.read(id)
        }

        fn get_specific_vehiclea(self: @ContractState, id: u8) -> u8 {
            self.get_specific_vehicle(id).id
        }

        fn get_specific_driver(self: @ContractState, id: u8) -> ContractAddress {
            self.get_specific_vehicle(id).driver
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

            // let premium3 = (100 + driver_final + final_vehicle_risk.into());

            // let premium2 = (premium3 * newPolicy.value).try_into().unwrap() / 1000;

            // let premium = (premium2 * newPolicy.coverage_type.into()) / 1000;

            let premium = PrivateTrait::calculate_premium(
                driver_final, final_vehicle_risk, newPolicy.value, newPolicy.coverage_type
            );

            newPolicy.premium = premium;

            self.policies.write(newPolicy.id, newPolicy);

            return premium * 100;
        }

        // INITIATE POLICY

        fn initiate_policy(ref self: ContractState, policy_id: u8) -> bool {
            let mut generated_vehicle_policy = self.policies.read(policy_id);
            let active = generated_vehicle_policy.vehicle_policy.policy_is_active;
            assert(!active, 'Policy is already active');

            let balance = self.erc20.balanceOf(generated_vehicle_policy.driver);

            let contract_Address = get_contract_address();
            assert(balance >= generated_vehicle_policy.premium.into(), 'Insufficient balance');
            self.erc20.transfer(contract_Address, generated_vehicle_policy.premium.into());

            generated_vehicle_policy.vehicle_policy.policy_is_active = true;
            generated_vehicle_policy.voting_power = true;

            let voting = self.voters_count.read() + 1;
            self.voters_count.write(voting);

            generated_vehicle_policy.vehicle_policy.policy_creation_date = get_block_timestamp();
            generated_vehicle_policy.vehicle_policy.policy_termination_date = get_block_timestamp()
                + 60;
            generated_vehicle_policy
                .vehicle_policy
                .policy_last_payment_date = get_block_timestamp();

            self.policies.write(generated_vehicle_policy.id, generated_vehicle_policy);
            self.policiy_holder.write(generated_vehicle_policy.driver, generated_vehicle_policy);
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
            generated_vehicle_policy.vehicle_policy.policy_is_active = false;
            // let bal = self.balanceOf(generated_vehicle_policy.driver);

            // assert(bal >= claim_amount.into(), 'Insufficient balance');

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
            let bal = self.erc20.balanceOf(generated_vehicle_policy.driver);
            let contract_Address = get_contract_address();

            if bal >= generated_vehicle_policy.premium.into() {
                let has_transferred: bool = self
                    .erc20
                    .transfer(contract_Address, generated_vehicle_policy.premium.into());

                assert(has_transferred, 'Failed to transfer premium');

                generated_vehicle_policy.vehicle_policy.policy_is_active = true;
                generated_vehicle_policy.voting_power = true;

                let voting = self.voters_count.read() + 1;
                self.voters_count.write(voting);

                generated_vehicle_policy
                    .vehicle_policy
                    .policy_creation_date = get_block_timestamp();
                generated_vehicle_policy
                    .vehicle_policy
                    .policy_termination_date = get_block_timestamp()
                    + 60;
                generated_vehicle_policy
                    .vehicle_policy
                    .policy_last_payment_date = get_block_timestamp();

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
                generated_vehicle_policy.vehicle_policy.policy_is_active = false;
                return false;
            }
        }


        fn mint(ref self: ContractState, recipient: ContractAddress, amount: u256) {
            self.ownable.assert_only_owner();
            self.erc20._mint(recipient, amount);
        }
        fn burn(ref self: ContractState, recipient: ContractAddress, amount: u256) {
            self.erc20._burn(recipient, amount);
        }

        //get owner
        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }

        fn vote_on_claim(ref self: ContractState, id: u8, ClaimStatus: ClaimStatus) -> bool {
            let vot = get_caller_address();

            let mut voter = self.policiy_holder.read(vot);
            assert(voter.voting_power, 'Not Eligible to Vote');
            let mut claim = self.claims.read(id);
            claim.claim_vote + 1;

            voter.voting_power = false;

            self.policiy_holder.write(vot, voter);
            self.policies.write(voter.id, voter);

            true
        }

        fn view_claim(self: @ContractState, id: u8) -> Claim {
            self.claims.read(id)
        }

        fn claim_status(ref self: ContractState, id: u8) -> felt252 {
            let mut claim = self.claims.read(id);
            let claim_count = claim.claim_vote;
            let total_voters = self.voters_count.read();
            let mut m: felt252 = 'Processing';
            let claim_status = claim.claim_status;

            let msg: ClaimStatus = ClaimStatus::Denied;
            let message = claim_status.process() == msg.process();

            assert(!message, 'Claim have already been Denied');

            let average = (claim_count / total_voters.into()) * 100;

            if (average >= 70) {
                claim.claim_status = ClaimStatus::Approved;
                m = 'Approved';
            } else {
                claim.claim_status = ClaimStatus::Processing;
            }

            m
        }
    }


    impl ProcessingImpl of Processing {
        fn process(self: ClaimStatus) {
            match self {
                ClaimStatus::Processing => { println!("Processing") },
                ClaimStatus::Approved => { println!("quitting") },
                ClaimStatus::Denied => { println!("Denied") },
                ClaimStatus::Claimed => { println!("Claimed") },
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
            let expirydate = generated_vehicle_policy.vehicle_policy.policy_termination_date;
            let now = get_block_timestamp();
            now > expirydate
        }

        fn calculate_premium(
            driver_final: i32, final_vehicle_risk: i16, policy_value: i32, policy_coverage_type: u16
        ) -> u32 {
            let premium3 = (100 + driver_final + final_vehicle_risk.into());

            let premium2 = (premium3 * policy_value).try_into().unwrap() / 1000;

            (premium2 * policy_coverage_type.into()) / 1000
        }
    }

    #[abi(embed_v0)]
    impl UpgradeableImpl of IUpgradeable<ContractState> {
        fn upgrade(ref self: ContractState, new_class_hash: ClassHash) {
            self.ownable.assert_only_owner();
            self.upgradeable._upgrade(new_class_hash);
        }
    }
}

