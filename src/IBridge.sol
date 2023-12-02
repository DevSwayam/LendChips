// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IBridge {
    function sendMessagePayNative(
        uint64 _destinationChainSelector,
        address _receiver,
        uint256 _DUSD_AMOUNT,
        uint16 _messageType
    ) external returns (bytes32);

    function AddBorrowingPowerSend(
        uint64 _destination,
        uint256 _DUSD_AMOUNT,
        address _borrower,
        address _destinationBridge
    ) external payable;

    function RemoveBorrowingPowerSend(
        uint64 _destination,
        uint256 _DUSD_AMOUNT,
        address _borrower,
        address _destinationBridge
    ) external payable;

    function GiveBackOwnershipOfNFTOnAllChains(
        uint64 _destination,
        uint256 _DUMMY_NUMBER,
        address _borrower,
        address _destinationBridge
    ) external payable;

    function withdraw(address _beneficiary) external;

    function allowlistedDestinationChains(uint64) external view returns (bool);

    function allowlistedSourceChains(uint64) external view returns (bool);

    function allowlistedSenders(address) external view returns (bool);

    event MessageSent(
        bytes32 indexed messageId,
        uint64 indexed destinationChainSelector,
        address receiver,
        bytes message,
        address feeToken,
        uint256 fees
    );

    event MessageReceived(
        bytes32 indexed messageId,
        uint64 indexed sourceChainSelector,
        address sender
    );
}
