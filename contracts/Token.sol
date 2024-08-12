//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

/// @author Gagan2095
/// @title An ERC20 Implemented "Coins" token
/// @notice An fungible token created using ERC20 tokens standard
contract Token {

    uint256 private totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address=>uint256)) public allowance;
    string public name;
    string public symbol;
    uint8 public decimals;
    address private owner;

    /// @notice Logs the address of both the parties of an transaction with the value to be sent
    /// @param from the sender address of the transaction
    /// @param to the reciever address of the transaction
    /// @param value the value of the token to be sent in the transaction
    event Transfer(address indexed from, address indexed to, uint256 value);

    /// @notice Logs the address of both the parties of an approval for the transaction permission on behalf of other user
    /// @param owner the user who allowing spender to send tokens on his behalf
    /// @param spender the user or any other third party to which owner is allowing
    /// @param value the value of the token to be allowed to spender to send
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor (string memory tokenName, string memory tokenSymbol, uint8 tokenDecimal, uint256 supply) {
        name = tokenName;
        symbol = tokenSymbol;
        decimals = tokenDecimal;
        totalSupply += supply;
        balanceOf[msg.sender] += supply;
    }

    /// @notice transfer the token to the receipent address
    /// @param receipent address to which token will be send
    /// @param amount value of token to be sent
    /// @return boolean value depends on successfull transfer
    function transfer(address receipent, uint256 amount) 
        external 
        returns(bool){
        if(balanceOf[msg.sender] < amount) {
            revert("Caller's account balance does not have enough tokens to spend");
        }
        balanceOf[msg.sender] -= amount;
        balanceOf[receipent] += amount;
        emit Transfer(msg.sender, receipent, amount);
        return true;
    }

    /// @notice approve an user to send token on behalf of another user
    /// @param spender to whom we are approving
    /// @param amount how much value of tokens we are approving
    /// @return boolean value depends on successfull approve
    function approve(address spender, uint256 amount) 
        external 
        returns(bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /// @notice transfer the token on behalf of an user , amount will be deduct from the sender's account not from the user on behalf of the sender is sending
    /// @param sender address from which the amount will be send
    /// @param recipient address to which the amount to be send
    /// @param amount the value of token to be send
    /// @return boolean value depends on successfull approve
    function transferFrom(address sender, address recipient, uint256 amount) 
        external 
        returns(bool){
        if(allowance[msg.sender][sender] < amount) {
            revert("Caller's account balance does not have enough tokens to spend");
        }
        allowance[msg.sender][sender] -= amount;
        balanceOf[recipient]+=amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    /// @notice mint extra token, can be used only by the deployer, increase the totalsupply and the balance of the recipient
    /// @param recipient address to which minted tokens will be send
    /// @param amount value of token to be minted
    function _mint(address recipient, uint256 amount) external {
        require(msg.sender==owner,"Only Owner can mint the token");
        balanceOf[recipient] += amount;
        totalSupply += amount;
        emit Transfer(address(0), recipient, amount);
    }

    /// @notice destroy provided amount of tokens from the network, can be used only by the deployer, decrease the totalsupply and the balance of the recipient
    /// @param recipient address to which token will be destroyed
    /// @param amount value of token to be destroy
    function _burn(address recipient, uint256 amount) external {
        require(msg.sender==owner,"Only Owner can mint the token");
        require(balanceOf[recipient]>=amount,"Recipient does not have enough tokens");
        balanceOf[recipient] -= amount;
        totalSupply -= amount;
        emit Transfer(recipient, address(0), amount);
    }
}