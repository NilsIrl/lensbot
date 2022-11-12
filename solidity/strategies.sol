pragma solidity ^0.8.17;

import "./dilemma.sol";

contract AlwaysCooperate is Bot {
    constructor(uint256 owner_profile) Bot (owner_profile) {}
    
    function play(address opponent, bool[] calldata previous_plays, uint256 turn_count) external override returns (bool) {
        return false;
    }
}


contract AlwaysDefect is Bot {
    constructor(uint256 owner_profile) Bot (owner_profile) {}

    function play(address opponent, bool[] calldata previous_plays, uint256 turn_count) external override returns (bool) {
        return true;
    }
}