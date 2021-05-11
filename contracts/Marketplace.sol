// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import '@openzeppelin/contracts/access/Ownable.sol';
import "./NFTContract.sol";

/// @title Markeplace Contract
/// @dev This contract manages everything related to the purchase/sell and price of NFT
contract Marketplace is Ownable {
    using SafeMath for uint256;
    NFTContract private nft;
        
    /**
     * @dev Emitted when NFT is buyed.
     */
    event BuyTransaction(
        uint256 assetId,
        address oldOwner,
        address newOwner,
        uint256 price
    );
         
    /** 
     * @dev Throws if called by any account other than the NFT owner.
     * @param _nftAddress - NFT collection address
     * @param _assetId - NFT id.
     */
    modifier onlyNFTOwner(address _nftAddress, uint256 _assetId) {
        require(_nftAddress != address(0));
        require(msg.sender == IERC721(_nftAddress).ownerOf(_assetId), "Caller is not nft owner");
        _;
    }
 
    /** 
     * @dev 
     */
    receive() external payable {}
    
    /**
     * @dev Buy a NFT  
     * @param _nftAddress - NFT contract address
     * @param _assetId - NFT id
     */
    function buy(address _nftAddress, uint256 _assetId) public payable returns (bool result, bytes memory resultData) {
        require(NFTContract(_nftAddress).getOnSale(_assetId) == true, "Card is not for sale");
        address nftOwner = IERC721(_nftAddress).ownerOf(_assetId);
        uint256 priceInWei = NFTContract(_nftAddress).getPrice(_assetId);
        
        //send ether
        (bool sent, bytes memory data) = nftOwner.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
        
        //transfer nft
        IERC721(_nftAddress).transferFrom(
            nftOwner,
            msg.sender,
            _assetId
        );

        //update Onsale and
        NFTContract(_nftAddress).updateOnSale(_assetId, false);
        emit BuyTransaction(_assetId, nftOwner, msg.sender, priceInWei);
        return (sent, data);
    }
    
    /** 
     * @dev Set a NFT price 
     * @param _assetId - NFT id
     * @param _amount - NFT price
     */
    function putOnSale(address _nftAddress, uint256 _assetId, uint256 _amount) public onlyNFTOwner(_nftAddress, _assetId) {
        NFTContract(_nftAddress).setPrice(_assetId, _amount);
        
        if(!NFTContract(_nftAddress).getOnSale(_assetId)) {
            NFTContract(_nftAddress).updateOnSale(_assetId, true);
        }
    }

    /** 
     * @dev remove NFT on sale
     * @param _assetId - NFT id
     */
    function removeOnSale(address _nftAddress, uint256 _assetId) public onlyNFTOwner(_nftAddress, _assetId){
        NFTContract(_nftAddress).updateOnSale(_assetId, false);
    }
}