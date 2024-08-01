// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdCampaign {
    // State variables
    uint256 public globalCampaignCounter = 0;

    struct Campaign {
        address owner;
        uint256 campaignId;
        bool isActive;
    }

    mapping(address => Campaign) public campaigns;

    // Events
    event CampaignCreated(address indexed owner, uint256 campaignId);
    event CampaignUpdated(address indexed owner, uint256 campaignId);
    event CampaignCanceled(uint256 campaignId);
    event CreativeUploaded(uint256 campaignId, uint256 creativeLength);

    // Modifier to check if the campaign exists and is active
    modifier campaignExists(address owner) {
        require(campaigns[owner].isActive, "Campaign does not exist or is inactive");
        _;
    }

    // Function to create a new campaign
    function createCampaign(uint256 campaignId) external {
        require(campaigns[msg.sender].campaignId == 0, "Campaign already exists for this owner");

        globalCampaignCounter++;
        campaigns[msg.sender] = Campaign({
            owner: msg.sender,
            campaignId: campaignId,
            isActive: true
        });

        emit CampaignCreated(msg.sender, campaignId);
    }

    // Function to update an existing campaign
    function updateCampaign(address newOwner, uint256 newCampaignId) external campaignExists(msg.sender) {
        campaigns[msg.sender].owner = newOwner;
        campaigns[msg.sender].campaignId = newCampaignId;

        emit CampaignUpdated(newOwner, newCampaignId);
    }

    // Function to cancel a campaign
    function cancelCampaign(uint256 campaignId) external campaignExists(msg.sender) {
        require(campaigns[msg.sender].campaignId == campaignId, "Invalid campaign ID");

        campaigns[msg.sender].owner = address(0);
        campaigns[msg.sender].campaignId = 0;
        campaigns[msg.sender].isActive = false;

        emit CampaignCanceled(campaignId);
    }

    // Function to upload creative data for a campaign
    function uploadCreative(uint256 campaignId, bytes calldata creativeData) external campaignExists(msg.sender) {
        require(campaigns[msg.sender].campaignId == campaignId, "Invalid campaign ID");

        // Process the creative data here as per your requirements
        // For now, just logging the creative data length
        emit CreativeUploaded(campaignId, creativeData.length);
    }

    // Function to check if a campaign exists for a given owner
    function campaignExistsForOwner(address owner) external view returns (bool) {
        return campaigns[owner].isActive;
    }

    // Function to get campaign details for a given owner
    function getCampaignDetails(address owner) external view returns (address, uint256, bool) {
        Campaign memory campaign = campaigns[owner];
        return (campaign.owner, campaign.campaignId, campaign.isActive);
    }
}
