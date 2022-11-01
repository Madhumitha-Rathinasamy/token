// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)

pragma solidity 0.8.7;

import {LibraryFunction} from "../contracts/LibraryFunction.sol";
import "../contracts/IERC20.sol";
import "../contracts/Payable.sol";

contract ERC20 is IERC20, Payable{
    string _name;
    string _symbol;
    uint256 _decimals = 18;
    uint256 total_supply = 2000000000 * 10 ** _decimals;
    mapping(address => uint256) balance_of;
    mapping(address => mapping(address=> uint256)) _allowance;

    uint256 public marketing_tx_percentage = 1;
    uint256 public dev_tx_percentage= 2;
    uint256 public charity_tx_percentage = 3;
    uint256 public totalTaxValue;
    uint256 public totalMarketingPercentage;
    uint256 public totalDevPercentage;
    uint256 public totalCharityPercentage;
    uint256 public burnAmount;
    uint256 public burnPercentage = 1;
    uint256 public totalTaxPercentage;
     address ownerOfTransation;

     address marketing_address = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
     address dev_address = 0x583031D1113aD414F02576BD6afaBfb302140225;
     address charity_address = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C;

     using LibraryFunction for *;

// to set the values of name, symbol and total supply

    constructor() {
        _name = "Spark Tokens";
        _symbol = "SPK"; 
        balance_of[msg.sender] = total_supply;
        ownerOfTransation = 0x5705d286e8fc970ca5dFa5C480b708126b6FcB03;
    }

// to view the name of a contract
    function name() external view returns(string memory){
        return _name;
    }
// To view the symbol of a contract
    function symbol() external view returns(string memory){
        return _symbol;
    }

// to view the decimal of a contract
    function decimals() external view returns(uint256){
        return _decimals;
    }
// to view the total supply of a contract
    function totalSupply() external view override returns(uint256){
        return total_supply;
    }

/* 
     * @dev displace the balance of an given account
     * @param account
     */

    function balanceOf(address account) public view override returns(uint256){
        return balance_of[account];
    }

 /* 
     * @dev to transfer the token to the recipient from account holder to the recipient
     * @param recipient and amount
     */

    function transfer(address recipient, uint256 amount) external override onlyOwner returns(bool){
       _transfer(msg.sender, recipient, amount);
       return true;
    }

    /* 
     * @dev get the allowance
     * @param owner and spender
     */

    function allowance(address owner, address spender) public override view returns(uint256){
        return _allowance[owner][spender];
    } 

    /* 
     * @dev approve the allowance to the spender form the account holder
     * @param spender and amount
     */ 

    function approve(address spender, uint256 amount) external override returns(bool){
        require(balance_of[msg.sender] >= amount,"Insufficient fund");
       _approve(msg.sender, spender, amount);
        return true;
    }

    /* 
     * @dev transfer allowance to the recipient
     * @param sender, recipient and amount
     */

    function transferFrom(address sender, address recipient, uint256 amount) external override returns(bool){
        _approve(sender, recipient, amount);
        spend_allowance(sender, recipient, amount);
        balance_of[recipient] += amount;
        taxReduction(amount);  
        return true;
    }
    modifier onlyOwner(){
        require(msg.sender == ownerOfTransation, "Only owner can transfer");
        _;
     }

    /* 
     * @dev check the spender token is greater than the given amount
     * if the condition is passed, the amount will reduced from the account holder and sent to recipient
     * @param spender, recipient and amount
     */

    function _transfer(address spender, address recipient, uint256 amount) internal {
        require(recipient != address(0), "Recipient address is zero account");
        require(spender != address(0), "Spender account is Zero account");
        require(balance_of[spender] >= amount,"Insufficient fund");
        balance_of[spender] -= amount;
        burnAmount = amount * burnPercentage / 100;
        total_supply -= burnAmount;
        balance_of[address(0)] += burnAmount;
        taxReduction(amount-burnAmount);
        balance_of[recipient] = amount - totalTaxPercentage;
    }

    /* 
     * @dev calculate the tax amount, if the tax amount is greater than 100 * 10 ** 18 
     * taxCalculation function will execute
     * @param amount
     */

    function taxReduction(uint256 amount) internal {
       uint256 marketingPercentage = marketing_tx_percentage.percentageCalculate(amount);
       totalMarketingPercentage += marketingPercentage;
       uint256 devPercentage = dev_tx_percentage.percentageCalculate(amount);
       totalDevPercentage += devPercentage;
       uint256 charityPercentage = charity_tx_percentage.percentageCalculate(amount);
       totalCharityPercentage += charityPercentage;
       totalTaxPercentage = (marketingPercentage + devPercentage + charityPercentage);
        totalTaxValue = (totalMarketingPercentage + totalDevPercentage + totalCharityPercentage);
        if(totalTaxValue >= 100 * 10 ** 18){
        taxCalculation();
        totalMarketingPercentage = 0;
        totalDevPercentage = 0;
        totalCharityPercentage = 0;
        }
    }

    /* *
     * @dev calculate the percentage value
     * @param percent and amount
     */

    // function percentageCalculate(uint256 percent, uint256 amount) internal pure returns(uint256){
    //     uint256 percentageValue = amount * percent / 100;
    //     return percentageValue;
    // }

    /* *
     * @dev add the amount to the allowance between spender and recipient
     * @param spender, recipient and amount
     */

    function _approve(address spender, address recipient, uint256 amount) internal {
        require(recipient != address(0), "Recipient address is zero account");
        require(spender != address(0), "Spender account is Zero account");
        _allowance[spender][recipient] += amount;
    }

 /* *
     * @dev reduce the amount from the allowance between spender and recipient
     * @param spender, recipient and amount
     */

    function spend_allowance(address spender, address recipient, uint256 amount) internal {
        require(_allowance[spender][recipient] >= amount,"Insufficient fund");
        unchecked{
            _allowance[spender][msg.sender] -= amount;
        }
    } 

/* *
     * @dev increase the allowance between owner and spender
     * @param spender and addValue
     */

    function increaseAllowance(address spender, uint256 addedValue) external returns(bool){
        _approve(msg.sender, spender, addedValue);
        return true;
    }

    /* *
     * @dev decrease the allowance between owner and spender
     * @param spender and addValue
     */

    function decreaseAllowance(address spender, uint256 subtractedValue) external returns(bool){
        spend_allowance(msg.sender, spender, subtractedValue);
        return true;
    }

   /* *
     * @dev to increase the token of a contract
     * @param account, amount
     */  

    function _mint(address account, uint256 amount) internal {
        balance_of[account] += amount;
        total_supply += amount;
    }

   /* *
     * @dev to decrease the token of a user
     * @param account, amount
     */  

    function _burn(address account, uint256 amount) internal view{
        require(account != address(0), "This is an Zero Account");
        require(balanceOf(account) >= amount, "Insufficient fund");
        uint256 reduceBalanceOfUser = balanceOf(account);
        reduceBalanceOfUser -= amount;
        
    }

    /* *
     * @dev to update the values of the tax percentage
     * @param marketingTaxPercentage, devTaxPercentage and charityTaxPercentage
     */ 

    function updateTxPercentage(uint256 marketingTaxPercentage, uint256 devTaxPercentage, uint256 charityTaxPercentage)external{
        marketing_tx_percentage = marketingTaxPercentage;
        dev_tx_percentage = devTaxPercentage;
        charity_tx_percentage = charityTaxPercentage;
    }

 /* *
     * @dev to update the wallet of the tax holder
     * @param marketingAddress, devAddress and charityAddress
     */ 

    function updateTaxHolderAddress(address marketingAddress, address devAddress, address charityAddress) external {
        marketing_address = marketingAddress;
        dev_address = devAddress;
        charity_address = charityAddress;
    }

     /* *
     * @dev to update burn percentage while transation
     * @param burn_percentage
     */ 
function updateBurnPercentage(uint256 _burnPercentage) external {
        burnPercentage = _burnPercentage;
    }


     // add the tax amount to the tax holder

    function taxCalculation() internal{
            
            balance_of[marketing_address] += totalMarketingPercentage;
            balance_of[dev_address] += totalDevPercentage;
            balance_of[charity_address] += totalCharityPercentage;
            totalTaxValue = 0;
    }
    

}
