# Ansible-Cloudformation
A project to use AWS Cloudformation to build an Ansible server that deploys Cloudformation Stacks Agentlessly

The basic premise of this project is to use AWS tools to create an Ansible server, via Cloudformation. This 
Ansible server can be used to deploy other CF stacks.  In this example, I modified a sample Drupal Single Site install to test the 
playbook.

The files include:

cf_final.json - AWS Cloudformation template that will deploy a simple server, then, via the userdata field, install and ocnfigure Ansible. It will then automatically deploy the ansible playbook via a CF template.

deploy_drupal.yaml - this is the playbook that calls the CF template for Drupal install.

Drupal.template - This is the template that is used to create the CF stack and start web services

userdata.sh - this is the userdata script that is called during the initial CF stack creation to install Ansible.


The steps highlight the process and any notes I took along the way.

When this process is done you should have two publicly accessible servers. One serving a simple Drupal site.


# Steps

1. The first step is to configure your local system to run aws cli against your AWS environment

aws configure (fill in the appropriate information)

2. I decided to keep all my templates and files in a S3 bucket, so you can create your bucket then cp or sync your local directory

asw s3api create-bucket --bucket your-bucket-name-bucket --region us-east-1
aws s3 cp file1 s3://your-bucket-name-bucket/ or aws s3 sync . s3://your-bucket-name-bucket

3. The next step is to generate a keypair. This keypair is used for SSH access to your instance once it's live.

aws ec2 create-key-pair --key-name YourKey --query 'KeyMaterial' --output text > YourKey.pem

4. Next, if you don't have a default VPC assigned, this is used in place of specifically selecting or creating a VPC.

aws ec2 create-default vpc

5. Once your templates and files are in place, you can launch the CF stack creation process. If you use my templates and files, this will first create a new Instance, install Ansible on the instance, then run an Ansible playbook that will then deploy another CF stack containging a template for a Single Site Drupal Instance. You can feed various parameters via the command. In this example, I'm telling it what keypair to use.

aws cloudformation create-stack --stack-name YourStackName --template-url https://s3.amazonaws.com/your-bucket-name-bucketbucket/cf_final.json --parameters ParameterKey=KeyName,ParameterValue=YourKey

***AT THIS POINT YOU SHOULD SEE TWO STACKS COME TO LIFE***
***IF YOU DO NOT SEE THE SECOND STACK, YOU CAN LOG INTO THE FIRST INSTANCE VIA THE KEYPAIR YOU CREATED AND THE PUBLIC IP***
aws ec2 describe-addresses |grep PublicIp
ssh -i YourKey.pem ec2-user@xx.xx.xx.xx (output from previous command)
cat /var/log/cloud-init-output.log  (this will tell you where your userdata script might have failed.



