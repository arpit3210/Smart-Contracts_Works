// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenVesting {
    struct VestingSchedule {
        uint256 totalTokens;
        uint256 startTime;
        uint256 cliffDuration;
        uint256 vestingDuration;
        uint256 claimedTokens;
    }

    mapping(address => VestingSchedule) public vestingSchedules;
    IERC20 public token;

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    function createVestingSchedule(
        address _beneficiary,
        uint256 _totalTokens,
        uint256 _startTime,
        uint256 _cliffDuration,
        uint256 _vestingDuration
    ) external {
        require(
            vestingSchedules[_beneficiary].totalTokens == 0,
            "Vesting schedule already exists"
        );
        require(_totalTokens > 0, "Total tokens must be greater than zero");
        require(
            _startTime >= block.timestamp,
            "Start time must be in the future"
        );
        require(
            _cliffDuration <= _vestingDuration,
            "Cliff duration cannot exceed vesting duration"
        );

        VestingSchedule memory schedule = VestingSchedule(
            _totalTokens,
            _startTime,
            _cliffDuration,
            _vestingDuration,
            0
        );

        vestingSchedules[_beneficiary] = schedule;
    }

    function claimTokens() external {
        VestingSchedule storage schedule = vestingSchedules[msg.sender];
        require(
            schedule.totalTokens > 0,
            "No vesting schedule found for the address"
        );

        uint256 vestedTokens = calculateVestedTokens(schedule);

        uint256 tokensToClaim = vestedTokens - schedule.claimedTokens;
        require(tokensToClaim > 0, "No tokens available for claiming");

        schedule.claimedTokens += tokensToClaim;
        token.transfer(msg.sender, tokensToClaim);
    }

    function calculateVestedTokens(VestingSchedule memory _schedule)
        internal
        view
        returns (uint256)
    {
        if (block.timestamp < _schedule.startTime) {
            return 0;
        } else if (
            block.timestamp < _schedule.startTime + _schedule.cliffDuration
        ) {
            return 0;
        } else if (
            block.timestamp >=
            _schedule.startTime + _schedule.vestingDuration
        ) {
            return _schedule.totalTokens;
        } else {
            uint256 elapsedTime = block.timestamp - _schedule.startTime;
            uint256 vestedDuration = _schedule.vestingDuration -
                _schedule.cliffDuration;
            return
                (_schedule.totalTokens * elapsedTime) /
                vestedDuration;
        }
    }
}
