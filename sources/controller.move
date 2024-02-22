
module movamber::controller {
    use std::signer;
    use movamber::implements::controller;

    struct Emergency has key {}

    const ERR_NO_PERMISSIONS: u64 = 200;
    const ERR_ALREADY_PAUSE: u64 = 201;
    const ERR_NOT_PAUSE: u64 = 202;

    public entry fun pause(
        account: &signer
    ) {
        let controller = controller();

        assert!(!exists<Emergency>(controller), ERR_ALREADY_PAUSE);
        assert!(controller == signer::address_of(account), ERR_NO_PERMISSIONS);

        move_to(account, Emergency {});
    }

    public entry fun resume(
        account: &signer
    ) acquires Emergency {
        let controller = controller();

        assert!(exists<Emergency>(controller), ERR_NOT_PAUSE);
        assert!(controller == signer::address_of(account), ERR_NO_PERMISSIONS);

        let Emergency {} = move_from<Emergency>(signer::address_of(account));
    }

    public fun is_emergency(): bool {
        exists<Emergency>(controller())
    }
}
