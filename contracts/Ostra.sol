// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


import './libraries/AppStorage.sol';


contract Ostra {
    AppStorage internal DS;

    function add(uint256 _0, uint256 _1) external {
        DS.result = _0 + _1;
    }

    function getRes() external view returns (uint256) {
        return DS.result;
    }
}