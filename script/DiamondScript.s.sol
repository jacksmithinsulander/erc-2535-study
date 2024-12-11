// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Diamond} from "src/Diamond.sol";
import {DiamondCutFacet} from "src/facets/DiamondCutFacet.sol";
import {DiamondInit} from "src/upgradeInitializers/DiamondInit.sol";
import {Counter} from "src/facets/Counter.sol";
import {Fibonacci} from "src/facets/Fibonacci.sol";
import {Math} from "src/facets/Math.sol";
import {IDiamondCut} from "src/interfaces/IDiamondCut.sol";
import {CounterV2} from "src/facets/CounterV2.sol";

// enum FacetCutAction {Add, Replace, Remove}
// // Add=0, Replace=1, Remove=2

// struct FacetCut {
    // address facetAddress;
    // FacetCutAction action;
    // bytes4[] functionSelectors;
// }

contract DiamondScript is Script {
    Diamond public diamond;
    DiamondCutFacet public diamondCutFacet;
    DiamondInit public diamondInit;
    Counter public counter;
    Fibonacci public fibonacci;

    IDiamondCut public diamondCut;
    uint256 public pkey = uint256(keccak256(abi.encodePacked("test")));

    function run() external returns (address _diamond) {
        vm.startBroadcast(pkey);

        diamondCutFacet = new DiamondCutFacet();
        diamond = new Diamond(vm.addr(pkey), address(diamondCutFacet));
        diamondInit = new DiamondInit();
        counter = new Counter();
        fibonacci = new Fibonacci();

        bytes4[] memory counterSelectors = new bytes4[](3);
        counterSelectors[0] = bytes4(keccak256("increment()"));
        counterSelectors[1] = bytes4(keccak256("setNumber(uint256)"));
        counterSelectors[2] = bytes4(keccak256("number()"));

        bytes4[] memory fibonacciSelectors = new bytes4[](1);
        fibonacciSelectors[0] = bytes4(keccak256("fibonacci(uint256)"));

        IDiamondCut.FacetCut[] memory facetCuts = new IDiamondCut.FacetCut[](2);
        facetCuts[0] = IDiamondCut.FacetCut({
            facetAddress: address(counter),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: counterSelectors
        });

        facetCuts[1] = IDiamondCut.FacetCut({
            facetAddress: address(fibonacci),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: fibonacciSelectors
        });

        diamondCut = IDiamondCut(address(diamond));

        diamondCut.diamondCut(facetCuts, address(diamondInit), abi.encodeWithSignature("init()"));

        vm.stopBroadcast();

        _diamond = address(diamond); 
    }

    function addFacet() external {
        vm.startBroadcast(pkey);

        Math math = new Math();

        bytes4[] memory mathSelectors = new bytes4[](1);
        mathSelectors[0] = bytes4(keccak256("add(uint256,uint256)"));

        IDiamondCut.FacetCut[] memory facetCuts = new IDiamondCut.FacetCut[](1);

        facetCuts[0] = IDiamondCut.FacetCut({
            facetAddress: address(math),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: mathSelectors
        });

        diamondCut.diamondCut(facetCuts, address(diamondInit), abi.encodeWithSignature("init()"));

        vm.stopBroadcast();
    }

    function updateFacet() external {
        vm.startBroadcast(pkey);

        CounterV2 counterV2 = new CounterV2();

        IDiamondCut.FacetCut[] memory facetCuts = new IDiamondCut.FacetCut[](1);
        bytes4[] memory counterSelectors = new bytes4[](3);
        counterSelectors[0] = bytes4(keccak256("increment()"));
        counterSelectors[1] = bytes4(keccak256("setNumber(uint256)"));
        counterSelectors[2] = bytes4(keccak256("number()"));

        facetCuts[0] = IDiamondCut.FacetCut({
            facetAddress: address(counterV2),
            action: IDiamondCut.FacetCutAction.Replace,
            functionSelectors: counterSelectors
        });

        diamondCut.diamondCut(facetCuts, address(diamondInit), abi.encodeWithSignature("init()"));

        vm.stopBroadcast();
    }

    function removeFacet() external {
        vm.startBroadcast(pkey);

        bytes4[] memory fibonacciSelectors = new bytes4[](1);
        fibonacciSelectors[0] = bytes4(keccak256("fibonacci(uint256)"));

        IDiamondCut.FacetCut[] memory facetCuts = new IDiamondCut.FacetCut[](1);
        facetCuts[0] = IDiamondCut.FacetCut({
            facetAddress: address(0),
            action: IDiamondCut.FacetCutAction.Remove,
            functionSelectors: fibonacciSelectors
        });

        diamondCut.diamondCut(facetCuts, address(diamondInit), abi.encodeWithSignature("init()"));

        vm.stopBroadcast();
    }
}