// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract BasicConduit is Ownable, ReentrancyGuard {
    address public destinationOwner;
    address public destinationAddress;
    address public initiatingOwner;
    address public conduit;

    event TransferInitiated(address indexed from, uint256 amount);
    event TransferCompleted(address indexed to, uint256 amount);

    modifier onlyInitiatingOwner() {
        require(
            msg.sender == initiatingOwner,
            "Caller is not the initiating owner"
        );
        _;
    }

    modifier onlyDestinationOwner() {
        require(
            msg.sender == destinationOwner,
            "Caller is not the destination owner"
        );
        _;
    }

    constructor(
        address _initiatingOwner,
        address _destinationOwner,
        address _destinationAddress,
        address _conduit
    ) Ownable(msg.sender) {
        initiatingOwner = _initiatingOwner;
        destinationOwner = _destinationOwner;
        destinationAddress = _destinationAddress;
        conduit = _conduit;
    }

    // Function to deposit Ether into the contract
    function deposit() external payable onlyInitiatingOwner nonReentrant {
        require(msg.value > 0, "Must send some ETH");
        emit TransferInitiated(msg.sender, msg.value);
    }

    // Function to withdraw Ether to the destination address
    function withdraw() external nonReentrant onlyDestinationOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "No ETH to transfer");

        // Transfer the ETH to the destination address
        (bool success, ) = destinationAddress.call{value: amount}("");
        require(success, "Transfer failed");

        emit TransferCompleted(destinationAddress, amount);
    }

    // Function to update the destination address, restricted to the owner
    function updateDestinationAddress(
        address newDestinationAddress
    ) external onlyOwner {
        require(newDestinationAddress != address(0), "Invalid address");
        destinationAddress = newDestinationAddress;
    }

    // Function to update the conduit, restricted to the owner
    function updateConduit(address newConduit) external onlyOwner {
        require(newConduit != address(0), "Invalid address");
        conduit = newConduit;
    }

    // Allow the owner to withdraw any accidentally sent Ether from the contract
    function emergencyWithdraw() external onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "No ETH to withdraw");
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Emergency withdraw failed");
    }

    // Fallback and receive functions to handle Ether sent to the contract directly
    receive() external payable {
        // Only allow direct deposits from the initiating owner
        require(
            msg.sender == initiatingOwner,
            "Only initiating owner can deposit directly"
        );
        emit TransferInitiated(msg.sender, msg.value);
    }

    fallback() external payable {
        // Handle unintentional transfers or external calls
        require(
            msg.sender == initiatingOwner,
            "Only initiating owner can deposit via fallback"
        );
        emit TransferInitiated(msg.sender, msg.value);
    }
}
