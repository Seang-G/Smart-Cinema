//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Admin is ERC721URIStorage, Ownable {
   using Counters for Counters.Counter;
   Counters.Counter private _ticketIds;
   string public fileExtention = ".json" ;
   address contractAddress;
    using Strings for uint256;
    
   mapping(address => bool) public isAdmin;
   modifier onlyAdmin() {
       require(isAdmin[msg.sender], "caller has no minting right!!");
       _;
   }

   constructor(address cinemaAddress) ERC721("WaterNFT Tokens", "WNT") {
        contractAddress = cinemaAddress;
    }

   function createToken(string memory tokenuri) public onlyAdmin returns (uint256) {
       _ticketIds.increment();
       uint256 newItemId = _ticketIds.current();

       _mint(msg.sender, newItemId);
       _setTokenURI(newItemId, tokenuri);
       setApprovalForAll(contractAddress, true);

       return newItemId;
   }

   function createTokens(string memory tokenuri, uint256 from, uint256 to) public {
       for(uint256 i = from; i < to; i++) {
           createToken(tokenuri);
       }
   } 

   function tokenURI(uint256 tokenId) public view override returns (string memory) {
       require(_exists(tokenId), "URI query for nonexistent token!");
       string memory uri = "https://gateway.pinata.cloud/ipfs/QmVgH1bjmyQbxC3RXKGY62ifpte1gV1m9PkqseL9p7PGPg/";
          return bytes(uri).length >= 0 ? string(abi.encodePacked(uri, tokenId.toString(), fileExtention)) : "";
   }

    function transferToken(
        address from,
        address to,
        uint256 tokenId
    ) external {
        require(ownerOf(tokenId) == from, "From address must be token owner");
        _transfer(from, to, tokenId);
    }

    function addAdmin(address adminAddress) public onlyOwner {
        require(
            adminAddress != address(0),
            "admin Address is the zero address"
        );
        isAdmin[adminAddress] = true;
    }

    function removeAdmin(address adminAddress) public onlyOwner {
        require(
            adminAddress != address(0),
            "admin Address is the zero address"
        );
        isAdmin[adminAddress] = true;
    }

    function blackListAddress(address userAddress) public onlyAdmin {
        require(userAddress != address(0), "userAddress  is the zero address");
        isAdmin[userAddress] = false;
    }
}
