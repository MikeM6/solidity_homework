// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Voting
/// @notice Simple voting contract with add-on-demand candidates and full reset.
contract Voting {
    // candidate name => votes count
    mapping(string => uint256) private _votes;
    // track if a candidate has been seen to maintain the list
    mapping(string => bool) private _known;
    // list of all candidates that have ever received a vote
    string[] private _candidates;

    event Voted(string indexed candidate, address indexed voter, uint256 newCount);
    event Reset();

    /// @notice Vote for a candidate by name. Adds candidate on first vote.
    /// @param candidate The candidate name (case-sensitive)
    function vote(string calldata candidate) external {
        if (!_known[candidate]) {
            _known[candidate] = true;
            _candidates.push(candidate);
        }
        unchecked { _votes[candidate] += 1; }
        emit Voted(candidate, msg.sender, _votes[candidate]);
    }

    /// @notice Get votes for a candidate.
    function getVotes(string calldata candidate) external view returns (uint256) {
        return _votes[candidate];
    }

    /// @notice Reset all candidates' votes and clear the candidate list.
    /// @dev Anyone can call for simplicity as per assignment spec.
    function resetVotes() external {
        uint256 n = _candidates.length;
        for (uint256 i = 0; i < n; i++) {
            string memory name_ = _candidates[i];
            _votes[name_] = 0;
            _known[name_] = false;
        }
        delete _candidates;
        emit Reset();
    }
}

