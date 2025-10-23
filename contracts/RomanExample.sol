// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {RomanNumerals} from "../utils/strings/RomanNumerals.sol";

/// @title RomanExample
/// @notice Exposes integer-to-Roman conversion for easy testing.
contract RomanExample {
    using RomanNumerals for uint256;
    
    /// @notice Parse a canonical Roman numeral to integer (1..3999)
    function romanToInt(string calldata s) external pure returns (uint256) {
        return RomanNumerals.fromRoman(s);
    }

    /// @dev Reverts with RomanNumerals.OutOfRange for values <1 or >3999
    function intToRoman(uint256 value) external pure returns (string memory) {
        return value.toRoman();
    }
}

