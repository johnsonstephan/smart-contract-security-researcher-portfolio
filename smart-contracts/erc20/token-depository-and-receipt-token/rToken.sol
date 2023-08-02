// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Import OpenZeppelin ERC20 contract
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title rToken - Receipt Token
 * @dev This is a contract for creating receipt tokens (rTokens) representing staked underlying tokens.
 * It inherits the OpenZeppelin ERC20 contract and adds additional functionality.
 */
contract rToken is ERC20 {

    // Store the owner of the contract
    address public owner;

    // Store the address of the underlying token
    address public underlyingToken;

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    /**
     * @notice Constructs the rToken contract.
     * @dev The constructor receives the underlying token that the rToken represents
     * (AAVE, UNI, or WETH address) and the name and symbol for the rToken (rAAVE, rUNI, or rWETH).
     * Initializes the constructor of the inherited ERC20 contract to deploy the rToken.
     * @param _underlyingToken The address of the underlying token.
     * @param _name The name of the rToken.
     * @param _symbol The symbol of the rToken.
     */
    constructor(
        address _underlyingToken,
        string memory _name,
        string memory _symbol
    ) public ERC20(_name, _symbol) {
        // Safety Check: Ensure the underlying token is not the zero address
        require(
            _underlyingToken != address(0),
            "Underlying token cannot be the zero address."
        );

        // Set the owner of the contract to the msg.sender
        owner = msg.sender;

        // Store the _underlyingToken address
        underlyingToken = _underlyingToken;
    }

    /**
     * @notice Mints rTokens to a specified address.
     * @dev Can only be called by the contract owner.
     * @param _to The address to receive the newly minted rTokens.
     * @param _amount The amount of rTokens to be minted.
     */
    function mint(address _to, uint256 _amount) external onlyOwner {
        _mint(_to, _amount);
    }

    /**
     * @notice Burns rTokens from a specified address.
     * @dev Can only be called by the contract owner.
     * @param _from The address to have the rTokens burned.
     * @param _amount The amount of rTokens to be burned.
     */
    function burn(address _from, uint256 _amount) external onlyOwner {
        _burn(_from, _amount);
    }
}