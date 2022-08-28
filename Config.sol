pragma solidity 0.8.16;

contract C {
    function sendAddress() public view returns(address){
        return tx.origin;
    }
}

contract B {
    function callContractC() public returns(address){
        C _c = new C();
        return _c.sendAddress();
    }
}


contract A {
    function callContractB() public returns(address){
        B _b = new B();
        return _b.callContractC();
    }
    // test test
}
