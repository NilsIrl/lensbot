import{EditorView as m,basicSetup as g}from"codemirror";import{solidity as f}from"@replit/codemirror-lang-solidity";import{ethers as o}from"ethers";import{lensbotABI as v}from"./abi.js";import{solidityCompiler as w}from"@agnostico/browser-solidity-compiler";import{client as y,profiles as _}from"./api.js";const b=document.getElementById("deploy"),h=document.getElementById("errors"),B=document.getElementById("success"),C=document.getElementById("name");let x=new m({doc:["// true is defect","// false is cooperate","function play(","    address opponent,","    bool[] calldata opponent_previous_plays,","    bool[] calldata bot_previous_plays",") external override virtual returns (bool) {","  ","}"].join(`
`),extensions:[g,f],parent:document.getElementById("editor")});(async()=>{const r=new o.providers.Web3Provider(window.ethereum);let s=(await r.send("eth_requestAccounts",[]))[0];const a=new o.Contract("0x3F359353554fe20a199BB803F87454075dEc8Cca",v,r),c=document.getElementById("challenge"),l=document.getElementById("profile");let d=await a.getChallengesCount(),I=[];for(let t=0;t<d;++t){let e=document.createElement("option");e.value=await a.challenges(t),e.innerText=e.value,c.appendChild(e)}profiles_=await y.query({query:_,variables:{ownedBy:s}});for(const t of profiles_.data.profiles.items){let e=document.createElement("option");e.value=t.id,e.innerText=`${e.value} - ${t.name}`,t.isDefault&&e.setAttribute("selected","selected"),l.appendChild(e)}b.addEventListener("click",async t=>{let e=await w({version:"https://binaries.soliditylang.org/bin/soljson-latest.js",contractBody:`// SPDX-License-Identifier: UNLICENSED

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

${x.state.doc}

}`,options:{optimizer:{enabled:!0,runs:200}}});if(h.innerText=e.errors?.map(n=>n.formattedMessage).join("")??"",e.contracts){let n=e.contracts.Compiled_Contracts.Toggle,u=n.abi,p=n.evm.bytecode.object;const i=await new o.ContractFactory(u,p,r.getSigner()).deploy(l.value,C.value);await i.register_on(challenge.value),B.innerText=`contract address: ${i.address}`}})})();
