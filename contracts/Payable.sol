// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract Payable{
  //to recieve external currency
    receive() external payable {}

    //  address public owner;
     

    //  constructor() payable{
    //      owner = msg.sender;
    //  }

    // modifier onlyOwner(){
    //      require(owner == msg.sender,"only owner");
    //      _;
    // } 
     /* *
     * @dev withdraw native currency to owner account
     */

     function deposit() external payable{}

    //  function balanceOf() external view returns(uint){
    //      return address(this).balance;
    //  }

    // function withdraw() external payable onlyOwner {
    //     uint nativeCrrency = address(this).balance;
    //     address payable _owner = payable(msg.sender);
    //     _owner.transfer(nativeCrrency);
    // }

     /* *
     * @dev transfer native currency contract to wallet
     * @param to
     */
    function transferNativeCurrenc(address payable to, uint value) payable external{
       uint contractBalance = address(this).balance;
        require(contractBalance >= msg.value,"Insufficient fund");
        to.transfer(value);
    }
}

