// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdSlotManagement {
    // State variables
    uint256 public slotCounter = 1;
    mapping(address => DAppOwner) public dAppOwners;

    // DAppOwner structure
    struct DAppOwner {
        bool isOwner;
        mapping(uint256 => AdSlot) adSlots;
        uint256[] slotIds;
    }

    // AdSlot structure
    struct AdSlot {
        uint256 slotId;
        bool isActive;
    }

    // Events
    event InitializationCompleted();
    event AdSlotCreated(address indexed dAppOwner, uint256 slotId);

    // Modifier to check if the sender is an existing DApp owner
    modifier onlyDAppOwner() {
        require(dAppOwners[msg.sender].isOwner, "DApp owner not found");
        _;
    }

    // Initialization function (constructor in Solidity)
    constructor() {
        emit InitializationCompleted();
    }

    // Function to register a new DApp owner (for testing purposes)
    function registerDAppOwner() external {
        dAppOwners[msg.sender].isOwner = true;
    }

    // Function to create a new ad slot
    function createAdSlot() external onlyDAppOwner {
        // Assign a new slot ID to the ad slot
        uint256 newSlotId = slotCounter;

        // Create a new ad slot and mark it as active
        dAppOwners[msg.sender].adSlots[newSlotId] = AdSlot({
            slotId: newSlotId,
            isActive: true
        });

        // Store the slot ID in the DApp owner's slotIds array
        dAppOwners[msg.sender].slotIds.push(newSlotId);

        // Emit the AdSlotCreated event
        emit AdSlotCreated(msg.sender, newSlotId);

        // Increment the slot counter
        slotCounter++;
    }

    // Function to check if an ad slot exists for a given DApp owner and slot ID
    function adSlotExists(address _dAppOwner, uint256 _slotId) external view returns (bool) {
        return dAppOwners[_dAppOwner].adSlots[_slotId].slotId != 0;
    }

    // Function to get the details of an ad slot
    function getAdSlotDetails(address _dAppOwner, uint256 _slotId) external view returns (uint256, bool) {
        AdSlot memory adSlot = dAppOwners[_dAppOwner].adSlots[_slotId];
        return (adSlot.slotId, adSlot.isActive);
    }

    // Function to get all slot IDs for a given DApp owner
    function getSlotIds(address _dAppOwner) external view returns (uint256[] memory) {
        return dAppOwners[_dAppOwner].slotIds;
    }
}
