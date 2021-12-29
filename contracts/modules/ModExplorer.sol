// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


import { LibModule } from '../libraries/LibModule.sol';
import { IExplorer } from '../interfaces/IModule.sol';


contract ModExplorer is IExplorer {
    // Gets all modules addresses and their four byte function selectors
    function modules() external view override returns (ModuleData[] memory _modules) {
        LibModule.ModuleStorage storage DS = LibModule.moduleStorage();
        uint256 counter = DS.selectors.length;

        _modules = new ModuleData[](counter);
        uint8[] memory numModuleSelectors = new uint8[](counter);
        uint256 numModules;

        for (uint256 i; i < counter; i++) {
            bytes4 selector = DS.selectors[i];
            address _moduleAddress = DS.currentModule[selector].modAddress;
            bool continueLoop = false;

            for (uint256 j; j < numModules; j++) {
                if (_modules[j].modAddress == _moduleAddress) {
                    _modules[j].funcSelectors[numModuleSelectors[j]] = selector;

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

            _modules[numModules].modAddress = _moduleAddress;
            _modules[numModules].funcSelectors = new bytes4[](counter);
            _modules[numModules].funcSelectors[0] = selector;

            numModuleSelectors[numModules] = 1;
            numModules++;
        }

        for (uint256 j; j < numModules; j++) {
            uint256 numSelectors = numModuleSelectors[j];
            bytes4[] memory selectors = _modules[j].funcSelectors;

            assembly { mstore(selectors, numSelectors) }
        }
        
        assembly { mstore(_modules, numModules) }
    }


    // Gets all function selectors supported by a specific module
    function moduleFunctionSelectors(address _module) external view override returns (bytes4[] memory _moduleFunctionSelectors) {
        LibModule.ModuleStorage storage DS = LibModule.moduleStorage();
        uint256 counter = DS.selectors.length;
        uint256 numSelectors;
        _moduleFunctionSelectors = new bytes4[](counter);

        for (uint256 i; i < counter; i++) {
            bytes4 selector = DS.selectors[i];
            address _moduleAddress = DS.currentModule[selector].modAddress;

            if (_module == _moduleAddress) {
                _moduleFunctionSelectors[numSelectors] = selector;
                numSelectors++;
            }
        }

        assembly { mstore(_moduleFunctionSelectors, numSelectors) }
    }


    // Gets all the module addresses used by the contract
    function moduleAddresses() external view override returns (address[] memory _moduleAddresses) {
        LibModule.ModuleStorage storage DS = LibModule.moduleStorage();
        uint256 counter = DS.selectors.length;

        _moduleAddresses = new address[](counter);
        uint256 numModules;

        for (uint256 i; i < counter; i++) {
            bytes4 selector = DS.selectors[i];
            address _moduleAddress = DS.currentModule[selector].modAddress;
            bool continueLoop = false;

            for (uint256 j; j < numModules; j++) {
                if (_moduleAddress == _moduleAddresses[j]) {
                    continueLoop = true;
                    break;
                }
            }

            if (continueLoop) {
                continueLoop = false;
                continue;
            }

            _moduleAddresses[numModules] = _moduleAddress;
            numModules++;
        }

        assembly { mstore(_moduleAddresses, numModules) }
    }


    // Gets the module that supports the given selector 
    function moduleAddress(bytes4 _functionSelectors) external view override returns (address _moduleAddress) {
        LibModule.ModuleStorage storage DS = LibModule.moduleStorage();
        return DS.currentModule[_functionSelectors].modAddress;
    }
}