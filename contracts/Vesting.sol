//SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import "./ClaverToken.sol";

contract Vesting{
  address public owner;
  ClaverToken token;
  uint constant TOKEN_RELEASE_INTERVAL = 60;
  uint constant TOKEN_RELEASE_LENGTH_IN_MINS = (((60 * 60) * 24) * 365) / 60;
  uint constant NUMBER_OF_MIN_PER_DAY = ((60 * 60) * 24);
  address[] public shareHolders;

  constructor(ClaverToken _token){
    owner = msg.sender;
    token = _token;
  }

  function releaseTokens() public {
   
  }
}
