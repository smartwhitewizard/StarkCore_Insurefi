#[starknet::contract]
pub mod Dao {
    use core::option::OptionTrait;
    use smart_contract::interfaces::i_dao::I_Dao;
    use smart_contract::constants::claim::Claim;
    use starknet::{ContractAddress, get_caller_address};
    use smart_contract::interfaces::i_automobile_insurance::{
        I_automobile_insuranceDispatcherTrait, I_automobile_insuranceDispatcher
    };

    #[storage]
    pub struct Storage {
        pub proposal_claims_count: u128,
        pub proposal_claims: LegacyMap<u128, super::Claim_Proposal>,
        pub owner: ContractAddress,
        pub has_voted_proposal: LegacyMap::<(u128, ContractAddress), bool>,
        pub automobile_insurance_address: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {}

    #[abi(embed_v0)]
    pub impl DaoImpl of I_Dao<ContractState> {
        fn view_claim(self: @ContractState, claim_id: u128) -> super::Claim_Proposal {
            self.proposal_claims.read(claim_id)
        }

        fn get_all_claims(self: @ContractState) -> Array::<super::Claim_Proposal> {
            let mut proposals_count: u128 = 1;
            let mut all_proposals: Array<super::Claim_Proposal> = ArrayTrait::<
                super::Claim_Proposal
            >::new();

            while proposals_count <= self
                .proposal_claims_count
                .read() {
                    all_proposals.append(self.proposal_claims.read(proposals_count));
                    proposals_count = proposals_count + 1;
                };

            return all_proposals;
        }

        fn vote_on_proposal_claim(
            ref self: ContractState,
            proposal_claim_id: u128,
            user_address: ContractAddress,
            decision: u8
        ) -> bool {
            let mut proposal = self.proposal_claims.read(proposal_claim_id);
            assert!(!proposal.is_done, "proposal already finalized");
            assert!(
                !self.has_voted_proposal.read((proposal_claim_id, user_address)),
                "user already voted"
            );

            self.has_voted_proposal.write((proposal_claim_id, user_address), true);

            let automobile_dispatcher = I_automobile_insuranceDispatcher {
                contract_address: self.automobile_insurance_address.read()
            };

            let number_of_user_insured_vehicle = automobile_dispatcher
                .get_number_of_user_vehicle_insured(user_address);

            assert!(number_of_user_insured_vehicle > 0, "user has no vehicle insured");
            proposal.vote_count += number_of_user_insured_vehicle;
            self.has_voted_proposal.write((proposal_claim_id, user_address), true);

            if decision == 1 {
                proposal.for_claim += number_of_user_insured_vehicle;
            } else if decision == 2 {
                proposal.against_claim += number_of_user_insured_vehicle;
            } else if decision == 3 {
                proposal.abstain_count += number_of_user_insured_vehicle;
            } else {
                assert!(false, "invalid decision");
            }
            self.proposal_claims.write(proposal_claim_id, proposal);
            true
        }

        fn create_proposal(
            ref self: ContractState,
            claim_amount: u256,
            user_address: ContractAddress,
            image: ByteArray,
            claim_id: u128
        ) -> bool {
            let proposal: super::Claim_Proposal = super::Claim_Proposal {
                id: self.proposal_claims_count.read() + 1,
                proposal_creator: user_address,
                claim_amount: claim_amount,
                for_claim: 0,
                against_claim: 0,
                abstain_count: 0,
                vote_count: 0,
                accident_image: image,
                is_done: false,
                claim_id: claim_id,
            };

            self.proposal_claims_count.write(self.proposal_claims_count.read() + 1);
            self.proposal_claims.write(proposal.id, proposal);
            true
        }

        fn finalize_proposal(ref self: ContractState, proposal_claim_id: u128) -> bool {
            let mut proposal = self.proposal_claims.read(proposal_claim_id);
            assert!(!proposal.is_done, "proposal already finalized");
            assert!(
                proposal.proposal_creator == get_caller_address(),
                "only proposal creator can finalize proposal"
            );

            let number_of_policies = I_automobile_insuranceDispatcher {
                contract_address: self.automobile_insurance_address.read()
            }
                .get_policies_count();

            let average = (number_of_policies / proposal.vote_count) * 100;

            if average >= 70 {
                I_automobile_insuranceDispatcher {
                    contract_address: self.automobile_insurance_address.read()
                }
                    .finalize_and_execute_claim(proposal.claim_id);
                proposal.is_done = true;
            }

            self.proposal_claims.write(proposal_claim_id, proposal);
            true
        }

        fn set_automobile_insurance_address(
            ref self: ContractState, automobile_insurance_address: ContractAddress
        ) -> bool {
            assert!(
                self.only_owner() == get_caller_address(),
                "only governance allowed to perform action"
            );
            self.automobile_insurance_address.write(automobile_insurance_address);
            true
        }

        fn get_user_claims(
            self: @ContractState, user_address: ContractAddress
        ) -> Array::<super::Claim_Proposal> {
            let mut user_proposals_claim: Array<super::Claim_Proposal> = ArrayTrait::<
                super::Claim_Proposal
            >::new();

            let mut user_proposal_counter: u128 = 1;

            while user_proposal_counter <= self
                .proposal_claims_count
                .read() {
                    let claim = self.proposal_claims.read(user_proposal_counter);
                    if claim.proposal_creator == user_address {
                        user_proposals_claim.append(claim);
                    }
                    user_proposal_counter = user_proposal_counter + 1;
                };
            user_proposals_claim
        }
    }

    #[generate_trait]
    impl Dao_aux of Dao_aux_trait {
        fn only_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }
    }
}

use starknet::ContractAddress;

#[derive(Drop, Serde, starknet::Store)]
pub struct Claim_Proposal {
    pub id: u128,
    pub proposal_creator: ContractAddress,
    pub claim_amount: u256,
    pub for_claim: u128,
    pub against_claim: u128,
    pub abstain_count: u128,
    pub vote_count: u128,
    pub accident_image: ByteArray,
    pub is_done: bool,
    pub claim_id: u128,
}
