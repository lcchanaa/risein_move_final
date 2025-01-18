module tsmp::content {
    use sui::event;
    use std::string::String;
    use tsmp::system::{Self, SystemState};

    public struct PostCreated has copy, drop {
        author: address,
        content: String,
        timestamp: u64,
    }

    public struct Post has key, store {
        id: UID,
        author: address,
        content: String,
        timestamp: u64,
    }

    public fun get_author(post: &Post): address {
        post.author
    }

    public fun get_content(post: &Post): String {
        post.content
    }

    public entry fun create_post(
        content: String,
        timestamp: u64,
        system_state: &mut SystemState,
        ctx: &mut TxContext
    ) {
        let post = Post {
            id: object::new(ctx),
            author: tx_context::sender(ctx),
            content,
            timestamp,
        };
        event::emit(PostCreated {
            author: post.author,
            content: post.content,
            timestamp: post.timestamp,
        });
        system::increment_total_posts(system_state);
        transfer::share_object(post);
    }
}