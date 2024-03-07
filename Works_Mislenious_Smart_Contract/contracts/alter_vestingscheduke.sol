// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TokenVesting is Context {
    address public owner;
    using SafeMath for uint256;

    struct VestingSchedule {
        uint256 totalAmount;
        string type_of_stakeholder;
        uint256 startTime;
        uint256 cliffDuration;
        uint256 vestingDuration;
        uint256 claimedAmount;
    }

    mapping(address => VestingSchedule) private _vestingSchedules;
    mapping(address => bool) private _whitelist;
    IERC20 private _token;

    event VestingScheduleCreated(
        address indexed beneficiary,
        string type_of_stakeholder,
        uint256 totalAmount,
        uint256 startTime,
        uint256 cliffDuration,
        uint256 vestingDuration
    );

    event TokensClaimed(address indexed beneficiary, uint256 amount);

    constructor(address tokenAddress) {
        require(tokenAddress != address(0), "Token address cannot be zero");
        _token = IERC20(tokenAddress);
        owner = msg.sender;
    }

    function registerVestingSchedule(
        address beneficiary,
        string memory type_of_stakeholder,
        uint256 totalAmount,
        uint256 startTime,
        uint256 cliffDuration,
        uint256 vestingDuration
    ) external payable onlyWhitelisted {
        require(
            beneficiary != address(0),
            "Beneficiary address cannot be zero"
        );
        require(totalAmount > 0, "Total amount must be greater than zero");
        require(
            startTime >= block.timestamp,
            "Start time must be in the future"
        );
        require(
            cliffDuration <= vestingDuration,
            "Cliff duration must be less than or equal to vesting duration"
        );
        require(
            _vestingSchedules[beneficiary].totalAmount == 0,
            "Vesting schedule already exists"
        );

        VestingSchedule memory schedule;
        schedule.type_of_stakeholder = type_of_stakeholder;
        schedule.totalAmount = totalAmount;
        schedule.startTime = startTime;
        schedule.cliffDuration = cliffDuration;
        schedule.vestingDuration = vestingDuration;
        schedule.claimedAmount = 0;
         _vestingSchedules[beneficiary] = schedule;
        _token.transferFrom(_msgSender(), address(this), totalAmount);
       

        emit VestingScheduleCreated(
            beneficiary,
            type_of_stakeholder,
            totalAmount,
            startTime,
            cliffDuration,
            vestingDuration
        );
    }

    function claimTokens() external payable {
        VestingSchedule storage schedule = _vestingSchedules[_msgSender()];
        require(schedule.totalAmount > 0, "No vesting schedule found");
        require(
            schedule.startTime <= block.timestamp,
            "Vesting has not started yet"
        );

        uint256 claimableAmount = _calculateClaimableAmount(schedule);
        require(claimableAmount > 0, "No tokens available for claiming");
        _token.transfer(_msgSender(), claimableAmount);
        schedule.claimedAmount = schedule.claimedAmount.add(claimableAmount);
        

        emit TokensClaimed(_msgSender(), claimableAmount);
    }

    function getVestingSchedule(address beneficiary)
        external
        view
        returns (
            string memory type_of_stakeholder,
            uint256 totalAmount,
            uint256 startTime,
            uint256 cliffDuration,
            uint256 vestingDuration,
            uint256 claimedAmount
        )
    {
        VestingSchedule storage schedule = _vestingSchedules[beneficiary];

        return (
            schedule.type_of_stakeholder,
            schedule.totalAmount,
            schedule.startTime,
            schedule.cliffDuration,
            schedule.vestingDuration,
            schedule.claimedAmount
        );
    }

    function addToWhitelist(address account) external onlyOwner {
        _whitelist[account] = true;
    }

    function removeFromWhitelist(address account) external onlyOwner {
        _whitelist[account] = false;
    }

    function isWhitelisted(address account) external view returns (bool) {
        return _whitelist[account];
    }

    function _calculateClaimableAmount(VestingSchedule storage schedule)
        private
        view
        returns (uint256)
    {
        if (block.timestamp < schedule.startTime.add(schedule.cliffDuration)) {
            return 0;
        } else if (
            block.timestamp >= schedule.startTime.add(schedule.vestingDuration)
        ) {
            return schedule.totalAmount.sub(schedule.claimedAmount);
        } else {
            uint256 elapsedTime = block.timestamp.sub(schedule.startTime);
            uint256 vestingPeriod = schedule.vestingDuration.sub(
                schedule.cliffDuration
            );
            uint256 vestedAmount = schedule.totalAmount.mul(elapsedTime).div(
                vestingPeriod
            );
            return vestedAmount.sub(schedule.claimedAmount);
        }
    }

    modifier onlyWhitelisted() {
        require(_whitelist[_msgSender()], "Caller is not in the whitelist");
        _;
    }

    modifier onlyOwner() {
        require(owner == _msgSender(), "Caller is not in the whitelist");
        _;
    }
}
