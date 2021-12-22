// SPDX-License-Identifier: MIT


pragma solidity ^0.8.10;


import { IDiamondCut } from '../interfaces/IDiamondCut.sol';


library Diamond {
    // Constants
    bytes32 constant POS_DIAMOND_STORAGE = keccak256("diamond.map:storage");

    // Events
    event DiamondCut(IDiamondCut.FacetCut[] _diamondCut, address _init, bytes _calldata);

    // Structs
    struct FacetAddressAndSelectorPos {
        address facetAddress;
        uint16 selectorPos;
    }

    struct DiamondStorage {
        mapping(bytes4 => FacetAddressAndSelectorPos) FacetAddressAndSelectorPos;
        mapping(bytes4 => bool) supportedInterfaces;
        address contractOwner;
        bytes4[] selectors;
    }



    function diamondStorage() internal pure returns (DiamondStorage storage ds) {
        bytes32 pos = POS_DIAMOND_STORAGE;
        assembly { ds.slot := pos }
    }


    function enforceHasContractCode(address _contract, string memory _errorMsg) internal view {
        uint256 contractSize;

        assembly { contractSize := extcodesize(_contract) }
        require(contractSize > 0, _errorMsg);
    }


    function initializeDiamondCut(address _init, bytes memory _calldata) internal {
        if (_init == address(0)) {
            require(_calldata.length == 0, 'DIAMOND: _init is address(0) but _calldata is not empty');
        } else {
            require(_calldata.length > 0, 'DIAMOND: _calldata is empty but _init is not address(0)');

            if (_init != address(this)) {

            }
        }
    }


    function diamondCut(
        IDiamondCut.FacetCut[] memory _diamondCut,
        bytes memory _calldata,
        address _init
    ) internal {
        for (uint256 i; i < _diamondCut.length; i++) {
            IDiamondCut.CutAction action = _diamondCut[i].action;  // Get the current action

            if (action == IDiamondCut.CutAction.ADD) {
                // ADD

            } else if (action == IDiamondCut.CutAction.REPLACE) {
                // REPLACE

            } else if (action == IDiamondCut.CutAction.REMOVE) {
                // REMOVE

            } else {
                revert('DIAMOND: Incorrect Cut Action');
            }
        }

        emit DiamondCut(_diamondCut, _init, _calldata);
        initializeDiamondCut(_init, _calldata);
    }
}