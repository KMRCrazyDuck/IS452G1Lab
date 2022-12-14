pragma solidity ^0.4.0;
 
contract Counter {
 
    uint count = 0;
    address owner; //Let's keep track of the owner
 
    function Counter() {
    owner = msg.sender; // We keep the address of the creator
    } 
 
    function increment() public {
       if (owner == msg.sender) { // We check who calls the function
          count = count + 1;
       }
    }
 
    /* used to read the value of count */
    function getCount() constant returns (uint) {
       return count;
    }
}
