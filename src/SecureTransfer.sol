// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SecureTransfer is Ownable, ReentrancyGuard {
    // Function to transfer Ether from the contract to a specific address
    function transferEther(
        address payable recipient,
        uint256 amount
    ) external onlyOwner nonReentrant {
        require(
            address(this).balance >= amount,
            "Insufficient balance in the contract"
        );

        // Transfer the Ether to the recipient
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Transfer failed.");
    }

    // Fallback function to allow the contract to receive Ether
    receive() external payable {}
}

interface I {
    function getCurrentBalance() external view returns (uint);
    function transferOwnership(address newOwner) external;
}
