
// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import {Properties} from "./Properties.sol";
import {vm} from "@chimera/Hevm.sol";

import "src/modules/DToken.sol";
import "src/modules/EToken.sol";

abstract contract TargetFunctions is BaseTargetFunctions, Properties, BeforeAfter {

    function eToken_approve(address spender, uint256 amount) public {
      EToken(address(singleton)).approve(spender, amount);
    }

    function eToken_approveSubAccount(uint256 subAccountId, address spender, uint256 amount) public {
      EToken(address(singleton)).approveSubAccount(subAccountId, spender, amount);
    }

    function eToken_burn(uint256 subAccountId, uint256 amount) public {
      EToken(address(singleton)).burn(subAccountId, amount);
    }

    function eToken_deposit(uint256 subAccountId, uint256 amount) public {
      EToken(address(singleton)).deposit(subAccountId, amount);
    }

    function eToken_donateToReserves(uint256 subAccountId, uint256 amount) public {
      EToken(address(singleton)).donateToReserves(subAccountId, amount);
    }

    function eToken_mint(uint256 subAccountId, uint256 amount) public {
      EToken(address(singleton)).mint(subAccountId, amount);
    }

    function eToken_touch() public {
      EToken(address(singleton)).touch();
    }

    function eToken_transfer(address to, uint256 amount) public {
      EToken(address(singleton)).transfer(to, amount);
    }

    function eToken_transferFrom(address from, address to, uint256 amount) public {
      EToken(address(singleton)).transferFrom(from, to, amount);
    }

    function eToken_transferFromMax(address from, address to) public {
      EToken(address(singleton)).transferFromMax(from, to);
    }

    function eToken_withdraw(uint256 subAccountId, uint256 amount) public {
      EToken(address(singleton)).withdraw(subAccountId, amount);
    }

    function dToken_approveDebt(uint256 subAccountId, address spender, uint256 amount) public {
      DToken(address(singleton)).approveDebt(subAccountId, spender, amount);
    }

    function dToken_borrow(uint256 subAccountId, uint256 amount) public {
      DToken(address(singleton)).borrow(subAccountId, amount);
    }

    function dToken_flashLoan(uint256 amount, bytes calldata data) public {
      DToken(address(singleton)).flashLoan(amount, data);
    }

    function dToken_repay(uint256 subAccountId, uint256 amount) public {
      DToken(address(singleton)).repay(subAccountId, amount);
    }

    function dToken_transfer(address to, uint256 amount) public {
      DToken(address(singleton)).transfer(to, amount);
    }

    function dToken_transferFrom(address from, address to, uint256 amount) public {
      DToken(address(singleton)).transferFrom(from, to, amount);
    }
}