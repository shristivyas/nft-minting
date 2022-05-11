// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract MyNFT is ERC721URIStorage, Ownable {
    
    AggregatorV3Interface internal priceFeed;
    
    using Counters for Counters.Counter;

    uint256 public constant mintprice = 1000;

    uint256 public totalsupply = 35;

    Counters.Counter private _tokenIds;


    constructor() ERC721("Code Eater", "CER") {
        priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    }

    function mintNFT(address recipient, string memory tokenURI) public onlyOwner returns (uint256)
    {
        require(totalsupply>0 ,"limit exceeded");
        _tokenIds.increment();
        totalsupply -= 1;

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }

    function getlatestprice() public view returns(int256){
        (, int256 answer , , , ) = priceFeed.latestRoundData();
        return int256(answer*10**10); //in wei 18 decimal

    }

    function getPriceRate() public view returns (uint) {
        (, int price,,,) = priceFeed.latestRoundData();
        uint adjust_price = uint(price) * 1e10;
        uint usd = mintprice * 1e18;
        uint rate = (usd * 1e18) / adjust_price;
        return rate;
    }
}
