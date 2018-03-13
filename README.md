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
