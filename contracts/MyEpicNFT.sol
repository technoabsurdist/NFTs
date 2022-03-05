// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1; 

import "hardhat/console.sol"; 
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; 
import "@openzeppelin/contracts/utils/Counters.sol"; 

import { Base64 } from "./libraries/Base64.sol"; 


contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds; 

    // This is SVG code. Just change the word that's displayed, everything else stays constant. 
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    
    // Create n arrays, each with their theme of random words 
    string[] firstWords = ["Couch", "Chair", "Computer", "TV", "Monitor", "Keyboard", "Headphones", "Water", "Tissues", "Apple", "Book", "Pipe"]; 
    string[] secondWords = ["Dog", "Cat", "Alligator", "Elephant", "Rhino", "Tiger", "Snake", "Ghost", "Shark", "Fish"]; 
    string[] thirdWords = ["Green", "Red", "Puple", "Brown", "Black", "White", "Pink", "Yellow", "Blue", "Magenta", "Grey", "Giant"]; 

    event NewEpicNFTMinted(address sender, uint256 tokenId); 

    // pass the name of our NFTs token and its symbol
    constructor() ERC721 ("NEVER HAPPENED", "EMI") {
        console.log("NFT Contract."); 
    }

    // Function that (pseudo) randomly picks a word from each array 
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("Couch", Strings.toString(tokenId)))); 
        rand = rand % firstWords.length; 
        return firstWords[rand]; 
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("Dog", Strings.toString(tokenId)))); 
        rand = rand % secondWords.length; 
        return secondWords[rand]; 
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("Green", Strings.toString(tokenId)))); 
        rand = rand % thirdWords.length; 
        return thirdWords[rand]; 
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input))); 
    }

    function makeAnEpicNFT() public {
        // automatically initialized to 0 always
        uint256 newItemId = _tokenIds.current(); 

        // Randomly grab one word from each of the three arrays
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third)); 

        string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>")); 
        
        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Prepend data:applications:json;base64, to data
        string memory finalTokenUri = string(abi.encodePacked("data:application/json;base64,", json)); 

        console.log("\n----------------------"); 
        console.log(finalTokenUri); 
        console.log("\n----------------------"); 

        // actual minting procedures
        _safeMint(msg.sender, newItemId); 
        // Permanent link to JSON metadata second parameter
        _setTokenURI(newItemId, "data:application/json;base64,ewogICAgIm5hbWUiOiAiRXBpY0xvcmRIYW1idXJnZXIiLAogICAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0S0lDQWdJRHh6ZEhsc1pUNHVZbUZ6WlNCN0lHWnBiR3c2SUhkb2FYUmxPeUJtYjI1MExXWmhiV2xzZVRvZ2MyVnlhV1k3SUdadmJuUXRjMmw2WlRvZ01UUndlRHNnZlR3dmMzUjViR1UrQ2lBZ0lDQThjbVZqZENCM2FXUjBhRDBpTVRBd0pTSWdhR1ZwWjJoMFBTSXhNREFsSWlCbWFXeHNQU0ppYkdGamF5SWdMejRLSUNBZ0lEeDBaWGgwSUhnOUlqVXdKU0lnZVQwaU5UQWxJaUJqYkdGemN6MGlZbUZ6WlNJZ1pHOXRhVzVoYm5RdFltRnpaV3hwYm1VOUltMXBaR1JzWlNJZ2RHVjRkQzFoYm1Ob2IzSTlJbTFwWkdSc1pTSStSWEJwWTB4dmNtUklZVzFpZFhKblpYSThMM1JsZUhRK0Nqd3ZjM1puUGc9PSIKfQ=="); 

        // tell console that NFT has been minted. 
        // next time called, it will be _tokenIds++; 
        _tokenIds.increment(); 

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender); 
        // emit event that new NFT has been minted
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

}
