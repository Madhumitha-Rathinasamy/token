// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

 library LibraryFunction{
    
    function percentageCalculate(uint256 percent, uint256 amount)pure internal returns(uint256) {
        uint256 percentageValue = amount * percent / 100;
        return percentageValue;
        
    }
     
}