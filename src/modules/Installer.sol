// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity ^0.8.0;

import "../BaseModule.sol";
import {console2} from "forge-std/console2.sol";

contract Installer is BaseModule {
    constructor(bytes32 moduleGitCommit_) BaseModule(MODULEID__INSTALLER, moduleGitCommit_) {}

    modifier adminOnly {
        address msgSender = unpackTrailingParamMsgSender();
        require(msgSender == upgradeAdmin, "e/installer/unauthorized");
        _;
    }

    function getUpgradeAdmin() external view returns (address) {
        return upgradeAdmin;
    }

    function setUpgradeAdmin(address newUpgradeAdmin) external nonReentrant adminOnly {
        require(newUpgradeAdmin != address(0), "e/installer/bad-admin-addr");
        upgradeAdmin = newUpgradeAdmin;
        emit InstallerSetUpgradeAdmin(newUpgradeAdmin);
    }

    function setGovernorAdmin(address newGovernorAdmin) external nonReentrant adminOnly {
        require(newGovernorAdmin != address(0), "e/installer/bad-gov-addr");
        governorAdmin = newGovernorAdmin;
        emit InstallerSetGovernorAdmin(newGovernorAdmin);
    }

    function installModules(address[] memory moduleAddrs) external nonReentrant adminOnly {
        console2.log("installModules 0");
        for (uint i = 0; i < moduleAddrs.length; ++i) {
            address moduleAddr = moduleAddrs[i];
            uint newModuleId = BaseModule(moduleAddr).moduleId();
            bytes32 moduleGitCommit = BaseModule(moduleAddr).moduleGitCommit();

            moduleLookup[newModuleId] = moduleAddr;
            console2.log("installModules");

            if (newModuleId <= MAX_EXTERNAL_SINGLE_PROXY_MODULEID) {
                console2.log("wtf");
                console2.log("newModuleId", newModuleId);
                address proxyAddr = _createProxy(newModuleId);
                console2.log("proxyAddr in install");
                trustedSenders[proxyAddr].moduleImpl = moduleAddr;
                console2.log("set some storage");
            }

            emit InstallerInstallModule(newModuleId, moduleAddr, moduleGitCommit);
            console2.log("InstallerInstallModule");
        }
    }
}
