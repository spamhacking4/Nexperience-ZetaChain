// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserDataPrivacyVerification {
    // State variables
    mapping(address => uint256) public privacySettings;
    mapping(address => bool) public verifiedUsers;

    // Events
    event InitializationCompleted(address indexed user);
    event PrivacySettingsUpdated(address indexed user, uint256 settings);
    event UserVerified(address indexed user, bool success);

    // Modifier to check if the sender is an existing user
    modifier onlyExistingUser() {
        require(privacySettings[msg.sender] != 0, "User not found");
        _;
    }

    // Function to initialize the state storage for the sender
    function initialize() external {
        require(privacySettings[msg.sender] == 0, "Already initialized");

        privacySettings[msg.sender] = 1;

        emit InitializationCompleted(msg.sender);
    }

    // Function to set privacy settings
    function setPrivacySettings(uint256 settings) external onlyExistingUser {
        privacySettings[msg.sender] = settings;

        emit PrivacySettingsUpdated(msg.sender, settings);
    }

    // Function to verify user data
    function verifyUserData(uint256 proof) external onlyExistingUser {
        require(privacySettings[msg.sender] == proof, "Invalid consent or proof");

        verifiedUsers[msg.sender] = true;

        emit UserVerified(msg.sender, true);
    }

    // Function to check if a user is verified
    function isUserVerified(address user) external view returns (bool) {
        return verifiedUsers[user];
    }
}
