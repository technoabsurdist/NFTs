// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1; 

import "hardhat/console.sol"; 
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; 
import "@openzeppelin/contracts/utils/Counters.sol"; 

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds; 

    // pass the name of our NFTs token and its symbol
    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("NFT Contract."); 
    }

    function makeAnEpicNFT() public {
        // automatically initialized to 0 always
        uint256 newItemId = _tokenIds.current(); 

        _safeMint(msg.sender, newItemId); 

        _setTokenURI(newItemId, "https://jsonkeeper.com/b/MQUW"); 
        // tell console that NFT has been minted. 
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender); 
        // next time called, it will be _tokenIds++; 
        _tokenIds.increment(); 
    }

}
