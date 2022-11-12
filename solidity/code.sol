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

interface Challenge {
    function getOwnerprofile() view external returns (uint256);
    function getBotCount() view external returns (uint256);
    function getLeaderboardAt(uint256) view external returns (address);
    function getPoints(address) view external returns (int256);
    function register() external;
}

