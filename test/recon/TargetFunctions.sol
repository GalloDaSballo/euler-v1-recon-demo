
// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import {Properties} from "./Properties.sol";
import {vm} from "@chimera/Hevm.sol";

import "src/modules/DToken.sol";
import "src/modules/EToken.sol";

abstract contract TargetFunctions is BaseTargetFunctions, Properties, BeforeAfter {

  function crytic_solvent() public returns (bool) {
    if(!_before.isLiquidatable) {
      return _after.isLiquidatable == false;
    }
    return true;
  }

    function eToken_approve(address spender, uint256 amount) public withChecks {
      eToken.approve(spender, amount);
    }

    function eToken_approveSubAccount( address spender, uint256 amount) public withChecks {
      eToken.approveSubAccount(subAccountId, spender, amount);
    }

    function eToken_burn( uint256 amount) public withChecks {
      eToken.burn(subAccountId, amount);
    }

    function eToken_deposit( uint256 amount) public withChecks {
      eToken.deposit(subAccountId, amount);
    }

    function eToken_donateToReserves( uint256 amount) public withChecks {
      eToken.donateToReserves(subAccountId, amount);
    }

    function eToken_mint( uint256 amount) public withChecks {
      eToken.mint(subAccountId, amount);
    }

    function eToken_touch() public withChecks {
      eToken.touch();
    }

    function eToken_transfer(address to, uint256 amount) public withChecks {
      eToken.transfer(to, amount);
    }

    function eToken_transferFrom(address from, address to, uint256 amount) public withChecks {
      eToken.transferFrom(from, to, amount);
    }

    function eToken_transferFromMax(address from, address to) public withChecks {
      eToken.transferFromMax(from, to);
    }

    function eToken_withdraw( uint256 amount) public withChecks {
      eToken.withdraw(subAccountId, amount);
    }

    function dToken_approveDebt( address spender, uint256 amount) public withChecks {
      dToken.approveDebt(subAccountId, spender, amount);
    }

    function dToken_borrow( uint256 amount) public withChecks {
      dToken.borrow(subAccountId, amount);
    }

    function dToken_flashLoan(uint256 amount, bytes calldata data) public withChecks {
      dToken.flashLoan(amount, data);
    }

    function dToken_repay( uint256 amount) public withChecks {
      dToken.repay(subAccountId, amount);
    }

    function dToken_transfer(address to, uint256 amount) public withChecks {
      dToken.transfer(to, amount);
    }

    function dToken_transferFrom(address from, address to, uint256 amount) public withChecks {
      dToken.transferFrom(address(this), to, amount);
    }
}