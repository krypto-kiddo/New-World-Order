// SPDX-License-Identifier: MIT

// new updates in V2:
// Added mintCoins function with a seperate maxSupply and boundingCurves for inflation
// renamed "mint" function to mintNFT so we have seperate minting functions now for coins and NFTs.
// added constructor args to save myself some useless goerli cash

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NWO is ERC1155, Ownable, Pausable, ERC1155Supply{
    uint256 public publicPrice = 0.03 ether;
    uint256 public maxNFTSupply = 666;
    uint256 public maxCoinSupply = 666666666;
    uint256 public coinPrice = 0.03 ether;

    constructor()
        ERC1155("https://gateway.pinata.cloud/ipfs/QmNRP1bjBhqidsUGar83dgYFBUXpEziAHMNcBQjSqkhuYQ/")
    {
        _mint(msg.sender, 7, 1998, ""); // 1998 NWO coins to creator
        // minting 3 copies of each NFT to creator
        // 4th copy will be public-minted live. 
        _mint(msg.sender, 0, 3, "");
        _mint(msg.sender, 1, 3, "");
        _mint(msg.sender, 2, 3, "");
        _mint(msg.sender, 3, 3, "");
        _mint(msg.sender, 4, 3, "");
        _mint(msg.sender, 5, 3, "");
        _mint(msg.sender, 6, 3, "");
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mintNFT(uint256 id, uint256 amount)
        public
        payable 
    {
        require(id < 7, "Looks like you're trying to mint the wrong NFT");
        require(msg.value == publicPrice * amount, "Please send the required amount");
        require(totalSupply(id) + amount <= maxNFTSupply, "Sorry we have minted out!");
        _mint(msg.sender, id, amount, "");
    }

    function mintCoins(uint256 amount)
        public
        payable
    {
        uint256 payPrice = coinPrice * amount;
        require(msg.value >= payPrice, string(abi.encodePacked("Invalid Amount sent, please send a minimum of ",payPrice," Eth")));
        _mint(msg.sender,7,amount, ""); // ID 7 for coins
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
