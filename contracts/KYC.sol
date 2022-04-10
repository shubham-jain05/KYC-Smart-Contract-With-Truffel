//pragma solidity ^0.5.9;

import './AccessControlled.sol';

contract KYC  is AccessControlled { 

	struct Customer  {
		string userName;
		string customerData;
        bool kycStatus;
        int256 downVote;
        int256 upVote;
        address bank;
	}
    
    mapping(string => Customer) public customers;

    struct KYC_request {
        string userName;
        address bankAddress;
        string customerData;
    } 

    mapping(string => KYC_request) public KYC_requests;
    
    struct Bank {
        string bankName;
        address ethAddress;
        int256 complaintsReported;
        int256 KYC_count;
        bool isAllowToVote;
        string regNumber;
    }

    mapping(address => Bank) public banks;
    address[] bankCount;


    constructor() AccessControlled(msg.sender,true) public {
		// No action required here.
	}


    //Cusomer functions 
    function addCustomer(string memory _userName, string memory _customerData) public {
        require(customers[_userName].bank == address(0), "Customer is already present, please call modifyCustomer to edit the customer data");
        customers[_userName].userName = _userName;
        customers[_userName].customerData = _customerData;
        customers[_userName].bank = msg.sender;
        customers[_userName].kycStatus  = false;
        customers[_userName].downVote  = 0;
        customers[_userName].upVote = 0;
    }
    
    function viewCustomer(string memory _userName) public view returns (string memory, string memory, address) {   
        require(keccak256(abi.encodePacked(customers[_userName].userName)) ==  keccak256(abi.encodePacked(_userName)), "Customer is not present in the database");
        return (customers[_userName].userName, customers[_userName].customerData, customers[_userName].bank);
    }
    
    function modifyCustomer(string memory _userName, string memory _newcustomerData) public {
        address bankAddress = customers[_userName].bank;
        require(customers[_userName].bank != address(0), "Customer is not present in the database");
        require(banks[bankAddress].isAllowToVote != true, "This bank is not allow to do KYC of customer .");
        customers[_userName].customerData = _newcustomerData;
    }    
  
    //Bank Interface 
    function addRequest(string memory _userName, string memory _customerData) public {
	    address bankAddress = customers[_userName].bank;
        require(customers[_userName].bank != banks[bankAddress].ethAddress, "Customer is not present in the bank system.");   
        require(customers[_userName].kycStatus != true, "This user KYC Request is already added!");      
        require(banks[bankAddress].isAllowToVote != true, "This bank is not allow to do KYC of customer .");
        KYC_requests[_userName].userName = _userName;
		KYC_requests[_userName].customerData = _customerData;
        KYC_requests[_userName].bankAddress = bankAddress;
        banks[bankAddress].KYC_count = banks[bankAddress].KYC_count + 1;
        customers[_userName].kycStatus = true;
	}

    function removeRequest(string  memory _customerUserName) public {
	    require(keccak256(abi.encodePacked(KYC_requests[_customerUserName].userName)) == keccak256(abi.encodePacked(_customerUserName)), "This user KYC request has NOT exist yet!");   
		customers[_customerUserName].kycStatus = false;
        delete KYC_requests[_customerUserName];
	}
    
    function bankComplaints(address _bankAddress) public {
       require(_bankAddress == banks[_bankAddress].ethAddress, "Bank is not exist yet.");
       banks[_bankAddress].complaintsReported =  banks[_bankAddress].complaintsReported + 1;   
    }
       
    function upVoteCustomer(string memory _userName)  public { 
       address bankAddress = customers[_userName].bank;
       require(banks[bankAddress].isAllowToVote != true, "This bank is not allow to do vote for customer.");
       require(keccak256(abi.encodePacked(customers[_userName].userName)) ==  keccak256(abi.encodePacked(_userName)), "Customer is not present in the database");
       customers[_userName].upVote = customers[_userName].upVote + 1;
    }

    function  downVoteCustomer(string memory _userName) public {
       address bankAddress = customers[_userName].bank;
       require(banks[bankAddress].isAllowToVote != true, "This bank is not allow to do vote for customer.");
       require(keccak256(abi.encodePacked(customers[_userName].userName)) ==  keccak256(abi.encodePacked(_userName)), "Customer is not present in the database");
       customers[_userName].downVote = customers[_userName].downVote + 1;          
    }


    function  viewBankDetils(address _bankAddress) public view returns (string memory,string memory, bool, int256, int256) {
        require(_bankAddress == banks[_bankAddress].ethAddress, "Bank is not exist yet.");
        return (banks[_bankAddress].bankName, 
               banks[_bankAddress].regNumber, 
               banks[_bankAddress].isAllowToVote, 
               banks[_bankAddress].complaintsReported, 
               banks[_bankAddress].KYC_count);
    }

    function reportBank(address _bankAddress, string memory _bankName) public {
      require(_bankAddress == banks[_bankAddress].ethAddress, "Bank is not exist yet.");
      require(keccak256(abi.encodePacked(banks[_bankAddress].bankName)) ==  keccak256(abi.encodePacked(_bankName)), "Bank is not valid yet.");   
      int256 calcComplaint =  int(bankCount.length / 3);
      if(calcComplaint > banks[_bankAddress].complaintsReported){
            banks[_bankAddress].isAllowToVote = false;
      }              
    }
  

    // Admin functions
    function addBank(string calldata bankName, address _bankAddress, string calldata bankRegNumber)  external onlyAdmin {
       require(isAdmin, "Only ddmin can add new bank.");
       require(_bankAddress != banks[_bankAddress].ethAddress, "Bank is already exist yet.");
       banks[_bankAddress].bankName  = bankName;
       banks[_bankAddress].ethAddress = _bankAddress;  
       banks[_bankAddress].complaintsReported = 0;
       banks[_bankAddress].KYC_count = 0;
       banks[_bankAddress].isAllowToVote = true;
       banks[_bankAddress].regNumber = bankRegNumber;  
    }
   
    function bankisAllowedToVote(address _bankAddress, bool isAllowToVote)  external onlyAdmin  {
       require(isAdmin, "Only admin can add new bank.");
       require(_bankAddress == banks[_bankAddress].ethAddress, "Bank is not exist yet.");
       banks[_bankAddress].isAllowToVote = isAllowToVote;      
       bankCount.push(_bankAddress);
    }
    
    function removeBnak(address _bankAddress) external onlyAdmin  {
	  require(isAdmin, "Only ddmin can add new bank.");
      require(_bankAddress == banks[_bankAddress].ethAddress, "Bank is not exist yet.");
      delete banks[_bankAddress]; 
      for(uint i = 0; i< bankCount.length; i++){
          if(bankCount[i] ==_bankAddress){
             delete bankCount[i];
          }
      }   
    }
}