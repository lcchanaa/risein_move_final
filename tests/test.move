#[test_only]
module tsmp::test {
    use sui::test_scenario;
    use tsmp::system::{Self, SystemState};

    #[test]
    fun test_system_state_initialization() {
        let mut scenario_val = test_scenario::begin(@0x1);
        let mut scenario = &mut scenario_val;

        // Initialize system state
        test_scenario::next_tx(scenario, @0x1);
        {
            let ctx = test_scenario::ctx(scenario);
            let system_state = system::init_for_test(ctx);
            system::share_system_state_for_test(system_state);
        };

        // Try to take the shared SystemState in a new transaction
        test_scenario::next_tx(scenario, @0x1);
        {
            let system_state = test_scenario::take_shared<SystemState>(scenario);
            assert!(system::total_posts(&system_state) == 0, 0);
            test_scenario::return_shared(system_state);
        };

        test_scenario::end(scenario_val);
    }
}