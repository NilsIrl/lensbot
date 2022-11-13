// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "./dilemma.sol";

contract AlwaysCooperate is Bot {
    constructor(uint256 owner_profile, string memory name) Bot (owner_profile, name) {}
    
    function play(
        address,
        bool[] calldata,
        bool[] calldata) external pure override returns (bool) {
        return false;
    }
}


contract AlwaysDefect is Bot {
    constructor(uint256 owner_profile, string memory name) Bot (owner_profile, name) {}

    function play(
        address,
        bool[] calldata,
        bool[] calldata) external pure override returns (bool) {
            return true;
    }
}

contract Toggle is Bot {
    constructor(uint256 owner_profile, string memory name) Bot (owner_profile, name) {}

    function play(
        address,
        bool[] calldata,
        bool[] calldata bot_previous_plays) external pure override returns (bool) {
            return bot_previous_plays.length % 2 == 0;
    }
}

contract TitForTat is Bot {
    constructor(uint256 owner_profile, string memory name) Bot (owner_profile, name) {}

    function play(
        address,
        bool[] calldata opponent_previous_plays,
        bool[] calldata) external pure override returns (bool) {
            if (opponent_previous_plays.length == 0) {
                return true;
            }
            return opponent_previous_plays[opponent_previous_plays.length - 1];
    }
}

contract Advanced is Bot {
    constructor(uint256 owner_profile, string memory name) Bot (owner_profile, name) {}

    // true is defect
    // false is cooperate
    function play(
        address opponent,
        bool[] calldata opponent_previous_plays,
        bool[] calldata bot_previous_plays
    ) external override virtual returns (bool) {
        bool[] memory my_plays_minus1 = new bool[](opponent_previous_plays.length - 1);
        bool[] memory their_plays_minus1 = new bool[](opponent_previous_plays.length - 1);
        for (uint256 i = 0; i < opponent_previous_plays.length - 1; i += 1) {
            my_plays_minus1[i] = bot_previous_plays[i];
            their_plays_minus1[i] = opponent_previous_plays[i];
        }
        return Bot(opponent).play(address(this), my_plays_minus1, their_plays_minus1);
    }
}