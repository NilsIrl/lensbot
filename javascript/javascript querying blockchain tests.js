
// https://pub.dev/documentation/flutter_web3/latest/
// https://docs.ethers.io/v5/getting-started/


import { ethers } from "./ethers-5.2.esm.min.js";


// const provider = new ethers.providers.Web3Provider(window.ethereum);

// console.log(provider)
// 
// const signer = provider.getSigner();
// 
// 
// // const balance = await signer.getBalance();
// 

// console.log(balance);


// A Web3Provider wraps a standard Web3 provider, which is
// what MetaMask injects as window.ethereum into each page
const provider = new ethers.providers.Web3Provider(window.ethereum)

// MetaMask requires requesting permission to connect users accounts
await provider.send("eth_requestAccounts", []);

// The MetaMask plugin also allows signing transactions to
// send ether and pay to change state within the blockchain.
// For this, you need the account signer...
const signer = provider.getSigner()


const balance = await signer.getBalance();

// debugger


// console.log(balance);


console.log(await provider.getBlockNumber())


// https://docs.ethers.io/v5/getting-started/#getting-started--signing

// const signature = await signer.signMessage("Hello World");
// console.log(signature);




//from discord
const lensBotABI = [
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "name": "challenges",
        "outputs": [
            {
                "internalType": "address",
                "name": "",
                "type": "address"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getChallengesCount",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "register",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
];

const challengeABI = [
    {
        "inputs": [],
        "name": "getBotCount",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "name": "getLeaderboardAt",
        "outputs": [
            {
                "internalType": "address",
                "name": "",
                "type": "address"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getOwnerprofile",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "",
                "type": "address"
            }
        ],
        "name": "getPoints",
        "outputs": [
            {
                "internalType": "int256",
                "name": "",
                "type": "int256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "register",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
];

const botABI = [
    {
        "inputs": [],
        "name": "getName",
        "outputs": [
            {
                "internalType": "string",
                "name": "",
                "type": "string"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getOwnerprofile",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "opponent",
                "type": "address"
            },
            {
                "internalType": "bool[]",
                "name": "opponent_previous_plays",
                "type": "bool[]"
            },
            {
                "internalType": "bool[]",
                "name": "bot_previous_plays",
                "type": "bool[]"
            }
        ],
        "name": "play",
        "outputs": [
            {
                "internalType": "bool",
                "name": "",
                "type": "bool"
            }
        ],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "challenge_address",
                "type": "address"
            }
        ],
        "name": "register_on",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
];




// https://docs.ethers.io/v5/api/contract/contract/
const lensBotContract = new ethers.Contract('0x5bf4dfe318901DCacFD2986BA2c8a58389AaFc86', lensBotABI, provider);

// debugger

// 
// const a = await lensBotContract.getChallengesCount();
// 
// console.log(a)
// 
// // debugger
// 
// const b = await lensBotContract.challenges(0);
// 
// console.log(b)



const getChallengesAddress = async () => {
    const challengesCount = await lensBotContract.getChallengesCount();
    
    const challengesAddresses = [];
    
    for (let i=0; i < challengesCount; i++) {
        const challengeAddress = await lensBotContract.challenges(i);
        
        challengesAddresses.push(challengeAddress);
    }
    
    return challengesAddresses;
}


// console.log(await getChallengesAddress())
const challengesAddresses = await getChallengesAddress();

const challengeContracts = [];
const challengeContract = new ethers.Contract(challengesAddresses[1], challengeABI, provider);
challengeContracts.push(challengeContract);

// debugger



const getBotAddresses = async (challengeContract) => {
    const botCount = await challengeContract.getBotCount();
    
    const botAddresses = [];
    
    for (let i=0; i < botCount; i++) {
        const botAddress = await challengeContract.getLeaderboardAt(i);
        
        botAddresses.push(botAddress);
    }
    
    return botAddresses;
}



// console.log(await getBotAddresses(challengeContracts[0]));


const botAddresses = await getBotAddresses(challengeContracts[0]);


const botContract = new ethers.Contract(botAddresses[0], botABI, provider);
// debugger

// const name = await botContract.getName();
// const name = await botContract.functions.getName()

// ethers-5.2.esm.min.js:3 Uncaught Error: invalid ENS name (argument="name", value=["0x0F0Ff44A52F7Eb16fcAfb9Db1378B8e26e1F790d"], code=INVALID_ARGUMENT, version=providers/5.2.0)
//     at Logger.makeError (ethers-5.2.esm.min.js:3:58610)
//     at Logger.throwError (ethers-5.2.esm.min.js:3:58788)
//     at Logger.throwArgumentError (ethers-5.2.esm.min.js:3:58870)
//     at Web3Provider.<anonymous> (ethers-5.2.esm.min.js:3:518210)
//     at Generator.next (<anonymous>)


// debugger




// debugger

const name = await botContract.functions.getName()

const ownerProfile = await botContract.getOwnerprofile();

// debugger


const getDataForAllBotsInChallenge = async (challengeContract, botAddresses) => {
    const botsData = {};
    for (let i = 0; i < botAddresses.length; i++) {
        const botAddress = botAddresses[i];
        
        const botContract = new ethers.Contract(botAddress, botABI, provider);
        
        const pointsBigNumber = await challengeContract.getPoints(botAddress);
        const points = pointsBigNumber.toNumber();
        const name = await botContract.getName();
        
        botsData[botAddress] = {
            botAddress,
            botContract,
            points,
            name,
        };
    }
    
    return botsData;
}


// console.log(await getDataForAllBotsInChallenge(challengeContract, botAddresses));
// debugger


const botsData = await getDataForAllBotsInChallenge(challengeContract, botAddresses);

console.log(botsData);


const botsDataArr = Object.values(botsData);

const challengeLeaderboardAsText = botsDataArr
    .sort((a,b) => b.points - a.points)
    .map(({botAddress, points, name}) => `(${botAddress}) ${name} : ${points}`).join('\n')


const leaderboard = document.createElement('div');
leaderboard.style.fontFamily = 'monospace';
leaderboard.style.whitespace = 'pre';
leaderboard.innerText = challengeLeaderboardAsText;
document.body.append(leaderboard);
