# CD12352 - Infrastructure as Code Project Solution

# Chukwuemeka Ilozor

## Spin up instructions

1. Install the AWS CLI (if not already installed)
Ensure you have the AWS Command Line Interface (CLI) installed. If not, you can install it using the instructions here.

To check if it’s installed, run:
`aws --version`

2.  Configure the AWS CLI

   Set up the AWS CLI with your credentials and default region:

   `aws configure`

### You will be prompted to enter:

<ul>

<li>

AWS Access Key ID
 </li>

<li>

AWS Secret Access Key
</li>

<li>

Default region (e#.g., us-east-1)
</li>
<li>Default output format (e.g., json)</li>
</ul>
3. Run the Key Pair Creation Command
Use the following command to create a new Key Pair:

`aws ec2 create-key-pair --key-name "MyKeyPair" --query 'KeyMaterial' --region us-east-1 --output text > "MyKeyPair.pem"`

### What the command does:

<ul>
   <li>--key-name: Specifies the name of the new Key Pair (MyKeyPair). Replace this with your preferred name.</li>
   <li>--query 'KeyMaterial': Filters the output to retrieve only the private key content.</li>
   <li>--output text: Outputs the private key as plain text.</li>
   <li>> "MyKeyPair.pem": Saves the private key to a file named MyKeyPair.pem.</li>
</Ul>

**Alternatively you can create a key pair named MyKeyPair using AWS console**
This ensures only the file owner can read the key, as required by SSH.

1. Verify the Key Pair
If you need to confirm the Key Pair exists in AWS, use:

`aws ec2 describe-key-pairs --key-names "MyKeyPair"`

## Tear down instructions
## SSH Connect from Local Computer with Agent Forwarding

## 1. Set the Correct Permissions
   <ul>
   <li>Set the Correct Permissions SSH keys to restricted permissions for security purposes.</li>

   Use the following command to set the appropriate permissions:

    `chmod 400 ./MyKeyPair.pem`

   <li>This makes the file readable only by your user account </li>

</ul>

##  2. Start the SSH Agent
<ul><li>Ensure the ssh-agent is running. Start it using:` eval "$(ssh-agent -s)" `
</li>
<li>This command initializes the agent and outputs its process ID.</li></ul>

## 3. Add the Key to the SSH Agent

<ul>

<li>

Run the command: 

` ssh-add ./MyKeyPair.pem `

</li>

<li>

If the key is passphrase-protected, you'll be prompted to enter the passphrase. Once entered, the key is loaded into the agent's memory for use during the session.
</li>
</ul>

## 4. Run the script to  Network and WebApp Stacks

<ul>

<li>

`./projectscript.sh`
</li>

## Note: You must create the network stack first before createting  the stack for the WebApp.
Type 1 _to create the network stack_.  
Then when prompted to enter template file for network stack: _Type network.yml_

Also when prompted to enter parameter file for network stack: _Type network-parameters.json_

</li>

## Then you create the webApp  stack after you have confirm that the network stack was created succesfully..
Type 2 _to create the server stack_. 
Then when prompted to enter template file for Server stack: _Type udagram.yml_

Also when prompted to enter parameter file for server stack: _Type udagram-parameters.json_
</ul>

## 5. Connect to the remote Bastion)host from your local system

`ssh -A -i ./MyKeyPair.pem ubuntu@[Bastion IP]`

## 6. Connect to the remote  udagram-webApp server from Bastion)host  system

`ssh ubuntu@[udagram-webApp IP]`

## Other considerations

### To Clone the Repository in Github:

`git clone https://github.com/chukwuemeka69/deploy-high-availability-webApp.git`

`cd deploy-high-availability-webApp`
