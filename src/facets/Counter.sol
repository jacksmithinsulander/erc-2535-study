// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;

    event NewNumber(uint256 newNumber);

    function setNumber(uint256 newNumber) external {
        number = newNumber;
        emit NewNumber(newNumber);
    }

    function increment() external {
        number++;
        emit NewNumber(number);
    }

    // function decrement() external {
        // number--;
        // emit NewNumber(number);
    // }
}
