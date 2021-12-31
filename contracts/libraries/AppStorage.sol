// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


struct AppStorage {
    uint256 firstVar;
    uint256 secondVar;
    uint256 result;
}

struct Rules {
  bytes32 rule_00 = "Hate speech";
  bytes32 rule_01 = "NSFW";
  bytes32 rule_02 = "Spam";
  bytes32 rule_03 = "Scam";
  bytes32 rule_04 = "Please be civil";
}