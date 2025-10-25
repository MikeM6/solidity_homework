// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC165} from "contracts/interfaces/IERC165.sol";
import {IERC721} from "contracts/interfaces/IERC721.sol";
import {IERC721Metadata} from "contracts/interfaces/IERC721Metadata.sol";
import {IERC721Receiver} from "contracts/interfaces/IERC721Receiver.sol";

/// @title SimpleERC721
/// @notice Minimal ERC721 implementation with tokenURI storage and public mint.
contract SimpleERC721 is IERC721Metadata {
    // Token metadata
    string private _name;
    string private _symbol;

    // ERC721 storage
    // _owners:
    // key : tokenID(the contract general, start 1)
    // value : the tokenID's owners
    mapping(uint256 => address) private _owners;

    // _balances:
    // key : the tokenID's owners
    // value :  token's number, One token vs one CID
    mapping(address => uint256) private _balances;

    // _tokenApprovals
    // key: tokenID
    // value: other
    // msg.sender approval other to spend its tokens
    mapping(uint256 => address) private _tokenApprovals;

    // _operatorApprovals
    // key: me
    //  key: other
    //  value: isApproval?
    // other approval me
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // _tokenURIs:
    // key : token
    // value : CID
    mapping(uint256 => string) private _tokenURIs;

    uint256 private _tokenIdTracker; // auto-incrementing token id

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    // --- ERC165 ---
    function supportsInterface(
        bytes4 interfaceId
    ) public pure override returns (bool) {
        return
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId;
    }

    // --- ERC721Metadata ---
    function name() external view override returns (string memory) {
        return _name;
    }
    function symbol() external view override returns (string memory) {
        return _symbol;
    }
    function tokenURI(
        uint256 tokenId
    ) external view override returns (string memory) {
        require(_exists(tokenId), "ERC721: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    // --- ERC721 basic ---
    function balanceOf(address owner) public view override returns (uint256) {
        require(
            owner != address(0),
            "ERC721: balance query for the zero address"
        );
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view override returns (address) {
        address owner = _owners[tokenId];
        require(
            owner != address(0),
            "ERC721: owner query for nonexistent token"
        );
        return owner;
    }

    function approve(address to, uint256 tokenId) external override {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");
        require(
            // msg.sender: the contract emitter
            // owner: the token's owner
            // for example: msg.sender = A \ owner = B
            // if B grants authorization to A, allowing A to spend B's money
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "ERC721: approve caller is not owner nor approved for all"
        );
        _approve(to, tokenId);
    }

    function getApproved(
        uint256 tokenId
    ) public view override returns (address) {
        require(
            _exists(tokenId),
            "ERC721: approved query for nonexistent token"
        );
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(
        address operator,
        bool approved
    ) external override {
        // can't approval myself, it's meaningless
        require(operator != msg.sender, "ERC721: approve to caller");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(
        address owner,
        address operator
    ) public view override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "ERC721: caller is not token owner nor approved"
        );
        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public override {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "ERC721: caller is not token owner nor approved"
        );
        _safeTransfer(from, to, tokenId, data);
    }

    // --- Minting ---
    /// @notice Public mint that auto-assigns tokenId and sets tokenURI.
    /// @return tokenId The newly minted token id.
    function mintNFT(
        address to,
        string memory uri
    ) external returns (uint256 tokenId) {
        tokenId = ++_tokenIdTracker; // start from 1
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // --- Internal helpers ---
    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function _isApprovedOrOwner(
        address spender,
        uint256 tokenId
    ) internal view returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner ||
            getApproved(tokenId) == spender ||
            isApprovedForAll(owner, spender));
    }

    function _approve(address to, uint256 tokenId) internal {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        require(
            ownerOf(tokenId) == from,
            "ERC721: transfer from incorrect owner"
        );
        require(to != address(0), "ERC721: transfer to the zero address");

        // Clear approvals
        _approve(address(0), tokenId);

        unchecked {
            _balances[from] -= 1;
            _balances[to] += 1;
        }
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        _transfer(from, to, tokenId);
        require(
            _checkOnERC721Received(from, to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _owners[tokenId] = to;
        _balances[to] += 1;
        emit Transfer(address(0), to, tokenId);
    }

    // first mint and then check
    // the check need tokenid, if execute check fun first, there are not tokenid.
    function _safeMint(address to, uint256 tokenId) internal {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, ""),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        require(_exists(tokenId), "ERC721: URI set of nonexistent token");
        _tokenURIs[tokenId] = uri;
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        // if is normal user
        if (to.code.length == 0) {
            return true;
        }
        // if is smart contract
        // the smart contract has recive function
        try
            IERC721Receiver(to).onERC721Received(
                msg.sender,
                from,
                tokenId,
                data
            )
        returns (bytes4 retval) {
            return retval == IERC721Receiver.onERC721Received.selector;
        } catch (bytes memory) {
            return false;
        }
    }
}
