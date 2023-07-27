// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract Whitelist {
    error SENDER_ALREADY_WHITELISTED();
    error WHITE_LISTLIMIT_REACHED();

    uint8 public MAX_WHITE_LISTED_ADDRESSES;
    uint8 public numAddressesWhiteListed;
    mapping(address => bool) public whitelistedAddresses;

    constructor(uint8 _maxWhitelistedAddresses) {
        MAX_WHITE_LISTED_ADDRESSES = _maxWhitelistedAddresses;
    }

    function addAddressToWhitelist() public {
        if (whitelistedAddresses[msg.sender]) {
            revert SENDER_ALREADY_WHITELISTED();
        } else {
            if (numAddressesWhiteListed > MAX_WHITE_LISTED_ADDRESSES) {
                revert WHITE_LISTLIMIT_REACHED();
            }
            whitelistedAddresses[msg.sender] = true;
            numAddressesWhiteListed += 1;
        }
    }
}
