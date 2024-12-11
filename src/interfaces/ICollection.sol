// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICollection {
    function number() external view returns (uint256);
    function increment() external;
    function setNumber(uint256 _number) external;
    function fibonacci(uint256 _number) external returns (uint256);
}