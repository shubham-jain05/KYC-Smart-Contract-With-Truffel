# KYC smart contract Deployment over Truffle

# Installing Truffle
Before you can use Truffle, you will have to install it using npm. Open a terminal and use the following to install it globally.
<h6>npm install -g truffle</h6>

# Compiling
Compile the smart contracts navaigate the project forlder run commmend:

<h6>truffle compile</h6>
  
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
 
  
 # Migrating with Ganache
While Truffle Develop is an all-in-one personal blockchain and console, you can also use Ganache, a desktop application, to launch your personal blockchain. Ganache can be a more easy-to-understand tool for those new to Ethereum and the blockchain, as it displays much more information up-front.

The only extra step, aside from running Ganache, is that it requires editing the Truffle configuration file to point to the Ganache instance.

1) Download and install Ganache.

2) Open truffle-config.js in a text editor. Replace the content with the following:


module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*"
    }
  }
};

This will allow a connection using Ganache's default connection parameters.

1) Save and close that file.

2) Launch Ganache. 

# Ganache

On the terminal, migrate the contract to the blockchain created by Ganache:

truffle migrate
  
  
  
