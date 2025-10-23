// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SortedArrays
/// @notice Utilities for merging sorted arrays (ascending).
library SortedArrays {
    /// @notice Merge two ascending-sorted arrays of uint256 into a new ascending array.
    /// @dev Stable for equal elements (keeps order from inputs). O(n+m) time, O(n+m) space.
    function merge(
        uint256[] memory a,
        uint256[] memory b
    ) internal pure returns (uint256[] memory out) {
        uint256 al = a.length;
        uint256 bl = b.length;
        out = new uint256[](al + bl);

        uint256 i;
        uint256 j;
        uint256 k;

        while (i < al && j < bl) {
            if (a[i] <= b[j]) {
                out[k] = a[i];
                unchecked {
                    i++;
                    k++;
                }
            } else {
                out[k] = b[j];
                unchecked {
                    j++;
                    k++;
                }
            }
        }
        while (i < al) {
            out[k] = a[i];
            unchecked {
                i++;
                k++;
            }
        }
        while (j < bl) {
            out[k] = b[j];
            unchecked {
                j++;
                k++;
            }
        }
    }

    /// @notice Merge two ascending-sorted calldata arrays of uint256.
    function mergeCalldata(
        uint256[] calldata a,
        uint256[] calldata b
    ) internal pure returns (uint256[] memory out) {
        uint256 al = a.length;
        uint256 bl = b.length;
        out = new uint256[](al + bl);

        uint256 i;
        uint256 j;
        uint256 k;

        while (i < al && j < bl) {
            if (a[i] <= b[j]) {
                out[k] = a[i];
                unchecked {
                    i++;
                    k++;
                }
            } else {
                out[k] = b[j];
                unchecked {
                    j++;
                    k++;
                }
            }
        }
        while (i < al) {
            out[k] = a[i];
            unchecked {
                i++;
                k++;
            }
        }
        while (j < bl) {
            out[k] = b[j];
            unchecked {
                j++;
                k++;
            }
        }
    }

    /// @notice Binary search in an ascending-sorted memory array.
    /// @dev Returns (found, index). If not found, index is the insertion point.
    function binarySearch(
        uint256[] memory a,
        uint256 target
    ) internal pure returns (bool found, uint256 index) {
        uint256 left = 0;
        uint256 right = a.length; // half-open interval [left, right)
        while (left < right) {
            uint256 mid = (left + right) >> 1; // floor((l+r)/2)
            uint256 v = a[mid];
            if (v < target) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }
        if (left < a.length && a[left] == target) {
            return (true, left);
        }
        return (false, left); // insertion point
    }

    /// @notice Binary search in an ascending-sorted calldata array.
    /// @dev Returns (found, index). If not found, index is the insertion point.
    function binarySearchCalldata(
        uint256[] calldata a,
        uint256 target
    ) internal pure returns (bool found, uint256 index) {
        uint256 left = 0;
        uint256 right = a.length; // half-open interval [left, right)
        while (left < right) {
            uint256 mid = (left + right) >> 1;
            uint256 v = a[mid];
            if (v < target) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }
        if (left < a.length && a[left] == target) {
            return (true, left);
        }
        return (false, left);
    }
}
