// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


import { LibModule } from './libraries/LibModule.sol';
import { IUpdate, IExplorer } from './interfaces/IModule.sol';


contract InitOstra {   
    function init() external {
        LibModule.ModuleStorage storage DS = LibModule.moduleStorage();

        DS.supportedInterfaces[type(IUpdate).interfaceId] = true;
        DS.supportedInterfaces[type(IExplorer).interfaceId] = true;
    }
}