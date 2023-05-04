// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Import the OZ IERC20 interface in order to interact with ERC20 tokens in a standardized manner
// Specifically: the AAVE, UNI, and WETH tokens are desired ERC20 tokens
// And, we will use the interface to deposit/withdraw tokens, with the token as a function parameter
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Import our rToken contract to deploy the receipt tokens (for AAVE, UNI, and WETH)
import {rToken} from "./rToken.sol";

/**
 * @title TokensDepository
 * @dev This contract allows for deposits of supported ERC20 tokens (AAVE, UNI, and WETH) 
 * and issues corresponding receipt tokens (rAAVE, rUNI, and rWETH) to the depositor.
 * Upon withdrawal, the receipt tokens are burned and the original tokens are returned to the user.
 */
contract TokensDepository {
        
    // The contract should:
    // (a) Take Deposits: receive the supported assets (addresses of the AAVE, UNI, and WETH tokens)
    // (b) Issue Receipts: issue/deploy the receipt tokens contracts (rAAVE, rUNI, and rWETH)
    // (c) Set Owner: set the owner of the receipt tokens contracts to this contract (done by constructor)
    // (d) Provide Redemption: burn the receipt tokens upon withdrawal  

    // Create a mapping of the supported assets (AAVE, UNI, and WETH)
    // to use for the constructor
    mapping(address => IERC20) public supportedAssets;

    // Create a mapping of the supported assets (AAVE, UNI, and WETH) 
    // to their receipt tokens (rAAVE, rUNI, and rWETH)
    mapping(address => rToken) public receiptTokens;

    // Create a modifer to check that the token is supported
    modifier onlySupportedAsset(address _token) {
        require(address(supportedAssets[_token]) != address(0), "Asset is not supported.");
        _;
    }

    // Store the owner of the contract
    address public owner;

    /**
     * @dev Constructor to initialize the contract with the supported assets and receipt tokens.
     * @param _aaveToken Address of the AAVE ERC20 token.
     * @param _uniToken Address of the UNI ERC20 token.
     * @param _wethToken Address of the WETH ERC20 token.
     */
    constructor(address _aaveToken, address _uniToken, address _wethToken) {
        
        // Set the owner of this contract to the address that deployed the contract
        owner = msg.sender;
        
        // Store the addresses of the supported assets: AAVE, UNI, and WETH 
        // in the supportedAssets mapping
        supportedAssets[_aaveToken] = IERC20(_aaveToken);
        supportedAssets[_uniToken] = IERC20(_uniToken);
        supportedAssets[_wethToken] = IERC20(_wethToken);

        // Upon contract deployment, deploy the receipt tokens contracts for the supported assets
        // and store the addresses of the receipt tokens contracts in the receiptTokens mapping 
        receiptTokens[_aaveToken] = new rToken(_aaveToken, "Receipt AAVE", "rAAVE");
        receiptTokens[_uniToken] = new rToken(_uniToken, "Receipt UNI", "rUNI");
        receiptTokens[_wethToken] = new rToken(_wethToken, "Receipt WETH", "rWETH");
}

/**
 * @dev Withdraw the specified amount of a supported token and burn the corresponding receipt tokens.
 * @param _token Address of the supported token to be withdrawn.
 * @param _amount Amount of the supported token to be withdrawn.
 */
function withdraw(address _token, uint256 _amount) external onlySupportedAsset(_token) {

    // Burn the receipt tokens (rAAVE, rUNI, and rWETH) from the user
    receiptTokens[_token].burn(msg.sender, _amount);

    // Transfer the desired amount of the supported asset from this contract to the user
    bool success = supportedAssets[_token].transfer(msg.sender, _amount);
    require(success, "transfer failed.");
}

/**
 * @dev Deposit the specified amount of a supported token and mint the corresponding receipt tokens.
 * @param _token Address of the supported token to be deposited.
 * @param _amount Amount of the supported token to be deposited.
 */
function deposit(address _token, uint256 _amount) external onlySupportedAsset(_token) {

    // Transfer the desired amount of the supported asset from the user to this contract
    // assuming the user has approved the transfer of the supported asset to this contract 
    // (i.e. the user has called the approve function of the supported asset in the frontend)
    bool success = supportedAssets[_token].transferFrom(msg.sender, address(this), _amount);
    require(success, "transferFrom failed.");

    // Mint the receipt tokens (rAAVE, rUNI, and rWETH) to the user
    receiptTokens[_token].mint(msg.sender, _amount); 

    }
}