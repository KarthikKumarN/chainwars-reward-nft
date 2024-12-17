// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title BukRewardsNFT
 * @dev An ERC721 token contract with role-based access control for minting and fixed IPFS URI.
 */
contract BukRewardsNFT is
    ERC721,
    ERC721URIStorage,
    ERC721Burnable,
    AccessControl
{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 private _nextTokenId;
    string private constant TOKEN_URI =
        "https://ipfs.io/ipfs/bafkreiakfqpaq3vov4gy6pvk2xzag42vdz4pklyt2dekh45ap4wd6lpdji";

    constructor(address initialAdmin, address initialMinter)
        ERC721("Buk Protocol - Chainwarz Berachain Warrior", "BUK Warrior")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, initialAdmin);
        _grantRole(MINTER_ROLE, initialMinter);
    }

    function setMinterRole(address minter) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(MINTER_ROLE, minter);
    }

    /**
     * @dev Safely mint a new token with arbitrary `data` for contract recipients.
     * This `data` is forwarded to `onERC721Received` in case the recipient is a contract.
     */
    function safeMint(
        address to,
        bytes calldata data
    ) external onlyRole(MINTER_ROLE) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId, data); // Forwarding data to `onERC721Received` if needed
        _setTokenURI(tokenId, TOKEN_URI);
    }
    
    function mint(
        address to
    ) external onlyRole(MINTER_ROLE) {
        uint256 tokenId = _nextTokenId++;
        _mint(to, tokenId);
        _setTokenURI(tokenId, TOKEN_URI);
    }

    // The following functions are overrides required by Solidity.
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
