const NFTContract = artifacts.require('NFTContract');
const {BN, expectEvent, expectRevert} = require('@openzeppelin/test-helpers')
const { web3 } = require('@openzeppelin/test-helpers/src/setup');
const { expect } = require('chai');

describe('Deploy NFT contract and test', () => {
  let accounts;
  let owner;
  let toto;
  let david; 
  let addressTest; 
  let NFTinstance;
  before(async () => {
    accounts = await web3.eth.getAccounts();
    [owner, toto, david, addressTest] = accounts;
    NFTinstance = await NFTContract.new(
      "NFT test",
      "NFT",
      addressTest
    , { from: owner } )
  })

  it("should deploy", async () => {
    expect(NFTinstance.address).to.exist;
  });

  it("should had data constructor", async () => {
    let symbol = await NFTinstance.symbol() 
    expect(symbol).to.equal("NFT")
  })

  describe('Mint a NFT and test', () => {
    let URI = "abcdef";
    let price = 1000;
    let NFT;
    let result; 
    let Id = 1;
    let newPrice = 1789;
    
    before(async () => {
      result = await NFTinstance.mintNFT(URI, price, {from: owner})
      NFT = await NFTinstance.NFTS(1);
    })
      it("mint receipt status should be true", async () => {
        let {receipt} = result;
        expect(receipt.status).to.be.true;
      })
      it("should have the same given price", async () => {
        let priceMinted = new BN(NFT.price)
        expect(priceMinted).to.bignumber.equal(new BN(price));
      })
      it("should have the same given URI", async () => {
        expect(NFT.tokenURI).to.contain(URI);
      })

      it("should emit an event", async () => {
        //args dans l'objet en troisième param
        expectEvent(result, "NFTCreated", { tokenId: new BN(Id), owner:  owner});
      })

      it("should be not for sale", async () => {
        expect(NFT.isForSale).to.be.false;
      })

      it("should be set a new price", async () => {    
          await NFTinstance.setPrice(Id, newPrice);
          NFT = await NFTinstance.NFTS(1);
          let priceMinted = new BN(NFT.price)
          expect(priceMinted).to.bignumber.equal(new BN(newPrice));
        })
      it("should return new price", async () => {    
        let _price = await NFTinstance.getPrice(Id);
        expect(_price).to.bignumber.equal(new BN(newPrice));
      })

      it("should update isForSale", async () => {
        await NFTinstance.updateOnSale(Id, true);
        let _isForSale = await NFTinstance.getOnSale(Id);
        expect(_isForSale).to.be.true;
      })
    })
  
    
    

//test des reverts et errors
})