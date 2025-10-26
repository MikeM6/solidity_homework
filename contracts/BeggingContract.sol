// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BeggingContract - simple donation vault with owner withdrawal
/// @notice Allows anyone to donate ETH, records per-donor totals, and lets the owner withdraw all funds.
/// @dev Includes optional extras: Donation event, top-3 leaderboard, and donation time window.
contract BeggingContract {
    // --- Storage ---
    address public owner;
    mapping(address => uint256) private _donations;
    address[] private _donors; // unique donors
    mapping(address => bool) private _seenDonor;

    // Optional donation window; if both are zero, donations are always open
    uint256 public startTime; // inclusive
    uint256 public endTime; // inclusive

    // --- Events (extra challenge) ---
    event Donation(address indexed donor, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);

    // --- Modifiers ---
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier withinWindow() {
        if (startTime != 0 || endTime != 0) {
            require(block.timestamp >= startTime, "Too early");
            require(block.timestamp <= endTime, "Too late");
        }
        _;
    }

    // --- Constructor ---
    constructor() {
        owner = msg.sender;
    }

    // --- Core Logic ---
    /// @notice Donate ETH to the contract; records your total donated amount.
    function donate() external payable withinWindow {
        require(msg.value > 0, "No ETH sent");

        // is the first time donate?
        if (!_seenDonor[msg.sender] && _donations[msg.sender] == 0) {
            _seenDonor[msg.sender] = true;
            _donors.push(msg.sender);
        }

        _donations[msg.sender] += msg.value;
        emit Donation(msg.sender, msg.value);
    }

    /// @notice Withdraw the entire contract balance to the owner.
    /// @dev Uses address.transfer per assignment; reverts on failure.
    function withdraw() external onlyOwner {
        uint256 bal = address(this).balance;
        require(bal > 0, "Nothing to withdraw");
        payable(owner).transfer(bal);
        emit Withdrawal(owner, bal);
    }

    /// @notice Get the total amount donated by an address.
    function getDonation(address account) external view returns (uint256) {
        return _donations[account];
    }

    // --- Convenience: also accept plain ETH sends ---
    receive() external payable {
        // Treat plain sends as donate()
        if (!_seenDonor[msg.sender] && _donations[msg.sender] == 0) {
            _seenDonor[msg.sender] = true;
            _donors.push(msg.sender);
        }

        _donations[msg.sender] += msg.value;
        emit Donation(msg.sender, msg.value);
    }

    // --- Optional extras ---
    /// @notice Set a donation time window (inclusive). Set both to 0 to disable.
    // inout : unix time stamps
    function setDonationWindow(uint256 start, uint256 end) external onlyOwner {
        require(end == 0 || end >= start, "Invalid window");
        startTime = start;
        endTime = end;
    }

    /// @notice Return up to top 3 donors by amount, in descending order.
    /// @dev O(n) scan; fine for small n. Ties keep first-seen order among equals.
    function topDonors()
        external
        view
        returns (address[] memory addrs, uint256[] memory amounts)
    {
        uint256 n = _donors.length;
        uint256 k = n < 3 ? n : 3;
        addrs = new address[](k);
        amounts = new uint256[](k);

        address a1;
        address a2;
        address a3;
        uint256 v1;
        uint256 v2;
        uint256 v3;

        for (uint256 i = 0; i < n; i++) {
            address d = _donors[i];
            uint256 v = _donations[d];
            if (v > v1) {
                // shift down
                v3 = v2;
                a3 = a2;
                v2 = v1;
                a2 = a1;
                v1 = v;
                a1 = d;
            } else if (d != a1 && v > v2) {
                v3 = v2;
                a3 = a2;
                v2 = v;
                a2 = d;
            } else if (d != a1 && d != a2 && v > v3) {
                v3 = v;
                a3 = d;
            }
        }

        if (k > 0) {
            addrs[0] = a1;
            amounts[0] = v1;
        }
        if (k > 1) {
            addrs[1] = a2;
            amounts[1] = v2;
        }
        if (k > 2) {
            addrs[2] = a3;
            amounts[2] = v3;
        }
    }
}
