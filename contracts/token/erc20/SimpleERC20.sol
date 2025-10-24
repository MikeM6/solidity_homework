// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "contracts/interfaces/IERC20.sol";

/// @title SimpleERC20
/// @notice Minimal ERC20 implementation with owner-only minting.
contract SimpleERC20 is IERC20 {
    // Token metadata
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    // ERC20 storage
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // Ownership
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        owner = msg.sender;
    }

    // --- ERC20 metadata ---
    function name() external view returns (string memory) { return _name; }
    function symbol() external view returns (string memory) { return _symbol; }
    function decimals() external view returns (uint8) { return _decimals; }

    // --- ERC20 supply/balances ---
    function totalSupply() external view override returns (uint256) { return _totalSupply; }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    // --- ERC20 actions ---
    function transfer(address to, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address owner_, address spender) external view override returns (uint256) {
        return _allowances[owner_][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external override returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        require(currentAllowance >= amount, "ERC20: insufficient allowance");
        // Save gas for unlimited allowance pattern
        if (currentAllowance != type(uint256).max) {
            unchecked { _allowances[from][msg.sender] = currentAllowance - amount; }
            emit Approval(from, msg.sender, _allowances[from][msg.sender]);
        }
        _transfer(from, to, amount);
        return true;
    }

    // --- Minting ---
    /// @notice Mint `amount` tokens to `to`. Only owner can mint.
    function mint(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "ERC20: mint to zero");
        _totalSupply += amount;
        unchecked { _balances[to] += amount; }
        emit Transfer(address(0), to, amount);
    }

    // --- Internal helpers ---
    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "ERC20: transfer from zero");
        require(to != address(0), "ERC20: transfer to zero");
        uint256 bal = _balances[from];
        require(bal >= amount, "ERC20: transfer exceeds balance");
        unchecked {
            _balances[from] = bal - amount;
            _balances[to] += amount;
        }
        emit Transfer(from, to, amount);
    }

    function _approve(address owner_, address spender, uint256 amount) internal {
        require(owner_ != address(0), "ERC20: approve from zero");
        require(spender != address(0), "ERC20: approve to zero");
        _allowances[owner_][spender] = amount;
        emit Approval(owner_, spender, amount);
    }
}

