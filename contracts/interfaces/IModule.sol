// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


interface IUpdateModule {
    // Enums
    enum UpdateType {ADD, REPLACE, REMOVE}

    // Structs
    struct UpdateData {
        address moduleAddress;
        bytes4[] functionSelectors;
        UpdateType updateType;
    }

    // Events
    event ModuleUpdated(UpdateData[] _updateData, address _init, bytes _calldata);


    // Allows to add / replace / remove any number of functions
    // Can optionally execute a function with delegateCall
    //   - _updateData: Module address & function selectors
    //   - _init: Address of the module to execute _calldata
    //   - _calldata: Function call (function selector and args)
    function updateModule(
        UpdateData[] calldata _updateData,
        address _init,
        bytes calldata _calldata
    ) external;
}


interface IModuleExplorer {
    // Structs
    struct Module {
        address moduleAddress;
        bytes4[] functionSelectors;
    }


    // Gets all modules addresses and their four byte function selectors
    function modules() external view returns (Module[] memory _modules);


    // Gets all function selectors supported by a specific module
    function moduleFunctionSelectors(address _module) external view returns (bytes4[] memory _moduleFunctionSelectors);


    // Gets all the module addresses used by the contract
    function moduleAddresses() external view returns (address[] memory _moduleAddresses);


    // Gets the module that supports the given selector 
    function moduleAddress(bytes4 _functionSelectors) external view returns (address _moduleAddress);
}