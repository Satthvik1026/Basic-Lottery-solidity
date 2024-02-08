// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0;

contract Lottery{
    address public manager;
    address payable[] public participants;

    constructor(){
        manager= msg.sender; //global variable
    }

    receive() external payable 
    {
        if(msg.value == 1 ether){                 //participant should send only one ether to participate
        participants.push(payable(msg.sender));  

        }

     }
     function getBalance() public view returns(uint){
        if(msg.sender == manager){  //only manager can check balance
        return address(this).balance;

        }
        return 0;
     }

     function random() private view returns(uint256){
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length))); //used to generate random number
     }
        
    function selectWinner() public{
        require(msg.sender == manager);  //only manager can select winner
        require(participants.length >=3);
        uint256 r =random();
        address payable winner;
        uint256 index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }

}