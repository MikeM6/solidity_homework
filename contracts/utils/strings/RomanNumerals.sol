// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library RomanNumerals {
    error OutOfRange(); // Valid range: 1..3999
    error InvalidChar(bytes1 ch);
    error InvalidSubtract(uint16 small, uint16 large);
    error NonCanonical();

    /// @notice Convert an integer in [1, 3999] to a Roman numeral string.
    function toRoman(uint256 num) internal pure returns (string memory) {
        if (num == 0 || num > 3999) revert OutOfRange();

        uint16[13] memory values = [
            uint16(1000),
            900,
            500,
            400,
            100,
            90,
            50,
            40,
            10,
            9,
            5,
            4,
            1
        ];
        string[13] memory symbols = [
            string("M"), //1000
            string("CM"), //900
            string("D"), //500
            string("CD"), //400
            string("C"), //100
            string("XC"), //90
            string("L"), //50
            string("XL"), //40
            string("X"), //10
            string("IX"), //9
            string("V"), //5
            string("IV"), //4
            string("I") //1
        ];

        bytes memory out;
        unchecked {
            for (uint256 i = 0; i < 13; i++) {
                while (num >= values[i]) {
                    num -= values[i];
                    out = abi.encodePacked(out, symbols[i]);
                }
                if (num == 0) break;
            }
        }
        return string(out);
    }

    /// @notice Parse a Roman numeral string to an integer in [1, 3999].
    /// @dev Reverts if contains invalid characters or non-canonical form.
    function fromRoman(string memory roman) internal pure returns (uint256) {
        bytes memory s = bytes(roman);
        uint256 len = s.length;
        uint256 i = 0;
        uint256 total = 0;

        while (i < len) {
            uint16 v1 = _value(s[i]);
            if (i + 1 < len) {
                uint16 v2 = _value(s[i + 1]);
                if (v1 < v2) {
                    if (!_isValidSubtractive(v1, v2))
                        revert InvalidSubtract(v1, v2);
                    total += (v2 - v1);
                    i += 2;
                    continue;
                }
            }
            total += v1;
            unchecked {
                i++;
            }
        }

        if (total == 0 || total > 3999) revert OutOfRange();

        // Enforce canonical Roman numeral by round-tripping
        // (e.g., "IIII" parses but is not canonical; should be "IV").
        if (keccak256(bytes(toRoman(total))) != keccak256(s))
            revert NonCanonical();

        return total;
    }

    function _value(bytes1 ch) private pure returns (uint16) {
        if (ch == "I") return 1; // 'I'
        if (ch == "V") return 5; // 'V'
        if (ch == "X") return 10; // 'X'
        if (ch == "L") return 50; // 'L'
        if (ch == "C") return 100; // 'C'
        if (ch == "D") return 500; // 'D'
        if (ch == "M") return 1000; // 'M'
        revert InvalidChar(ch);
    }

    function _isValidSubtractive(
        uint16 a,
        uint16 b
    ) private pure returns (bool) {
        // Only I before V or X; X before L or C; C before D or M
        if (a == 1 && (b == 5 || b == 10)) return true;
        if (a == 10 && (b == 50 || b == 100)) return true;
        if (a == 100 && (b == 500 || b == 1000)) return true;
        return false;
    }
}

