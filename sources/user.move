module tsmp::user {
    use std::string::String;

    public struct UserProfile has key, store {
        id: UID,
        address: address,
        nickname: String
    }

    public entry fun create_user_profile(
        nickname: String,
        ctx: &mut TxContext
    ) {
        let user = UserProfile {
            id: object::new(ctx),
            address: tx_context::sender(ctx),
            nickname,
        };
        transfer::transfer(user, tx_context::sender(ctx));
    }

    public entry fun update_nickname(
        user: &mut UserProfile,
        new_nickname: String,
        ctx: &mut TxContext
    ) {
        assert!(user.address == tx_context::sender(ctx), 0);
        user.nickname = new_nickname;
    }
}