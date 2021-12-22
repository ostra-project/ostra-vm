// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


interface IDiamondCut {
    // Events
    event DiamondCut(FacetCut[] _diamondCut, address _init, bytes _calldata);

    // Enums
    enum CutAction {ADD, REPLACE, REMOVE}

    // Structs
    struct FacetCut {
        address currentFacet;
        bytes4[] functionSelectors;
        CutAction action;
    }


    // Allows to add / replace / remove any number of functions
    // Can optionally execute a function with delegateCall
    //   - _diamondCut: Facet addresses & function selectors
    //   - _calldata: Function call (function pointer and args)
    //   - _init: Address of the facet to execute _calldata
    function diamondCut(
        FacetCut[] calldata _diamondCut,
        bytes calldata _calldata,
        address _init
    ) external;
}