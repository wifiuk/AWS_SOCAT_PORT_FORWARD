# AWS_SOCAT_PORT_FORWARD

This script is designed for using AWS and SOCAT as a forwarder to another IP or Server, for Red Team engagements where you want to hide your home console location .

Usage

./fwd-scripts.sh PORT-NUMBER


Before you start you will need a few things

sudo apt install socat

sudo snap install aws-cli --classic


Then you need to confifure AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/aws-cli.pdf)

aws configure


You will need to edit the XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX in the script to your own information such as

--group-ids XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX (replace XXXXXX with your own firewall sg from AWS console)



socat TCP4-LISTEN:$1,fork TCP4:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:$1 (replace the XXXXX with your IP address you want to forward traffic to)


Hope this is of some use? Really you should use terraform and do it right, but im lazy and this did what i needed it to do! Quick and dirty.
