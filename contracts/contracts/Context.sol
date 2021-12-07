// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
// MODIFIED IBEP20 VERSION BY ZEPP (https://github.com/ethereum/solidity/issues/2691)

pragma solidity ^0.8.2;


/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */

// Modifications:
// 'address'            -> 'address payable'
// 'bytes calldata'     -> 'bytes memory'
// 'this;'              -> Silence state mutability warning without generating bytecode

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}
