module tsmp::system {
    use sui::transfer;
    use sui::tx_context::TxContext;

    public struct SystemState has key {
        id: UID,
        total_posts: u64,
    }

    fun init(ctx: &mut TxContext) {
        let system_state = SystemState {
            id: object::new(ctx),
            total_posts: 0,
        };
        transfer::share_object(system_state);
    }

    public entry fun increment_total_posts(state: &mut SystemState) {
        state.total_posts = state.total_posts + 1;
    }

    public fun total_posts(state: &SystemState): u64 {
        state.total_posts
    }

    #[test_only]
    public fun init_for_test(ctx: &mut TxContext): SystemState {
        SystemState {
            id: object::new(ctx),
            total_posts: 0,
        }
    }

    #[test_only]
    public fun share_system_state_for_test(state: SystemState) {
        transfer::share_object(state);
    }
}