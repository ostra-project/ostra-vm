// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


import { LibModule } from '../libraries/LibModule.sol';
import { IUpdate } from '../interfaces/IModule.sol';


contract ModUpdate is IUpdate {
    // Allows to add / replace / remove any number of functions
    // Can optionally execute a function with delegateCall
    //   - _updateData: Module address & function selectors
    //   - _init: Address of the module to execute _calldata
    //   - _calldata: Function call (function selector and args)
    function updateModule(
        UpdateData[] calldata _updateData,
        address _init,
        bytes calldata _calldata
    ) external override {
        LibModule.updateModule(_updateData, _init, _calldata);
    }
}