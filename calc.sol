pragma solidity ^0.4.24;
import "./SafeMath.sol";

contract Calc {
    uint256 public value;
    uint256 public value2;
    
    function add(uint _value1, uint _value2) public {
        value = SafeMath.add(_value1, _value2);
    }

    function deductions(uint _value3, uint _value4) public {
        value2 = SafeMath.sub(_value3, _value4);
    }
}
