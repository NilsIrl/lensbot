import { EditorView, basicSetup } from "codemirror";
import { solidity } from '@replit/codemirror-lang-solidity';
import { ethers } from "ethers";
import { lensbotABI } from "./abi.js";
import { solidityCompiler } from '@agnostico/browser-solidity-compiler';

import { client, profiles } from './api.js';

const deploy = document.getElementById('deploy');
const errors_output = document.getElementById('errors');
const success_output = document.getElementById('success');
const name = document.getElementById('name');

let editor = new EditorView({
    doc: ['// true is defect',
'// false is cooperate',
'function play(',
'    address opponent,',
'    bool[] calldata opponent_previous_plays,',
'    bool[] calldata bot_previous_plays',
') external override virtual returns (bool) {',
'  ',
'}'].join('\n'),
    extensions: [
        basicSetup,
        solidity,
    ],
    parent: document.getElementById('editor'),
});

(async () => {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    let addresses = await provider.send("eth_requestAccounts", []);
    let address = addresses[0];

    const lensbot = new ethers.Contract('0x3F359353554fe20a199BB803F87454075dEc8Cca', lensbotABI, provider);

    const challenge_select = document.getElementById("challenge");
    const profile_select = document.getElementById("profile");

    let challengeCount = await lensbot.getChallengesCount();
    let challenges = []
    for (let i = 0; i < challengeCount; ++i) {
        let option = document.createElement('option');
        option.value = await lensbot.challenges(i);
        option.innerText = option.value;
        challenge_select.appendChild(option);
    }

    profiles_ = await client.query( {query: profiles, variables: { ownedBy: address }});
    for (const profile of profiles_.data.profiles.items) {
        let option = document.createElement('option');
        option.value = profile.id;
        option.innerText = `${option.value} - ${profile.name}`;
        if (profile.isDefault) {
            option.setAttribute("selected", "selected");
        }
        profile_select.appendChild(option);
    }

    deploy.addEventListener('click', async e => {
        let result = await solidityCompiler({
            version: 'https://binaries.soliditylang.org/bin/soljson-latest.js',
            contractBody: `// SPDX-License-Identifier: UNLICENSED

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


contract Toggle is Bot {
    constructor(uint256 owner_profile, string memory name) Bot (owner_profile, name) {}

${editor.state.doc}

}`, options: {optimizer: {
    enabled: true,
runs: 200}}});

        errors_output.innerText = result.errors?.map(err => err.formattedMessage).join('') ?? '';

        if (result.contracts) {
            let compiled = result.contracts.Compiled_Contracts.Toggle;
            let abi = compiled.abi;
            let bytecode = compiled.evm.bytecode.object;
            let contractfactory = new ethers.ContractFactory(abi, bytecode, provider.getSigner());
            const contract = await contractfactory.deploy(profile_select.value, name.value);
            await contract.register_on(challenge.value);
            success_output.innerText = `contract address: ${contract.address}`;
        }
    });



})();
