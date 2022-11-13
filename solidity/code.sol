// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

contract LensBot {
    address[] public challenges;

    function register() public {
        challenges.push(msg.sender);
    }

    function getChallengesCount() view public returns (uint256) {
        return challenges.length;
    }
}

abstract contract Challenge {
    uint256 private ownerprofile;
    string private name;

    constructor(address lensbot_addr, uint256 owner_profile, string memory name_local) {
        LensBot(lensbot_addr).register();
        ownerprofile = owner_profile;
        name = name_local;
    }

    function getOwnerprofile() view external returns (uint256) {
        return ownerprofile;
    }

    function getName() view external returns (string memory) {
        return name;
    }

    function getBotCount() view virtual external returns (uint256);
    function getLeaderboardAt(uint256) view virtual external returns (address);
    function getPoints(address) view virtual external returns (int256);
    function register() virtual external;
}