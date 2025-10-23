// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {RomanNumerals} from "../utils/strings/RomanNumerals.sol";

/// @title RomanSelfTest
/// @notice Simple harness to exercise subtractive branch (v1 < v2) in Roman parsing.
contract MockRomanSelf {
    /// @notice Returns parsed values for common subtractive pairs to ensure the
    ///         `if (v1 < v2)` path is executed inside fromRoman.
    /// @return iv 4
    /// @return ix 9
    /// @return xl 40
    /// @return xc 90
    /// @return cd 400
    /// @return cm 900
    function evalSubtractive()
        external
        pure
        returns (
            uint256 iv,
            uint256 ix,
            uint256 xl,
            uint256 xc,
            uint256 cd,
            uint256 cm
        )
    {
        iv = RomanNumerals.fromRoman("IV");
        ix = RomanNumerals.fromRoman("IX");
        xl = RomanNumerals.fromRoman("XL");
        xc = RomanNumerals.fromRoman("XC");
        cd = RomanNumerals.fromRoman("CD");
        cm = RomanNumerals.fromRoman("CM");
    }
}
