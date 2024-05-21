
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
        _before.isLiquidatable = exec.isLiquidatable(address(this));
    }

    function __after() internal {
        _after.isLiquidatable = exec.isLiquidatable(address(this));
    }

    modifier withChecks {
        __before();
        _;
        __after();
    }
}
