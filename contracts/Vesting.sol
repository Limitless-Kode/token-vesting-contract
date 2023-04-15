//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "./ClaverToken.sol";

contract Vesting{
  address public owner;
  ClaverToken token;
  address[] beneficiaries;
  uint BENEFICIARY_LIMIT = 10;
  uint startDate;
  uint endDate;
  uint releaseInterval;
  uint tokensReleased;

  constructor(ClaverToken _token, uint _startDate, uint _endDate, uint _releaseInterval){
    owner = msg.sender;
    token = _token;
    startDate = _startDate;
    endDate = _endDate;
    releaseInterval = _releaseInterval;
  }

  function addBeneficiary(address _beneficiary) public{
    require(msg.sender == owner, "Only contract deployer can add beneficiaries.");
    require(beneficiaries.length < BENEFICIARY_LIMIT, "Beneficiaries list is full");
    beneficiaries.push(_beneficiary);
  }

  function getTokensReleased() public view returns(uint){
    return tokensReleased;
  }


  function release() public{
    bool isBeneficiary = false;
    for(uint i = 0; i < beneficiaries.length; i++){
      if(msg.sender == beneficiaries[i]){
        isBeneficiary = true;
        break;
      }
    }
    require(msg.sender == owner || isBeneficiary, "Only owner or beneficiaries can release tokens");

    uint tokensToRelease = calculateTokensToRelease();
    require(tokensToRelease > 0, "There are no tokens to release at the moment");
    require(token.balanceOf(address(this)) > tokensToRelease, "No tokens available to release");

    tokensReleased += tokensToRelease;
    for(uint i = 0; i < beneficiaries.length; i++){
      token.transferFrom(address(this), beneficiaries[i], tokensToRelease/beneficiaries.length);
    }

  }

  function calculateTokensToRelease() public view returns(uint256){
    uint256 tokensAvailable = token.balanceOf(address(this));
    uint256 totalSupply = token.getTotalSupply();
    require(tokensAvailable > 0, "Contract has no tokens");
    uint256 elapsedTime = block.timestamp - startDate; // time in seconds since the vesting started
    uint256 intervalsPassed = elapsedTime / releaseInterval; // number of release intervals passed since start date
    uint256 tokensPerInterval = totalSupply / uint256((endDate - startDate) / releaseInterval);

    uint tokensToRelease = (tokensPerInterval * intervalsPassed) - tokensReleased;

    return tokensToRelease;
  }

}
