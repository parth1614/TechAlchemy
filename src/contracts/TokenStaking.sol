// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./TechAlchemy.sol";

contract APYStaking is Ownable{
    string public name = "APY Staking";
    TechAlchemy public APY;

 
    //address public owner;

    //declaring 30 days staking for APY (default 0.3% daily i.e. 10% APY in 30 days)
    uint256 public dailyAPY = 300;

    //declaring APY for 60 days staking ( default 0.3% daily i.e. 20% APY in 60 days)
    uint256 public dailyAPY60 = 300;

    // //declaring APY for 60 days staking ( default 0.3% daily i.e. 20% APY in 60 days)
    uint256 public dailyAPY90 = 300;

    //declaring total staked
    uint256 public totalStaked;
    uint256 public customTotalStaked;

    //users staking balance
    mapping(address => uint256) public stakingBalance;
    mapping(address => uint256) public customStakingBalance;

    //mapping list of users who ever staked
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public customHasStaked;

    //mapping list of users who are staking at the moment
    mapping(address => bool) public isStakingAtm;
    mapping(address => bool) public customIsStakingAtm;

    //array of all stakers
    address[] public stakers;
    address[] public customStakers;

    constructor(TechAlchemy _APY) public{
        APY = _APY;
    }

    //stake tokens function

    function stakeTokens(uint256 _amount) public {
        //must be more than 0
        require(_amount > 0, "amount cannot be 0");

        //User adding test tokens
        APY.transferFrom(msg.sender, address(this), _amount);
        totalStaked = totalStaked + _amount;

        //updating staking balance for user by mapping
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        //checking if user staked before or not, if NOT staked adding to array of stakers
        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        //updating staking status
        hasStaked[msg.sender] = true;
        isStakingAtm[msg.sender] = true;
    }

    //unstake tokens function

    function unstakeTokens() public {
        //get staking balance for user

        uint256 balance = stakingBalance[msg.sender];

        //amount should be more than 0
        require(balance > 0, "amount has to be more than 0");

        //transfer staked tokens back to user
        APY.transfer(msg.sender, balance);
        totalStaked = totalStaked - balance;

        //reseting users staking balance
        stakingBalance[msg.sender] = 0;

        //updating staking status
        isStakingAtm[msg.sender] = false;
    }

    // APY pool for 60 days
    function customStaking60(uint256 _amount) public {
        require(_amount > 0, "amount cannot be 0");
        APY.transferFrom(msg.sender, address(this), _amount);
        customTotalStaked = customTotalStaked + _amount;
        customStakingBalance[msg.sender] =
            customStakingBalance[msg.sender] +
            _amount;

        if (!customHasStaked[msg.sender]) {
            customStakers.push(msg.sender);
        }
        customHasStaked[msg.sender] = true;
        customIsStakingAtm[msg.sender] = true;
    }

    function customUnstake60() public {
        uint256 balance = customStakingBalance[msg.sender];
        require(balance > 0, "amount has to be more than 0");
        APY.transfer(msg.sender, balance);
        customTotalStaked = customTotalStaked - balance;
        customStakingBalance[msg.sender] = 0;
        customIsStakingAtm[msg.sender] = false;
    }

    // APY pool for 90 days
    function customStaking90(uint256 _amount) public {
        require(_amount > 0, "amount cannot be 0");
        APY.transferFrom(msg.sender, address(this), _amount);
        customTotalStaked = customTotalStaked + _amount;
        customStakingBalance[msg.sender] =
            customStakingBalance[msg.sender] +
            _amount;

        if (!customHasStaked[msg.sender]) {
            customStakers.push(msg.sender);
        }
        customHasStaked[msg.sender] = true;
        customIsStakingAtm[msg.sender] = true;
    }

    function customUnstake90() public {
        uint256 balance = customStakingBalance[msg.sender];
        require(balance > 0, "amount has to be more than 0");
        APY.transfer(msg.sender, balance);
        customTotalStaked = customTotalStaked - balance;
        customStakingBalance[msg.sender] = 0;
        customIsStakingAtm[msg.sender] = false;
    }

    //airdropp tokens
    function redistributeRewards() public onlyOwner{
       
        //doing drop for all addresses
        for (uint256 i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];

            //calculating daily apy for user
            uint256 balance = stakingBalance[recipient] * dailyAPY;
            balance = balance / 100000;

            if (balance > 0) {
                APY.transfer(recipient, balance);
            }
        }
    }

    //dailyAPY60 tokens airdrop
    function customRewards60() public onlyOwner{
     
        for (uint256 i = 0; i < customStakers.length; i++) {
            address recipient = customStakers[i];
            uint256 balance = customStakingBalance[recipient] * dailyAPY60;
            balance = balance / 100000;

            if (balance > 0) {
                APY.transfer(recipient, balance);
            }
        }
    }

    //dailyAPY60 tokens airdrop
    function customRewards90() public onlyOwner{
     
        for (uint256 i = 0; i < customStakers.length; i++) {
            address recipient = customStakers[i];
            uint256 balance = customStakingBalance[recipient] * dailyAPY90;
            balance = balance / 100000;

            if (balance > 0) {
                APY.transfer(recipient, balance);
            }
        }
    }

    //change APY value for 60 days staking
    function changeAPY60(uint256 _value) public onlyOwner {
       
        require(
            _value > 0,
            "APY value has to be more than 0, try 300 for (0.3% daily) instead"
        );
        dailyAPY60= _value;
    }

    //change APY value for 90 days staking
    function changeAPY90(uint256 _value) public onlyOwner {
       
        require(
            _value > 0,
            "APY value has to be more than 0, try 300 for (0.3% daily) instead"
        );
        dailyAPY90 = _value;
    }

    //cliam test 1000 Tst (for testing purpose only !!)
    function claimTst() public {
        address recipient = msg.sender;
        uint256 testingtoken = 1000000000000000000000;
        uint256 balance = testingtoken;
        APY.transfer(recipient, balance);
    }
}
