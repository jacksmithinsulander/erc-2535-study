// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Fibonacci {

    event FibonacciNumber(uint256 n, uint256 result);

    function fibonacci(uint256 _n) external returns (uint256 _res) {
        uint256 a = 0;
        uint256 b = 1;
        for (uint256 i = 0; i < _n; i++) {
            uint256 next = a + b;
            a = b;
            b = next;
        }
        _res = a;
        emit FibonacciNumber(_n, _res);
    }
}
