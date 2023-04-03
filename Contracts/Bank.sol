// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import {CreateToken} from "./Token.sol";

contract simpleBank{
    mapping(address=>uint) public balances;
    address public bankOwner;

    event etherDeposited(address user);
    event etherWithdrawn(address user);

    constructor(){
        bankOwner = msg.sender;
    }
  
    modifier checkOwnerAddress(){
        require(msg.sender!=address(0));
        _;
    }

    modifier onlyBankOwner(){
        require(msg.sender==bankOwner,"Only bankOwner can check the total contract balance");
        _;
    }

    modifier checkDepositAmount(){
        require(msg.value>0,"Amount must be above zero");
        _;
    }
    //To check total contract Balance
    function checkEther() external view checkOwnerAddress onlyBankOwner returns(uint){
        return address(this).balance;
    }

    //Deposit ether 
    function depositEther() external checkOwnerAddress checkDepositAmount payable{
        balances[msg.sender]+=msg.value;
        emit etherDeposited(msg.sender);
    }

    //Withdraw ether
    function withdrawEther(uint _amount) external checkOwnerAddress payable{
        require(_amount<=balances[msg.sender],"Amount should be less than Owner Balance");
        balances[msg.sender]-=_amount;
        payable(msg.sender).transfer(_amount);
        emit etherWithdrawn(msg.sender);
    }
}

//===================================================================================================

contract TokenBank{
    
    CreateToken public token;
    mapping(address => uint) public customerBalance;

    event AmountWithdrawn(address depositer,uint money);
    event AmountDeposited(address depositer,uint money);

    constructor(address _tokenaddress){
        token = CreateToken(_tokenaddress);
    }

    
    function bankBalance() external view returns(uint){
            return token.balanceOf(address(this));//Total Contract Bank Balance
    }

    function withdrawTokens(uint _amount) external {
        require(_amount<=customerBalance[msg.sender]);
        token.transfer(msg.sender,_amount);
        customerBalance[msg.sender]-= _amount;//Customer Bank Balance Updated(decreased)
        emit AmountWithdrawn(msg.sender,_amount);
    } 

    function depositTokens(uint _amount) external {
        require(_amount>0);
        token.transferFrom(msg.sender,address(this),_amount);
        customerBalance[msg.sender]+= _amount; //Customer Bank balance Updated(increased)
        emit AmountDeposited(msg.sender,_amount);
    }
}
