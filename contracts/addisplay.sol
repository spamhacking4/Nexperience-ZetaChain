// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdDisplayLogic {
    struct User {
        uint256 preferences;
        bool consent;
        uint256 adAttributes;
        bool exists;
    }

    mapping(address => User) public users;

    // Events
    event AdRequested(address indexed user, bool success);

    // Modifier to check if the user exists
    modifier userExists() {
        require(users[msg.sender].exists, "User not found");
        _;
    }

    // Function to register a user with preferences and consent (for testing purposes)
    function registerUser(uint256 preferences, bool consent, uint256 adAttributes) external {
        users[msg.sender] = User({
            preferences: preferences,
            consent: consent,
            adAttributes: adAttributes,
            exists: true
        });
    }

    // Function to request an ad based on user preferences and consent
    function requestAd() external userExists returns (bool) {
        User storage user = users[msg.sender];

        // Implement ad matching logic based on preferences, consent, and ad attributes
        bool adMatchFound = false;

        // Example matching logic
        if (user.preferences == 1 && user.consent) {
            adMatchFound = true;
        }

        emit AdRequested(msg.sender, adMatchFound);
        return adMatchFound;
    }

    // Function to get user details
    function getUserDetails(address userAddress) external view returns (uint256, bool, uint256) {
        User memory user = users[userAddress];
        return (user.preferences, user.consent, user.adAttributes);
    }
}
