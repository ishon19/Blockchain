// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.6.0;

// no constructor in this case
// the default constructor is being used 

contract Counter {
  uint value;

  // the functions have public visibility
  function initialize(uint x) public {
     value = x; 
  } 
  
  // this is a view function and invokation of this function 
  // would not get recorded on the blockchain because this does not 
  // change the value or the state of the counter
  function get() public view returns (uint) {
    return value;
  }

  function increment(uint n) public {
    value += n;
  }

  function decrement(uint n) public {
      value -= n;
  }
}