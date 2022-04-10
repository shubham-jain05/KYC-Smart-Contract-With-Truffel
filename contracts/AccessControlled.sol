//pragma solidity ^0.5.9;

contract AccessControlled {
    
    address ownerAddress;
    bool public isAdmin;

    constructor(address _ownerAddress, bool _isAdmin) public {
        isAdmin = _isAdmin;
        ownerAddress = _ownerAddress;
    }

    // We define the modifiers used as part of our functions here.
    modifier onlyAdmin {
        require(isAdmin, "Only the admin can perform this operation");
        _;
    }
}