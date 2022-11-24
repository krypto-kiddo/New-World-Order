// Original code written by @sassycular
// This code was used for the final project.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NWO is ERC1155, Ownable, Pausable, ERC1155Supply{
    uint256 public publicPrice = 0.03 ether;
    uint256 public maxSupply = 666;

    constructor()
        ERC1155("https://gateway.pinata.cloud/ipfs/QmYFMUtyjiKE2GY9QvFLeF1H2aeBX5Ew96fVehdm49DqaF/")
    {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(uint256 id, uint256 amount)
        public
        payable 
    {
        require(id < 7, "Looks like you're trying to mint the wrong NFT");
        require(msg.value == publicPrice * amount, "Please send the required amount");
        require(totalSupply(id) + amount <= maxSupply, "Sorry we have minted out!");
        _mint(msg.sender, id, amount, "");
    }

    function withdraw(address _addr) external onlyOwner {
        uint256 balance = address(this).balance;
        payable(_addr).transfer(balance);
    }
function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function uri(uint256 _id) public view virtual override returns (string memory) {
        require(exists(_id), "URI: non-existent token");
        return string(abi.encodePacked(super.uri(_id), Strings.toString(_id), ".json"));
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
