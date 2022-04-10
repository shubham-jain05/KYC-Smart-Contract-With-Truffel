# KYC smart contract Deployment over Truffle

# Installing Truffle
Before you can use Truffle, you will have to install it using npm. Open a terminal and use the following to install it globally.
npm install -g truffle

# Compiling
Compile the smart contracts:

truffle compile
You will see the following output:


Compiling .\contracts\AccessControled.sol...
Compiling .\contracts\KYC.sol...
Compiling .\contracts\Migrations.sol...

Writing artifacts to .\build\contracts

# Smart Contract Flow
  The bank collects the information for the KYC from the customer.

  The information given by the customer includes username and customer data, which is the hash of the link for the customer data. This username is unique for each  customer. 

  A bank creates the request for submission, which is stored in the smart contract.

  A bank then verifies the KYC data, which is then added to the customer list.

  Other banks can get customer information from the customer list.

  Other banks can also provide upvotes/downvotes on customer data to showcase the authenticity of the data. If the number of upvotes is greater than the number of downvotes, then the kycStatus of that customer is set to true. If a customer gets downvoted by one-third of the banks, then the kycStatus of the customer is changed to false even if the number of upvotes is more than that of downvotes. For such logic, there should be a minimum of 5 or 10 banks in the network. 

  In short, there are two conditions to be checked: The number of upvotes and downvotes and whether the number of downvotes is greater than one-third of the total number of banks. 

  Banks can also complain against other banks if they find the bank to be corrupt and if it is verifying false customers. Such corrupted banks will then be banned from upvoting/downvoting further. If more than one-third of the total banks in the network complain against a certain bank, then the bank will be banned (i.e., set isAllowedToVote to false of that corrupt bank.)
