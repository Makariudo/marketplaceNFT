// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import "@openzeppelin/contracts/utils/Counters.sol";

/// @title NFT Contract
/// @dev This contract manages everything related to NFT

contract NFTContract is ERC721URIStorage, Ownable {
  
  //declare library stuff
  using Counters for Counters.Counter;
  using SafeMath for uint256;

  address private marketplace;
  Counters.Counter public nftId;

 //ajout du propriétaire
  struct NFTInfo {
    string tokenURI;
    uint256 price;
    address owner;
    bool isForSale;
  }

  mapping(string => bool) public ipfsHashes;
  mapping(uint => NFTInfo) public NFTS;

  /**
    *@dev Emitted when NFT is minted.
  **/
    event NFTCreated(
        address owner,
        uint256 tokenId,
        uint256 price,
        string tokenURI
    ); 

    //modifier only owner of the NFT

     /** 
     * @dev Initializes the contract by setting a `name`, a `symbol` and the `marketplace` address that will manage the token collection.
     * @param _name - token collection name
     * @param _symbol - token collection symbol
     * @param _marketplace - token collection address
     */
    constructor (string memory _name, string memory _symbol, address _marketplace) ERC721(_name, _symbol) {
        require(_marketplace != address(0));
        marketplace = _marketplace;
    }

    /** 
     * @dev Set a NFT price 
     * @param _nftId - NFT id
     * @param _amount - NFT price
     */
    function setPrice(uint256 _nftId, uint256 _amount) external {
        require(_amount >= 0, "Price must be higher or equal 0");
        NFTInfo storage token = NFTS[_nftId];
        token.price = _amount;
    }
    
    /** 
     * @dev Update status NFT on sale
     * @param _nftId - NFT id
     * @param _status - NFT status (isForSale)
     */
    function updateOnSale(uint256 _nftId, bool _status) external {
        require(NFTS[_nftId].isForSale == !_status, "Already set up!");
        NFTInfo storage token = NFTS[_nftId];
        token.isForSale = _status;
    }

    /** 
     * @dev Mint a new NFT  
     * @param _tokenURI - URL include ipfs hash
     * @param _priceBase - nft initial price
     */
    function mintNFT(string memory _tokenURI, uint256 _priceBase) public returns (string memory tokenURI) {
        require(ipfsHashes[_tokenURI] != true, "Already registered");  
        //increment id
        nftId.increment();
       
        uint256 newItemId = nftId.current();
        
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        
        ipfsHashes[_tokenURI] = true;
        
        NFTS[newItemId] = NFTInfo(
            _tokenURI,
            _priceBase,
            msg.sender,
            false
        );
        emit NFTCreated(msg.sender, newItemId, _priceBase, _tokenURI);
        return (_tokenURI);
    }
    

    /** 
     * @dev Get a NFT price
     * @param _assetId - NFT id
     * @return price - return nft price 
     */
    function getPrice(uint256 _assetId) public view returns(uint256 price) {
        return NFTS[_assetId].price; 
    }

    /** 
     * @dev Get a status NFT on sale 
     * @param _assetId - NFT id
     * @return isForSale - true if nft is for sale or false if nft is out of sale
     */
    function getOnSale(uint256 _assetId) public view returns(bool isForSale) {
        return NFTS[_assetId].isForSale; 
    }

}
