
contract AlwaysCooperate is Bot {
    uint256 ownerprofile;

    constructor(uint256 owner_profile) {
        ownerprofile = owner_profile;
    }

    function register_on(address challenge_address) external {
        Challenge c = Challenge(challenge_address);
        c.register();
    }

    function play(address opponent, bool[] calldata previous_plays, uint256 turn_count) external returns (bool) {
        return false;
    }

    function getOwnerprofile() view external returns (uint256) {
        return ownerprofile;
    }
}

contract AlwaysDefect is Bot {
    uint256 ownerprofile;

    constructor(uint256 owner_profile) {
        ownerprofile = owner_profile;
    }

    function register_on(address challenge_address) external {
        Challenge c = Challenge(challenge_address);
        c.register();
    }

    function play(address opponent, bool[] calldata previous_plays, uint256 turn_count) external returns (bool) {
        return true;
    }

    function getOwnerprofile() view external returns (uint256) {
        return ownerprofile;
    }
}
