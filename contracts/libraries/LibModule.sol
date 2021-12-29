// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


import { IUpdate } from "../interfaces/IModule.sol";


library LibModule {
    // Constants
    bytes32 constant MODULE_STORAGE_POINTER = keccak256("KECCAK_POINTER:module.storage");

    // Events
    event ModuleUpdated(IUpdate.UpdateData[] _updateData, address _init, bytes _calldata);

    // Structs
    struct ModuleData {
        address modAddress;
        uint16 selectorPos;
    }

    struct ModuleStorage {
        mapping(bytes4 => ModuleData) currentModule;
        mapping(bytes4 => bool) supportedInterfaces;
        bytes4[] selectors;
    }


    function moduleStorage() internal pure returns (ModuleStorage storage ds) {
        bytes32 pos = MODULE_STORAGE_POINTER;
        assembly { ds.slot := pos }
    }


    function enforceHasContractCode(address _contract, string memory _errorMsg) internal view {
        uint256 contractSize;
        assembly { contractSize := extcodesize(_contract) }
        require(contractSize > 0, _errorMsg);
    }


    function initUpdate(address _init, bytes memory _calldata) internal {
        if (_init == address(0)) {
            require(_calldata.length == 0, "[MOD_101] _init is address(0) but _calldata is not empty");
        } else {
            require(_calldata.length > 0, "[MOD_102] _calldata is empty but _init is not address(0)");

            if (_init != address(this)) {
                enforceHasContractCode(_init, "[MOD_103] _init address has no code");
            }

            (bool success, bytes memory error) = _init.delegatecall(_calldata);

            if (!success) {
                if (error.length > 0) {
                    revert(string(error));
                } else {
                    revert("[MOD_104] _init function reverted");
                }
            }
        }
    }


    function addFunctions(address _moduleAddress, bytes4[] memory _functionSelectors) internal {
        require(_functionSelectors.length > 0, "[MOD_201] Undefined selectors");
        require(_moduleAddress != address(0), "[MOD_202] Address(0) is not allowed");
        enforceHasContractCode(_moduleAddress, "[MOD_203] Undefined code");

        ModuleStorage storage DS = moduleStorage();
        uint16 counter = uint16(DS.selectors.length);

        for (uint256 i; i < _functionSelectors.length; i++) {
            bytes4 selector = _functionSelectors[i];
            address oldAddress = DS.currentModule[selector].modAddress;

            require(oldAddress == address(0), "[MOD_204] This function already exists");

            DS.currentModule[selector] = ModuleData(_moduleAddress, counter);
            DS.selectors.push(selector);
            counter++;
        }
    }


    function replaceFunctions(address _moduleAddress, bytes4[] memory _functionSelectors) internal {
        require(_functionSelectors.length > 0, "[MOD_201] Undefined selectors");
        require(_moduleAddress != address(0), "[MOD_202] Address(0) is not allowed");
        enforceHasContractCode(_moduleAddress, "[MOD_203] Undefined code");

        ModuleStorage storage DS = moduleStorage();

        for (uint256 i; i < _functionSelectors.length; i++) {
            bytes4 selector = _functionSelectors[i];
            address oldAddress = DS.currentModule[selector].modAddress;

            require(oldAddress != address(0), "[MOD_205] Undefined function");
            require(oldAddress != address(this), "[MOD_206] This function is immutable");
            require(oldAddress != _moduleAddress, "[MOD_207] Equal functions");

            DS.currentModule[selector].modAddress = _moduleAddress;
        }
    }


    function removeFunctions(address _moduleAddress, bytes4[] memory _functionSelectors) internal {
        require(_functionSelectors.length > 0, "[MOD_201] Undefined selectors");
        require(_moduleAddress != address(0), "[MOD_202] Address(0) is not allowed");
        enforceHasContractCode(_moduleAddress, "[MOD_203] Undefined code");

        ModuleStorage storage DS = moduleStorage();
        uint256 counter = DS.selectors.length;

        for (uint256 i; i < _functionSelectors.length; i++) {
            bytes4 selector = _functionSelectors[i];
            ModuleData memory previousModule = DS.currentModule[selector];

            require(previousModule.modAddress != address(0), "[MOD_205] Undefined function");
            require(previousModule.modAddress != address(this), "[MOD_206] This function is immutable");
            
            counter--;

            if (previousModule.selectorPos != counter) {
                bytes4 lastSelector = DS.selectors[counter];
                DS.selectors[previousModule.selectorPos] = lastSelector;
                DS.currentModule[lastSelector].selectorPos = previousModule.selectorPos;
            }

            DS.selectors.pop();
            delete DS.currentModule[selector];
        }
    }


    function updateModule(
        IUpdate.UpdateData[] memory _updateData,
        address _init,
        bytes memory _calldata
    ) internal {
        for (uint256 i; i < _updateData.length; i++) {
            IUpdate.UpdateMethod updateMethod = _updateData[i].updateMethod;

            if (updateMethod == IUpdate.UpdateMethod.ADD) {
                // ADD
                addFunctions(_updateData[i].modAddress, _updateData[i].funcSelectors);
            } else if (updateMethod == IUpdate.UpdateMethod.REPLACE) {
                // REPLACE
                replaceFunctions(_updateData[i].modAddress, _updateData[i].funcSelectors);
            } else if (updateMethod == IUpdate.UpdateMethod.REMOVE) {
                // REMOVE
                removeFunctions(_updateData[i].modAddress, _updateData[i].funcSelectors);
            } else {
                // INVALID UPDATE METHOD
                revert("[MOD_208] Invalid update method");
            }
        }

        emit ModuleUpdated(_updateData, _init, _calldata);
        initUpdate(_init, _calldata);
    }
}