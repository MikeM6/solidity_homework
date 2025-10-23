// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {SortedArrays} from "../utils/arrays/SortedArrays.sol";

/// @title BinarySearchDemo
/// @notice 二分查找（升序数组）示例。返回是否找到以及索引/插入点。
contract BinarySearchDemo {
    /// @param a 升序数组（例如 [1,3,5,7]）
    /// @param target 目标值（例如 5）
    /// @return found 是否找到
    /// @return index 如果找到，返回索引；否则返回插入点位置
    function searchUint(
        uint256[] calldata a,
        uint256 target
    ) external pure returns (bool found, uint256 index) {
        return SortedArrays.binarySearchCalldata(a, target);
    }
}

