pragma solidity ^0.8.17;

import "./dilemma.sol";

contract AlwaysCooperate is Bot {
    constructor(uint256 owner_profile) Bot (owner_profile) {}
    
    function play(
    address opponent,
    bool[] calldata opponent_previous_plays,
    bool[] calldata bot_previous_plays) external override returns (bool) {
        return false;
    }
}


contract AlwaysDefect is Bot {
    constructor(uint256 owner_profile) Bot (owner_profile) {}

    function play(
        address opponent,
        bool[] calldata opponent_previous_plays,
        bool[] calldata bot_previous_plays) external override returns (bool) {
            return true;
    }
}

contract Toggle is Bot {
    constructor(uint256 owner_profile) Bot (owner_profile) {}

    function play(
        address opponent,
        bool[] calldata opponent_previous_plays,
        bool[] calldata bot_previous_plays) external override returns (bool) {
            return bot_previous_plays.length % 2 == 0;
    }
}

contract TitForTat is Bot {
    constructor(uint256 owner_profile) Bot (owner_profile) {}

    function play(
        address opponent,
        bool[] calldata opponent_previous_plays,
        bool[] calldata bot_previous_plays) external override returns (bool) {
            if (opponent_previous_plays.length == 0) {
                return true;
            }
            return opponent_previous_plays[opponent_previous_plays.length - 1];
    }
}