// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Utilities for working with strings.
/// @dev This implementation treats the input as raw bytes and reverses byte-by-byte.
///      It works for ASCII strings like "abcde" -> "edcba". For general UTF-8 with
///      multi-byte code points, a rune-aware approach is required.
library StringUtils {
    function reverse(string memory input) internal pure returns (string memory) {
        bytes memory s = bytes(input);
        uint256 len = s.length;
        bytes memory out = new bytes(len);
        for (uint256 i = 0; i < len; i++) {
            out[i] = s[len - 1 - i];
        }
        return string(out);
    }
}

