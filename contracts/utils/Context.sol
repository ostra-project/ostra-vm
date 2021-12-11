// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (contracts/utils/Context.sol)
// MODIFIED VERSION

pragma solidity ^0.8.10;


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
// 'msg.sender'         -> 'payable(msg.sender)'
// 'bytes calldata'     -> 'bytes memory'
// 'this;'              -> Silence state mutability warning without generating bytecode (https://github.com/ethereum/solidity/issues/2691)

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}
