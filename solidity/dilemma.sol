// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "./code.sol";

contract Dilemma is Challenge {
    mapping (address => int256) public scores;
    mapping (address => mapping (address => bool[])) public plays;
    address[] bots;
    LensBot lensbot;
    uint256 roundLength;

    constructor(
        address lensbot_addr,
        uint256 owner_profile,
        string memory name_local,
        uint256 _roundLength) Challenge(lensbot_addr, owner_profile, name_local) {

            roundLength = _roundLength;

    } 

    function register() override public {
        Bot botb = Bot(msg.sender);

        for (uint256 i = 0; i < bots.length; ++i) {
            Bot bota = Bot(bots[i]);

            for (uint256 turn = 0; turn < roundLength; ++turn) {
                bool bota_play = bota.play(
                    msg.sender,
                    plays[msg.sender][address(bota)],
                    plays[address(bota)][msg.sender]
                );
                bool botb_play = botb.play(
                    address(bota),
                    plays[address(bota)][msg.sender],
                    plays[msg.sender][address(bota)]
                );

                plays[address(bota)][msg.sender].push(bota_play);
                plays[msg.sender][address(bota)].push(botb_play);

                // CC -1 -1 
                // CD -3  0
                // DD -2 -2
                // both defect
                if (bota_play && botb_play) {
                    scores[address(bota)] -= 2;
                    scores[address(botb)] -= 2;
                // bota defect
                // botb cooperate
                } else if (bota_play && (!botb_play)) {
                    scores[address(botb)] -= 3;
                // bota cooperate
                // botb defect
                } else if ((!bota_play) && botb_play) {
                    scores[address(bota)] -= 3;
                // both cooperate
                } else {
                    scores[address(bota)] -= 1;
                    scores[address(botb)] -= 1;
                }
            }
        }

        bots.push(address(botb));
    }

    function getLeaderboardAt(uint256 i) view external override returns (address) {
        return bots[i];
    }

    function getPoints(address bot) view external override returns (int256) {
        return scores[bot];
    }

    function getBotCount() view external override returns (uint256) {
        return bots.length;
    }

    function getRoundLength() view external returns (uint256) {
        return roundLength;
    }
}


abstract contract Bot {
    uint256 private ownerprofile;
    string private name;

    constructor(uint256 owner_profile, string memory name_local) {
        ownerprofile = owner_profile;
        name = name_local;
    }

    function register_on(address challenge_address) external {
        Challenge c = Challenge(challenge_address);
        c.register();
    }

    // keep casing like that
    function getOwnerprofile() view external returns (uint256) {
        return ownerprofile;
    }

    function getName() view external returns (string memory) {
        return name;
    }

    // true is defect
    // false is cooperate
    function play(
        address opponent,
        bool[] calldata opponent_previous_plays,
        bool[] calldata bot_previous_plays
    ) external virtual returns (bool);
}
