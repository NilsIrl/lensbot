
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
		"inputs": [
			{
				"internalType": "address",
				"name": "lensbot_addr",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "owner_profile",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "name_local",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_roundLength",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
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
				"name": "i",
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
				"name": "bot",
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
		"name": "getRoundLength",
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
			},
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "plays",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
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
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "scores",
		"outputs": [
			{
				"internalType": "int256",
				"name": "",
				"type": "int256"
			}
		],
		"stateMutability": "view",
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
const lensBotContract = new ethers.Contract('0x3F359353554fe20a199BB803F87454075dEc8Cca', lensBotABI, provider);

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
const challengeContract = new ethers.Contract(challengesAddresses[0], challengeABI, provider);
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


const getLeaderboardContainer = () => {
    const challengeLeaderboardAsText = botsDataArr
        .sort((a,b) => b.points - a.points)
        .map(({botAddress, points, name}) => `(${botAddress}) ${name} : ${points}`).join('\n')


    const leaderboard = document.createElement('div');
    leaderboard.style.fontFamily = 'monospace';
    leaderboard.style.whitespace = 'pre';
    leaderboard.innerText = challengeLeaderboardAsText;
    
    return leaderboard;
}
const leaderboardContainer = getLeaderboardContainer();
document.body.append(leaderboardContainer);



const getPlaysMatrixForChallenge = async (challengeContract, botsDataArr) => {
    // const roundLength = await challengeContract.getRoundLength();
    // 
    // const plays = [];
    // 
    // for (let i = 0; i < botsDataArr.length; i++) {
    //     const bot1Data = botsDataArr[i];
    // 
    //     const playsForBot1 = [];
    //     plays.push(playsForBot1);
    // 
    //     for (let j = 0; j < botAddresses.length; j++) {
    //         if (i === j) {
    //             continue;
    //         }
    // 
    //         const playsForBot1vsBot2 = [];
    //         playsForBot1.push(playsForBot1vsBot2);
    // 
    //         const bot2Data = botsDataArr[j];
    // 
    //         for (let turn = 0; turn < roundLength; turn++) {
    //             const play = await challengeContract.plays(bot1Data.botAddress, bot2Data.botAddress, turn);
    //             // console.log(play, i, j, turn)
    //             playsForBot1vsBot2.push(play);
    //         }
    //     }
    // }
    // 
    // return plays;
    
    
    // hardcode for testing
    return [
        [[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]],
        [[true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true]]
    ];;
}

const matrix = await getPlaysMatrixForChallenge(challengeContract, botsDataArr);


const scoreTurn = ([a, b]) => {
    
    let deltaA = 0;
    let deltaB = 0;
    
    // CC -1 -1 
    // CD -3  0
    // DD -2 -2
    // both defect
    if (a && b) {
        deltaA -= 2;
        deltaB -= 2;
        // bota defect
        // botb cooperate
    } else if (a && (!b)) {
        deltaB -= 3;
        // bota cooperate
        // botb defect
    } else if ((!a) && b) {
        deltaA -= 3;
        // both cooperate
    } else {
        deltaA -= 1;
        deltaB -= 1;
    }
    
    return [deltaA, deltaB];
}

const scoreRound = round => {
    let totalA = 0;
    let totalB = 0;
    
    for (let i = 0; i < round.turns.length; i++) {
        const turn = round.turns[i];
        
        const [deltaA, deltaB] = scoreTurn(turn);
        
        totalA += deltaA;
        totalB += deltaB;
    }
    
    return [totalA, totalB];
}


console.log(matrix)

const getShortTextForDefectCooperateBool = b => b ? 'D' : 'C';

// const renderMatrix = (botsDataArr, matrix) => {
// 
//     const container = document.createElement('div');
//     const elements = [];
// 
//     const addElement = text => {
//         const element = document.createElement('div');
//         element.innerText = text;
//         elements.push(element);
//     }
// 
//     debugger;
// 
//     for (let i = 0; i < matrix.length; i++) {
// 
//         addElement(botsDataArr[i].name);
// 
// 
//         for (let j = 0; j < matrix[0].length; j++) {
//             addElement(getShortTextForDefectCooperateBool(matrix[i][j]));
//         }
//     }
// 
//     elements.forEach(element => container.append(element));
// 
//     return container;
// 
// }


// const matrix3ToScoresMatrix = matrix => {
// 
// }


// const renderMatrix = (botsDataArr, matrix) => {
// 
//     const container = document.createElement('div');
//     const elements = [];
// 
//     const addElement = text => {
//         const element = document.createElement('div');
//         element.innerText = text;
//         elements.push(element);
//     }
// 
//     debugger;
// 
//     for (let i = 0; i < matrix.length; i++) {
// 
//         addElement(botsDataArr[i].name);
// 
// 
//         for (let j = 0; j < matrix[0].length; j++) {
//             addElement(getShortTextForDefectCooperateBool(matrix[i][j]));
//         }
//     }
// 
//     elements.forEach(element => container.append(element));
// 
//     return container;
// 
// }

// const container = renderMatrix(botsDataArr, matrix);
// document.body.append(container);


// 
// const getRounds = async (challengeContract, botsDataArr) => {
//     const roundLength = await challengeContract.getRoundLength();
// 
//     const rounds = [];
// 
//     for (let i = 0; i < botsDataArr.length; i++) {
//         const bot1Data = botsDataArr[i];
// 
//         const roundsForBot1 = [];
//         rounds.push(roundsForBot1);
// 
//         for (let j = 0; j < botAddresses.length; j++) {
//             if (i === j) {
//                 continue;
//             }
// 
//             const bot2Data = botsDataArr[j];
// 
//             const roundForBot1vsBot2 = {
//                 turns: [],
//             };
//             roundsForBot1.push(roundForBot1vsBot2);
// 
//             for (let turnIndex = 0; turnIndex < roundLength; turnIndex++) {
//                 const play1 = await challengeContract.plays(bot1Data.botAddress, bot2Data.botAddress, turnIndex);
//                 const play2 = await challengeContract.plays(bot2Data.botAddress, bot1Data.botAddress, turnIndex);
// 
//                 const turn = [play1, play2];
// 
//                 roundForBot1vsBot2.turns.push(turn);
//             }
// 
//             roundForBot1vsBot2.score = scoreRound(roundForBot1vsBot2);
// 
//         }
//     }
// 
//     return rounds;
// }
// 
// 
// const rounds = await getRounds(challengeContract, botsDataArr);
// 
// 
// const renderRoundsGrid = (challengeContract, botsDataArr, rounds) => {
// 
// 
// 
//     const container = document.createElement('div');
//     const elements = [];
// 
//     const addElement = text => {
//         const element = document.createElement('div');
//         element.innerText = text;
//         elements.push(element);
//     }
// 
// 
//     for (let i = 0; i < botsDataArr.length; i++) {
//         const bot1Data = botsDataArr[i];
// 
//         addElement(bot1Data.name);
// 
// 
//         for (let j = 0; j < botAddresses.length; j++) {
//             if (i === j) {
//                 continue;
//             }
// 
//             const bot2Data = botsDataArr[j];
// 
//             const roundForBot1vsBot2 = rounds[i][j];
//             debugger
// 
//             addElement(roundForBot1vsBot2.score);
// 
//         }
//     }
// 
//     elements.forEach(element => container.append(element));
// 
//     return container;
// 
// 
// }
// 
// const container = renderRoundsGrid(challengeContract, botsDataArr, rounds);
// document.body.append(container);







const getRoundsMap2 = async (challengeContract, botsDataArr) => {
    const roundLength = await challengeContract.getRoundLength();
    
    const roundsMap2 = {};
    
    for (let i = 0; i < botsDataArr.length; i++) {
        const bot1Data = botsDataArr[i];
    
        const roundsForBot1 = {};
        roundsMap2[bot1Data.botAddress] = roundsForBot1;
    
        for (let j = 0; j < botAddresses.length; j++) {
            if (i === j) {
                continue;
            }
            
            const bot2Data = botsDataArr[j];
            
            
            const roundForBot1vsBot2 = {
                turns: [],
            };
            roundsForBot1[bot2Data.botAddress] = roundForBot1vsBot2;
            
    
            for (let turnIndex = 0; turnIndex < roundLength; turnIndex++) {
                const play1 = await challengeContract.plays(bot1Data.botAddress, bot2Data.botAddress, turnIndex);
                const play2 = await challengeContract.plays(bot2Data.botAddress, bot1Data.botAddress, turnIndex);
                
                const turn = [play1, play2];
                
                roundForBot1vsBot2.turns.push(turn);
            }
            
            roundForBot1vsBot2.score = scoreRound(roundForBot1vsBot2);
            
        }
    }
    
    return roundsMap2;
}


const roundsMap2 = await getRoundsMap2(challengeContract, botsDataArr);

console.log(roundsMap2)


const renderRoundsMap2 = async (challengeContract, botsDataArr, roundsMap2) => {
    
    const container = document.createElement('div');
    const elements = [];

    const addElement = text => {
        const element = document.createElement('div');
        element.innerText = text;
        elements.push(element);
    }
    
    addElement(''); // gap
    for (let i = 0; i < botsDataArr.length; i++) {
        const bot1Data = botsDataArr[i];
        addElement(bot1Data.name);
    }
    
    for (let i = 0; i < botsDataArr.length; i++) {
        const bot1Data = botsDataArr[i];
        
        addElement(bot1Data.name);
        
        const roundsForBot1 = roundsMap2[bot1Data.botAddress];
    
    
        for (let j = 0; j < botAddresses.length; j++) {
            if (i === j) {
                // continue;
                addElement(''); // gap
                continue;
            }
            
            const bot2Data = botsDataArr[j];
            const roundForBot1vsBot2 = roundsForBot1[bot2Data.botAddress];
            
            addElement(roundForBot1vsBot2.score[0]);
            
        }
    }
    
    elements.forEach(element => container.append(element));
    
    // display: grid;
    // grid-template-columns: 1fr 1fr 1fr 1fr;
    // grid-gap: 5px;
    
    container.style.display = 'grid';
    container.style.gridTemplateColumns =  Array(botsDataArr.length + 1).fill().map(() => '1fr').join(' ');
    
    
    return container;
}



const container = await renderRoundsMap2(challengeContract, botsDataArr, roundsMap2);
document.body.append(container);
