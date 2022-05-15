// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./TechAlchemy.sol";

contract APYStaking is Ownable{
    string public name = "APY Staking";
    TechAlchemy public APY;

    uint256 start30;
    uint256 start60;
    uint256 start90;
 
    //address public owner;

    //declaring 30 days staking for APY (default 0.3% daily i.e. 10% APY in 30 days)
    uint256 public thirtyAPY = 1000;

    //declaring APY for 60 days staking ( default 0.3% daily i.e. 20% APY in 60 days)
    uint256 public sixtyAPY = 2000;

    // //declaring APY for 60 days staking ( default 0.3% daily i.e. 30% APY in 90 days)
    uint256 public APY90 = 3000;

    //declaring total staked
    uint256 public totalStaked;
    uint256 public customTotalStaked60;
    uint256 public customTotalStaked90;

    //users staking balance
    mapping(address => uint256) public stakingBalance;
    mapping(address => uint256) public customStakingBalance60;
    mapping(address => uint256) public customStakingBalance90;

    //mapping list of users who ever staked
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public customHasStaked60;
    mapping(address => bool) public customHasStaked90;

    //mapping list of users who are staking at the moment
    mapping(address => bool) public isStakingAtm;
    mapping(address => bool) public customIsStakingAtm60;
    mapping(address => bool) public customIsStakingAtm90;

    //array of all stakers
    address[] public stakers;
    address[] public customStakers60;
    address[] public customStakers90;

    constructor(TechAlchemy _APY) public{
        APY = _APY;
       
    }

    //stake tokens function

    function stakeTokens(uint256 _amount) public {
        //must be more than 0
        require(_amount > 0, "amount cannot be 0");
         
        start30 = block.timestamp;

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
        //stakeTokens storage start1;
        uint256 balance = stakingBalance[msg.sender];

        //amount should be more than 0
        require(balance > 0, "amount has to be more than 0");

       require(block.timestamp >= start30, "Unstaking of tokens can be done only after 30 days");

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
        start60 = block.timestamp;
        APY.transferFrom(msg.sender, address(this), _amount);
        customTotalStaked60 = customTotalStaked60 + _amount;
        customStakingBalance60[msg.sender] =
            customStakingBalance60[msg.sender] +
            _amount;

        if (!customHasStaked60[msg.sender]) {
            customStakers60.push(msg.sender);
        }
        customHasStaked60[msg.sender] = true;
        customIsStakingAtm60[msg.sender] = true;
    }

    function customUnstake60() public {
        uint256 balance60 = customStakingBalance60[msg.sender];
        require(balance60 > 0, "amount has to be more than 0");
        require(block.timestamp >= start60, "Unstaking of tokens can be done only after 60 days");
        APY.transfer(msg.sender, balance60);
        customTotalStaked60 = customTotalStaked60 - balance60;
        customStakingBalance60[msg.sender] = 0;
        customIsStakingAtm60[msg.sender] = false;
    }

    // APY pool for 90 days
    function customStaking90(uint256 _amount) public {
        require(_amount > 0, "amount cannot be 0");
        start90 = block.timestamp;
        APY.transferFrom(msg.sender, address(this), _amount);
        customTotalStaked90 = customTotalStaked90 + _amount;
        customStakingBalance90[msg.sender] =
            customStakingBalance90[msg.sender] +
            _amount;

        if (!customHasStaked90[msg.sender]) {
            customStakers90.push(msg.sender);
        }
        customHasStaked90[msg.sender] = true;
        customIsStakingAtm90[msg.sender] = true;
    }

    function customUnstake90() public {
        uint256 balance90 = customStakingBalance90[msg.sender];
        require(balance90 > 0, "amount has to be more than 0");
        require(block.timestamp >= start90, "Unstaking of tokens can be done only after 90 days");
        APY.transfer(msg.sender, balance90);
        customTotalStaked90 = customTotalStaked90 - balance90;
        customStakingBalance90[msg.sender] = 0;
        customIsStakingAtm90[msg.sender] = false;
    }

    //airdropp tokens
    function redistributeRewards() public onlyOwner{
       
        //doing drop for all addresses
        for (uint256 i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];

            //calculating daily apy for user
            uint256 balance = stakingBalance[recipient] * thirtyAPY;
            balance = balance / 100000;

            if (balance > 0) {
                APY.transfer(recipient, balance);
            }
        }
    }

    //dailyAPY60 tokens airdrop
    function customRewards60() public onlyOwner{
     
        for (uint256 i = 0; i < customStakers60.length; i++) {
            address recipient = customStakers60[i];
            uint256 balance = customStakingBalance60[recipient] * sixtyAPY;
            balance = balance / 100000;

            if (balance > 0) {
                APY.transfer(recipient, balance);
            }
        }
    }

    //dailyAPY60 tokens airdrop
    function customRewards90() public onlyOwner{
     
        for (uint256 i = 0; i < customStakers90.length; i++) {
            address recipient = customStakers90[i];
            uint256 balance = customStakingBalance90[recipient] * APY90;
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
        sixtyAPY = _value;
    }

    //change APY value for 90 days staking
    function changeAPY90(uint256 _value) public onlyOwner {
       
        require(
            _value > 0,
            "APY value has to be more than 0, try 300 for (0.3% daily) instead"
        );
        APY90 = _value;
    }

    //cliam test 1000 Tst (for testing purpose only !!)
    function claimTst() public {
        address recipient = msg.sender;
        uint256 testingtoken = 1000000000000000000000;
        uint256 balance = testingtoken;
        APY.transfer(recipient, balance);
    }
}
