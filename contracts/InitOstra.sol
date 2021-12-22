// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


import { LibModule } from './libraries/LibModule.sol';
import { IUpdateModule } from './interfaces/IModule.sol';


contract initOstra {   
    function init() external {
        LibModule.ModuleStorage storage DS = LibModule.moduleStorage();

        DS.supportedInterfaces[type(IUpdateModule).interfaceId] = true;
    }
}