!#/bin/bash -xe
yum update -y aws-cfn-bootstrap
yum install -y git
yum install -y ansible --enablerepo=epel
pip install ansible
pip install boto3
cd /home/ec2-user
git clone git://github.com/ansible/ansible.git --recursive
source /home/ec2-user/ansible/hacking/env-setup
aws s3 cp s3://your-bucket/deploy_drupal.yaml .
aws s3 cp s3://your-bucket/Drupal.template .
aws ec2 create-key-pair --key-name DrupalKey --query 'KeyMaterial' --output text > DrupalKey.pem
cp DrupalKey.pem /root/.ssh/
chmod 600 /root/.ssh/DrupalKey.pem
ssh-agent bash
ssh-add /root/.ssh/DrupalKey.pem
ansible-playbook deploy_drupal.yaml
