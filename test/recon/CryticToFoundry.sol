
// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {TargetFunctions} from "./TargetFunctions.sol";
import {FoundryAsserts} from "@chimera/FoundryAsserts.sol";

import "src/IRiskManager.sol";
import "src/modules/RiskManager.sol";
import "src/modules/Liquidation.sol";

contract CryticToFoundry is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
        setup();
    }

    
    //  forge test --match-test testDemo -vv
    function testDemo() public {
        // TODO: Given any target function and foundry assert, test your results
        console2.log("address(this)", address(this));

        eToken_deposit(1e18);
        // console2.log("eToken.name()", eToken.name());
        console2.log("eToken", eToken.balanceOf(address(this)));
        dToken_borrow(1e17);
        console2.log("dToken", dToken.balanceOf(address(this)));
        vm.warp(block.timestamp + 1);
        vm.roll(block.number + 1);
        borrow_price_change(1e36);

        console2.log("riskManager.isLiquidatable(address(this)", exec.isLiquidatable(address(this)));
        IRiskManager.AssetLiquidity[] memory assets = exec.detailedLiquidity(address(this));
        for(uint256 i; i < assets.length; i++) {
            console2.log("assets[i].status.collateralValue", assets[i].status.collateralValue);
            console2.log("assets[i].status.liabilityValue", assets[i].status.liabilityValue);
            console2.log("assets[i].status.numBorrows", assets[i].status.numBorrows);
            console2.log("assets[i].status.borrowIsolated", assets[i].status.borrowIsolated);
        }
    }
}
