// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {StringUtils} from "../utils/strings/StringUtils.sol";

/// @title StringReverser
/// @notice Example contract exposing a reverse string function.
contract StringReverser {
    /// @notice Reverse a string. Example: "abcde" -> "edcba".
    /// @dev ASCII-safe (byte-wise). For multi-byte UTF-8, use a rune-aware method.
    function reverseString(
        string memory input
    ) external pure returns (string memory) {
        return StringUtils.reverse(input);
    }
}

