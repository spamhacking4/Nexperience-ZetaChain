// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdSlotAuction {
    // State variables
    uint256 public auctionCounter = 1;
    uint256 public currentAuctionId;

    struct Auction {
        uint256 auctionId;
        address owner;
        bool isActive;
        uint256 highestBid;
        address highestBidder;
    }

    mapping(address => bool) public dAppOwners;
    mapping(uint256 => Auction) public auctions;
    mapping(address => uint256) public balances;

    // Events
    event InitializationCompleted(address indexed dAppOwner);
    event AuctionCreated(uint256 indexed auctionId, address indexed owner);
    event AuctionStarted(uint256 indexed auctionId);
    event BidPlaced(uint256 indexed auctionId, address indexed bidder, uint256 bidAmount);

    // Modifier to check if the sender is an existing DApp owner
    modifier onlyDAppOwner() {
        require(dAppOwners[msg.sender], "DApp owner not found");
        _;
    }

    // Function to initialize the state storage for the sender
    function initialize() external {
        require(!dAppOwners[msg.sender], "Already initialized");

        dAppOwners[msg.sender] = true;

        emit InitializationCompleted(msg.sender);
    }

    // Function to create a new auction
    function createAuction() external onlyDAppOwner {
        uint256 newAuctionId = auctionCounter;

        auctions[newAuctionId] = Auction({
            auctionId: newAuctionId,
            owner: msg.sender,
            isActive: true,
            highestBid: 0,
            highestBidder: address(0)
        });

        auctionCounter++;

        emit AuctionCreated(newAuctionId, msg.sender);
    }

    // Function to start an auction
    function startAuction(uint256 auctionId) external onlyDAppOwner {
        require(auctions[auctionId].isActive, "Auction not found or not active");

        currentAuctionId = auctionId;

        emit AuctionStarted(auctionId);
    }

    // Function to place a bid
    function placeBid(uint256 bidAmount) external {
        Auction storage auction = auctions[currentAuctionId];
        require(auction.isActive, "Auction not active");

        require(balances[msg.sender] >= bidAmount, "Insufficient balance");

        auction.highestBid = bidAmount;
        auction.highestBidder = msg.sender;
        balances[msg.sender] -= bidAmount;

        emit BidPlaced(currentAuctionId, msg.sender, bidAmount);
    }

    // Function to deposit funds
    function depositFunds() external payable {
        balances[msg.sender] += msg.value;
    }

    // Function to withdraw funds
    function withdrawFunds(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
