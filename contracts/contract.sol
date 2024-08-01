// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NexpMVP {
    // Event to emit the greeting message
    event Greeting(string message);

    // Function to return a greeting message
    function hello(string memory name) external returns (string memory) {
        string memory greeting = string(abi.encodePacked("Hello, ", name));
        
        // Emit the greeting message
        emit Greeting(greeting);
        
        return greeting;
    }
}
