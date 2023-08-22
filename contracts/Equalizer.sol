// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract EqualizerProtocol {
    struct RevenueStream {
        address business;
        uint frequency; // Frequency in seconds
        uint amount;
        uint collectionPeriod;
        uint payoutAmount;
    }

    struct NFT {
        uint streamID;
        uint percentage;
        string metadata;
        bool forSale;
        uint price;
        address owner;
    }

    mapping(uint => RevenueStream) public revenueStreams;
    mapping(uint => NFT) public nfts;
    mapping(address => uint[]) public investorPortfolios;

    uint public streamCounter = 0;
    uint public nftCounter = 0;

    function createStream(uint _frequency, uint _amount, uint _collectionPeriod, uint _payoutAmount) public {
        RevenueStream memory newStream = RevenueStream(msg.sender, _frequency, _amount, _collectionPeriod, _payoutAmount);
        revenueStreams[streamCounter] = newStream;
        streamCounter++;
    }

    function mintNFT(uint _streamID, uint _percentage, string memory _metadata) public {
        require(_streamID < streamCounter, "Stream does not exist");
        RevenueStream memory stream = revenueStreams[_streamID];
        require(stream.business == msg.sender, "Only business can mint NFT for this stream");

        NFT memory newNFT = NFT(_streamID, _percentage, _metadata, false, 0, address(0));
        nfts[nftCounter] = newNFT;
        nftCounter++;
    }

    function listNFTForSale(uint _nftID, uint _price) public {
        require(_nftID < nftCounter, "NFT does not exist");
        NFT storage nft = nfts[_nftID];
        require(nft.owner == msg.sender, "Only NFT owner can list for sale");

        nft.forSale = true;
        nft.price = _price;
    }

    function purchaseNFT(uint _nftID) public payable {
        require(_nftID < nftCounter, "NFT does not exist");
        NFT storage nft = nfts[_nftID];
        require(nft.forSale, "NFT is not for sale");
        require(msg.value >= nft.price, "Insufficient funds");

        nft.forSale = false;
        nft.owner = msg.sender;
        investorPortfolios[msg.sender].push(_nftID);
    }

    function viewTransactionHistory(address _address) public view returns (uint[] memory) {
        return investorPortfolios[_address];
    }

    function reviewPortfolio(address _address) public view returns (NFT[] memory) {
        uint[] memory nftIDs = investorPortfolios[_address];
        NFT[] memory portfolio = new NFT[](nftIDs.length);

        for (uint i = 0; i < nftIDs.length; i++) {
            portfolio[i] = nfts[nftIDs[i]];
        }

        return portfolio;
    }
}
