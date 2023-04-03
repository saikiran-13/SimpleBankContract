// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract simpleBank{
    mapping(address=>uint) public balances;

    event etherDeposited(address,string);
    event etherWithdrawn(address,string);

    modifier checkOwnerAddress(){
        require(msg.sender!=address(0),"Owner should not have zeroth address");
        _;
    }

    //To check total contract Balance
    function checkEther() public view checkOwnerAddress returns(uint){
        return address(this).balance;
    }

    //Deposit ether 
    function depositEther() public checkOwnerAddress payable{
        balances[msg.sender]+=msg.value;
        emit etherDeposited(msg.sender,"Amount deposited successfully");
    }

    //Withdraw ether
    function withdrawEther(uint _amount) public checkOwnerAddress payable{
        require(_amount<=balances[msg.sender],"Amount should be less than Owner Balance");
        balances[msg.sender]-=_amount;
        payable(msg.sender).transfer(_amount);
        emit etherWithdrawn(msg.sender,"Amount Withdrawn successfully");
    }
}