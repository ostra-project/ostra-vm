// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


import { LibModule } from '../libraries/LibModule.sol';
import { IModuleExplorer } from '../interfaces/IModule.sol';


contract __ModuleExplorer is IModuleExplorer {
    // Gets all modules addresses and their four byte function selectors
    function modules() external view override returns (Module[] memory _modules) {
        LibModule.ModuleStorage storage DS = LibModule.moduleStorage();
        uint256 counter = DS.selectors.length;

        _modules = new Module[](counter);
        uint8[] memory numModuleSelectors = new uint8[](counter);
        uint256 numModules;

        for (uint256 i; i < counter; i++) {
            bytes4 selector = DS.selectors[i];
            address _moduleAddress = DS.currentModule[selector].moduleAddress;
            bool continueLoop = false;

            for (uint256 j; j < numModules; j++) {
                if (_modules[j].moduleAddress == _moduleAddress) {
                    _modules[j].functionSelectors[numModuleSelectors[j]] = selector;

                    require(numModuleSelectors[j] < 255);

                    numModuleSelectors[j]++;
                    continueLoop = true;
                    break;
                }
            }

            if (continueLoop) {
                continueLoop = false;
                continue;
            }

            _modules[numModules].moduleAddress = _moduleAddress;
            _modules[numModules].functionSelectors = new bytes4[](counter);
            _modules[numModules].functionSelectors[0] = selector;

            numModuleSelectors[numModules] = 1;
            numModules++;
        }

        for (uint256 j; j < numModules; j++) {
            uint256 numSelectors = numModuleSelectors[j];
            bytes4[] memory selectors = _modules[j].functionSelectors;

            assembly { mstore(selectors, numSelectors) }
        }
        
        assembly { mstore(_modules, numModules) }
    }


    // Gets all function selectors supported by a specific module
    function moduleFunctionSelectors(address _module) external view override returns (bytes4[] memory _moduleFunctionSelectors) {

    }


    // Gets all the module addresses used by the contract
    function moduleAddresses() external view override returns (address[] memory _moduleAddresses) {

    }


    // Gets the module that supports the given selector 
    function moduleAddress(bytes4 _functionSelectors) external view override returns (address _moduleAddress) {

    }
}