// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ESCROW {
    address public buyer;
    address public seller;
    uint256 public amount;
    uint256 public deadline;

    enum State {
        AWAITING_PAYMENT,
        FUNDED,
        RELEASED,
        REFUNDED
    }

    State public state;

    modifier onlybuyer() {
        require(msg.sender == buyer, "You are Not a buyer");
        _;
    }

    modifier inState(State _state) {
        require(state == _state, "Invalid state");
        _;
    }

    constructor(address _seller, uint256 _duration) {
        buyer = msg.sender;
        seller = _seller;
        deadline = block.timestamp + _duration;
        state = State.AWAITING_PAYMENT;
    }

    // Buyer deposits ETH
    function fund() external payable onlybuyer inState(State.AWAITING_PAYMENT) {
        require(msg.value > 0, "No Eth sent Still");
        amount = msg.value;
        state = State.FUNDED;
    }

    // buyer releases Eth to seller
    function release() external onlybuyer inState(State.FUNDED) {
        state = State.RELEASED;

        (bool success, ) = seller.call{value: amount}("");
        require(success, "Transfer Failed");
    }

    // Buyer refunds Eth sfter deadline
    function refund() external onlybuyer inState(State.FUNDED) {
        require(block.timestamp > deadline, "Too early");
        state = State.REFUNDED;
        (bool success, ) = buyer.call{value: amount}("");
        require(success, "Transfer Failed");
    }
}
