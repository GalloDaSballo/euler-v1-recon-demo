
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

import {vm} from "@chimera/Hevm.sol";
import {console2} from "forge-std/console2.sol";

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

    uint256 subAccountId = 1;

    IRMFixed mockIRM;

    function setup() internal virtual override {
        // Modules
        installer = new Installer(bytes32(uint256(0x1)));

        mockIRM = new IRMFixed(bytes32(uint256(0x1)));

        
        dToken = new DToken(bytes32(uint256(0x1)));
        eToken = new EToken(bytes32(uint256(0x1)));
        exec = new Exec(bytes32(uint256(0x1)));
        gov = new Governance(bytes32(uint256(0x1)));
        liquidation = new Liquidation(bytes32(uint256(0x1)));
        markets = new Markets(bytes32(uint256(0x1)));
        riskManager = new RiskManager(bytes32(uint256(0x1)));
        // swap = new Swap(bytes32(uint256(0x1)));
        swapHub = new SwapHub(bytes32(uint256(0x1)));

        singleton = new Euler(admin, address(installer));

        mockFeedbase = new MockClFeed();
        mockFeedbase.setAnswer(int256(1e8));
        mockFeedBorrow = new MockClFeed();
        mockFeedBorrow.setAnswer(int256(1e8));

        address[] memory toInstall = new address[](9);
        toInstall[0] = address(dToken);
        dToken.moduleId();
        dToken.moduleGitCommit();
        toInstall[1] = address(eToken);
        toInstall[2] = address(exec);
        toInstall[3] = address(gov);
        toInstall[4] = address(liquidation);
        toInstall[5] = address(markets);
        toInstall[6] = address(riskManager);
        // toInstall[7] = address(swap);
        toInstall[7] = address(swapHub);

        toInstall[8] = address(mockIRM);


        // NOTE: Pretty sure this is wrong
        
        Installer(address(singleton.moduleIdToProxy(installer.moduleId()))).installModules(toInstall);

        // Create mock tokens
        baseToken = new TestERC20("Base", "BASE", 18, false);
        borrowToken = new TestERC20("borrow", "BORROW", 18, false);

        baseToken.mint(address(this), 1_000_000e18);
        borrowToken.mint(address(this), 1_000_000e18);

        baseToken.approve(address(singleton), type(uint256).max);
        borrowToken.approve(address(singleton), type(uint256).max);

        // TODO: Setup the CL feed here
        // Setup the 2 feeds
        gov = Governance(address(singleton.moduleIdToProxy(gov.moduleId())));
        gov.setChainlinkPriceFeed(address(baseToken), address(mockFeedbase));
        gov.setChainlinkPriceFeed(address(borrowToken), address(mockFeedBorrow));



        // Create a market
        Markets(address(singleton.moduleIdToProxy(markets.moduleId()))).activateMarket(address(baseToken));
        Markets(address(singleton.moduleIdToProxy(markets.moduleId()))).activateMarket(address(borrowToken));
        
        markets = Markets(address(singleton.moduleIdToProxy(markets.moduleId())));

        // SET IRM
        gov.setIRM(address(baseToken), (mockIRM.moduleId()), hex"");
        gov.setIRM(address(borrowToken), (mockIRM.moduleId()), hex"");

        // Then check for more coverage
        // SEtup the tokens ??
        // Setup the other market???
        // Deposit
        // Mint
        // donateToReserves
        // isLiquidatable

        // TODO: WRONG need to be set to the ones for the specific market
        dToken = DToken(markets.underlyingToDToken(address(borrowToken)));

       

        eToken = EToken(markets.underlyingToEToken(address(baseToken)));

        console2.log("riskManager", address(riskManager));
        // riskManager =  RiskManager(address(singleton.moduleIdToProxy(riskManager.moduleId())));
        console2.log("riskManager", address(riskManager));

        markets.enterMarket(subAccountId, address(baseToken));
        markets.enterMarket(subAccountId, address(borrowToken));

        // Seed some on a different account
        address someoneElse = address(0x1231231);

        vm.prank(someoneElse);
        markets.enterMarket(0, address(borrowToken));

        borrowToken.mint(someoneElse, 100_000e18);

        vm.prank(someoneElse);
        borrowToken.approve(address(singleton), type(uint256).max);
        
        vm.prank(someoneElse);
        EToken(markets.underlyingToEToken(address(borrowToken))).deposit(0, 100_000e18);
        console2.log("Setup Successful");
    }
}
