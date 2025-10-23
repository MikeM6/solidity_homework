// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {SortedArrays} from "../utils/arrays/SortedArrays.sol";

/// @title MergeSortedArrays (Demo)
/// @notice 合并两个有序数组（升序），返回合并后的有序数组。
/// @dev For quick testing in Remix/Hardhat/Foundry.
contract MergeSortedArraysDemo {
    /// @notice 合并两个升序的 uint 数组。
    /// @param a 升序数组 A
    /// @param b 升序数组 B
    /// @return 合并后的升序数组
    function mergeUint(
        uint256[] calldata a,
        uint256[] calldata b
    ) external pure returns (uint256[] memory) {
        return SortedArrays.mergeCalldata(a, b);
    }
}
