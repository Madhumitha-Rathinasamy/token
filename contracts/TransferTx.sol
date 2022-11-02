// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)

pragma solidity 0.8.7;

import "../contracts/IERC20.sol";

contract TransferTx{
    IERC20  public token;

    constructor(IERC20 _token){
        require(address(_token) != address(0));
        token = _token;
    }
    function ViewTransferTaxAmount()external view returns(uint256){
       return token.transferTaxAmount();
    }
    function transfer1(address recipient, uint256 amount)external returns(bool success){
       success = token.transfer(recipient, amount);
    }
    function approve_(address spender, uint256 amount) external returns(bool success){
         success = token.approve(spender, amount);
    }

}