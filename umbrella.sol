// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UmbrellaVendingMachine {
    address public owner;
    uint256 public umbrellaPrice;
    uint256 public totalUmbrellas;
    mapping(address => uint256) public userBalances;
    mapping(address => uint256) public userUmbrellas;

    event UmbrellaPurchased(address indexed buyer, uint256 umbrellasBought, uint256 balanceRemaining);

    constructor(uint256 _initialUmbrellas, uint256 _initialUmbrellaPrice) {
        owner = msg.sender;
        totalUmbrellas = _initialUmbrellas;
        umbrellaPrice = _initialUmbrellaPrice;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    function purchaseUmbrellas(uint256 _umbrellasToBuy) external payable {
        require(_umbrellasToBuy > 0, "You must buy at least one umbrella");
        require(msg.value >= _umbrellasToBuy * umbrellaPrice, "Insufficient funds");

        uint256 totalCost = _umbrellasToBuy * umbrellaPrice;
        uint256 refund = msg.value - totalCost;

        if (refund > 0) {
            userBalances[msg.sender] += refund;
        }

        userUmbrellas[msg.sender] += _umbrellasToBuy;
        totalUmbrellas -= _umbrellasToBuy;

        emit UmbrellaPurchased(msg.sender, _umbrellasToBuy, userBalances[msg.sender]);
    }

    function withdrawBalance() external {
        uint256 balance = userBalances[msg.sender];
        require(balance > 0, "No balance to withdraw");
        userBalances[msg.sender] = 0;
        payable(msg.sender).transfer(balance);
    }

    function refillUmbrellas(uint256 _amount) external onlyOwner {
        totalUmbrellas += _amount;
    }
}

//written by Mainak Chaudhuri
