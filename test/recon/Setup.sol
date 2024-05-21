
// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseSetup} from "@chimera/BaseSetup.sol";

import "src/Euler.sol";

// Modules
import "src/modules/DToken.sol";
import "src/modules/EToken.sol";
import "src/modules/Exec.sol";
import "src/modules/Governance.sol";
import "src/modules/Installer.sol";
import "src/modules/Liquidation.sol";
import "src/modules/Markets.sol";
import "src/modules/RiskManager.sol";

import "src/modules/Swap.sol";
import "src/modules/SwapHub.sol";

// Mock token
import "src/test/TestERC20.sol";


// IRM
import "src/modules/interest-rate-models/test/IRMFixed.sol";

contract MockClFeed {
    int256 public latestAnswer;

    function setAnswer(int256 newAnswer) external returns (int256) {
        latestAnswer = newAnswer;
    }
}


abstract contract Setup is BaseSetup {

    Euler singleton;
    address admin = address(this);
    address user = address(this);

    Installer installer;
    DToken dToken;
    EToken eToken;
    Exec exec;
    Governance gov;
    Liquidation liquidation;
    Markets markets;
    RiskManager riskManager;
    Swap swap;
    SwapHub swapHub;

    MockClFeed mockFeedbase;
    MockClFeed mockFeedBorrow;

    TestERC20 baseToken;
    TestERC20 borrowToken;

    function setup() internal virtual override {
        // Modules
        installer = new Installer(bytes32(uint256(0x1)));

        
        dToken = new DToken(bytes32(uint256(0x1)));
        eToken = new EToken(bytes32(uint256(0x1)));
        exec = new Exec(bytes32(uint256(0x1)));
        gov = new Governance(bytes32(uint256(0x1)));
        liquidation = new Liquidation(bytes32(uint256(0x1)));
        markets = new Markets(bytes32(uint256(0x1)));
        // riskManager = new RiskManager(bytes32(uint256(0x1)));
        // swap = new Swap(bytes32(uint256(0x1)));
        swapHub = new SwapHub(bytes32(uint256(0x1)));

        singleton = new Euler(admin, address(installer));

        mockFeedbase = new MockClFeed();
        mockFeedbase.setAnswer(int256(1e8));
        mockFeedBorrow = new MockClFeed();
        mockFeedBorrow.setAnswer(int256(1e8));

        address[] memory toInstall = new address[](9);
        toInstall[0] = address(dToken);
        toInstall[1] = address(eToken);
        toInstall[2] = address(exec);
        toInstall[3] = address(gov);
        toInstall[4] = address(liquidation);
        toInstall[5] = address(markets);
        toInstall[6] = address(riskManager);
        toInstall[7] = address(swap);
        toInstall[8] = address(swapHub);


        // NOTE: Pretty sure this is wrong
        Installer(address(singleton)).installModules(toInstall);

        // Create mock tokens
        baseToken = new TestERC20("Base", "BASE", 18, false);
        borrowToken = new TestERC20("borrow", "BORROW", 18, false);

        baseToken.mint(address(this), 1_000_000e18);
        borrowToken.mint(address(this), 1_000_000e18);

        baseToken.approve(address(singleton), type(uint256).max);
        borrowToken.approve(address(singleton), type(uint256).max);



        // Create a market
        Markets(address(singleton)).activateMarket(address(baseToken));
        Markets(address(singleton)).activateMarket(address(borrowToken));

        

        // Then check for more coverage
    }
}
