// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


import { LibModule } from './libraries/LibModule.sol';
import { IUpdate } from './interfaces/IModule.sol';


contract Ostra {
    constructor(address _updateModuleAddress) payable {
        IUpdate.UpdateData[] memory updateData = new IUpdate.UpdateData[](1);
        bytes4[] memory functionSelectors = new bytes4[](1);

        functionSelectors[0] = IUpdate.updateModule.selector;

        updateData[0] = IUpdate.UpdateData({
            modAddress: _updateModuleAddress,
            funcSelectors: functionSelectors,
            updateMethod: IUpdate.UpdateMethod.ADD
        });

        LibModule.updateModule(updateData, address(0), '');
    }


    fallback() external payable {
        LibModule.ModuleStorage storage DS;
        bytes32 pos = LibModule.MODULE_STORAGE_POINTER;
        assembly { DS.slot := pos }

        address module = DS.currentModule[msg.sig].modAddress;
        require(module != address(0), 'MODULE: Function not found');

        assembly {
            calldatacopy(0, 0, calldatasize())
            let res := delegatecall(gas(), module, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())

            switch res
                case 0 {
                    revert(0, returndatasize())
                }
                default {
                    return (0, returndatasize())
                }
        }
    }


    receive() external payable {}
}