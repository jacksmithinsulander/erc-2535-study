// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {DiamondScript} from "script/DiamondScript.s.sol";
import {ICollection} from "src/interfaces/ICollection.sol";
import {ICollectionV2} from "src/interfaces/ICollectionV2.sol";
import {ICollectionWMath} from "src/interfaces/ICollectionWMath.sol";
import "forge-std/Test.sol";

contract DiamondTest is Test {
    DiamondScript public diamondScript;

    function setUp() external {
        diamondScript = new DiamondScript();
    }

    function test_diamond() external {
        address diamond = diamondScript.run();

        ICollection collection = ICollection(diamond);

        collection.increment();
        assertEq(collection.number(), 1);

        collection.setNumber(10);
        assertEq(collection.number(), 10);

        assertEq(collection.fibonacci(collection.number()), 55);

        collection.increment();
        assertEq(collection.number(), 11);
        assertEq(collection.fibonacci(collection.number()), 89);
    }

    function test_addFacet() external {
        address diamond = diamondScript.run();

        ICollectionWMath collection = ICollectionWMath(diamond);

        vm.expectRevert();
        collection.add(1, 2);

        diamondScript.addFacet();

        assertEq(collection.add(1, 2), 3);
    }

    function test_updateFacet() external {
        address diamond = diamondScript.run();

        ICollectionV2 collection = ICollectionV2(diamond);

        collection.increment();
        assertEq(collection.number(), 1);
        vm.expectRevert();
        collection.decrement();

        diamondScript.updateFacet();

        collection.increment();
        assertEq(collection.number(), 11);
    }

    function test_removeFacet() external {
        address diamond = diamondScript.run();

        ICollectionWMath collection = ICollectionWMath(diamond);

        assertEq(collection.fibonacci(10), 55);

        diamondScript.removeFacet();

        vm.expectRevert();
        collection.fibonacci(10);
    }
}
