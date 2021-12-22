// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


import { IUpdateModule } from '../interfaces/IModule.sol';


library LibModule {
    // Constants
    bytes32 constant MODULE_STORAGE_POINTER = keccak256("KECCAK_POINTER:module.storage");

    // Events
    event ModuleUpdated(IUpdateModule.UpdateData[] _updateData, address _init, bytes _calldata);

    // Structs
    struct ModuleData {
        address moduleAddress;
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


    function initUpdateModule(address _init, bytes memory _calldata) internal {
        if (_init == address(0)) {
            require(_calldata.length == 0, 'MODULE: _init is address(0) but _calldata is not empty');
        } else {
            require(_calldata.length > 0, 'MODULE: _calldata is empty but _init is not address(0)');

            if (_init != address(this)) {
                enforceHasContractCode(_init, 'MODULE: _init address has no code');
            }

            (bool success, bytes memory error) = _init.delegatecall(_calldata);

            if (!success) {
                if (error.length > 0) {
                    revert(string(error));
                } else {
                    revert('MODULE: _init function reverted');
                }
            }
        }
    }


    function addFunctions(address _moduleAddress, bytes4[] memory _functionSelectors) internal {
        require(_functionSelectors.length > 0, 'MODULE: Selectors not found');
        require(_moduleAddress != address(0), 'MODULE: Address(0) is not allowed');
        enforceHasContractCode(_moduleAddress, 'MODULE: Code not found');

        ModuleStorage storage DS = moduleStorage();
        uint16 counter = uint16(DS.selectors.length);

        for (uint256 i; i < _functionSelectors.length; i++) {
            bytes4 selector = _functionSelectors[i];
            address oldAddress = DS.currentModule[selector].moduleAddress;

            require(oldAddress == address(0), 'MODULE: Function already exists');

            DS.currentModule[selector] = ModuleData(_moduleAddress, counter);
            DS.selectors.push(selector);
            counter++;
        }
    }


    function replaceFunctions(address _moduleAddress, bytes4[] memory _functionSelectors) internal {
        require(_functionSelectors.length > 0, 'MODULE: Selectors not found');
        require(_moduleAddress != address(0), 'MODULE: Address(0) is not allowed');
        enforceHasContractCode(_moduleAddress, 'MODULE: Code not found');

        ModuleStorage storage DS = moduleStorage();

        for (uint256 i; i < _functionSelectors.length; i++) {
            bytes4 selector = _functionSelectors[i];
            address oldAddress = DS.currentModule[selector].moduleAddress;

            require(oldAddress != address(0), 'MODULE: Function not found');
            require(oldAddress != address(this), 'MODULE: Function is immutable');
            require(oldAddress != _moduleAddress, 'MODULE: Same function');

            DS.currentModule[selector].moduleAddress = _moduleAddress;
        }
    }


    function removeFunctions(address _moduleAddress, bytes4[] memory _functionSelectors) internal {
        require(_functionSelectors.length > 0, 'MODULE: Selectors not found');
        require(_moduleAddress != address(0), 'MODULE: Address(0) is not allowed');
        enforceHasContractCode(_moduleAddress, 'MODULE: Code not found');

        ModuleStorage storage DS = moduleStorage();
        uint256 counter = DS.selectors.length;

        for (uint256 i; i < _functionSelectors.length; i++) {
            bytes4 selector = _functionSelectors[i];
            ModuleData memory previousModule = DS.currentModule[selector];

            require(previousModule.moduleAddress != address(0), 'MODULE: Function not found');
            require(previousModule.moduleAddress != address(this), 'MODULE: Function is immutable');
            
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
        IUpdateModule.UpdateData[] memory _updateData,
        address _init,
        bytes memory _calldata
    ) internal {
        for (uint256 i; i < _updateData.length; i++) {
            IUpdateModule.UpdateType updateType = _updateData[i].updateType;

            if (updateType == IUpdateModule.UpdateType.ADD) {
                // ADD
                addFunctions(_updateData[i].moduleAddress, _updateData[i].functionSelectors);
            } else if (updateType == IUpdateModule.UpdateType.REPLACE) {
                // REPLACE
                replaceFunctions(_updateData[i].moduleAddress, _updateData[i].functionSelectors);
            } else if (updateType == IUpdateModule.UpdateType.REMOVE) {
                // REMOVE
                removeFunctions(_updateData[i].moduleAddress, _updateData[i].functionSelectors);
            } else {
                // INVALID UPDATE TYPE
                revert('MODULE: Invalid Update Type');
            }
        }

        emit ModuleUpdated(_updateData, _init, _calldata);
        initUpdateModule(_init, _calldata);
    }
}