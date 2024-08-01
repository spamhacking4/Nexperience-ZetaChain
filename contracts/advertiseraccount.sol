// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdvertiserAccount {
    // State variables
    uint256 public accountCounter = 1;
    mapping(address => Advertiser) public advertisers;

    // Advertiser structure
    struct Advertiser {
        uint256 accountId;
        bool isActive;
    }

    // Events
    event AccountCreated(address indexed advertiser, uint256 accountId);
    event InitializationCompleted();

    // Modifier to check if the advertiser already exists
    modifier advertiserDoesNotExist() {
        require(advertisers[msg.sender].accountId == 0, "Advertiser already exists");
        _;
    }

    // Initialization function (constructor in Solidity)
    constructor() {
        emit InitializationCompleted();
    }

    // Function to create a new advertiser account
    function createAccount() external advertiserDoesNotExist {
        // Assign a new account ID to the advertiser
        advertisers[msg.sender] = Advertiser({
            accountId: accountCounter,
            isActive: true
        });

        // Emit the AccountCreated event
        emit AccountCreated(msg.sender, accountCounter);

        // Increment the account counter
        accountCounter++;
    }

    // Function to check if an advertiser exists
    function advertiserExists(address _advertiser) external view returns (bool) {
        return advertisers[_advertiser].accountId != 0;
    }

    // Function to get the account details of an advertiser
    function getAccountDetails(address _advertiser) external view returns (uint256, bool) {
        Advertiser memory advertiser = advertisers[_advertiser];
        return (advertiser.accountId, advertiser.isActive);
    }
}
