
// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Setup} from "./Setup.sol";

abstract contract BeforeAfter is Setup {
    

    struct Vars {
        bool isLiquidatable;
    }

    Vars internal _before;
    Vars internal _after;

    function __before() internal {
        _before.isLiquidatable = riskManager.isLiquidatable(address(this));
    }

    function __after() internal {
        _after.isLiquidatable = riskManager.isLiquidatable(address(this));
    }
}
