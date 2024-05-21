
// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {TargetFunctions} from "./TargetFunctions.sol";
import {FoundryAsserts} from "@chimera/FoundryAsserts.sol";

import "src/modules/RiskManager.sol";
import "src/modules/Liquidation.sol";

contract CryticToFoundry is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
        setup();
    }

    
    //  forge test --match-test testDemo -vv
    function testDemo() public {
        // TODO: Given any target function and foundry assert, test your results
        eToken_deposit(1e18);
        dToken_borrow(1e16);
        console2.log("dToken", dToken.balanceOf(address(this)));
        borrow_price_change(10000 * 1e36);

        // console2.log("riskManager.isLiquidatable(address(this)", exec.isLiquidatable(address(this)));
        // eToken_donateToReserves(1e18 - 10);
        // console2.log("riskManager.isLiquidatable(address(this)", exec.isLiquidatable(address(this)));

        Liquidation.LiquidationOpportunity memory liqOpp = liquidation.checkLiquidation(
            address(123), address(this), address(borrowToken), address(baseToken)
        );
    }
}
