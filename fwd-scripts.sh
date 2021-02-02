#!/bin/bash
RED='\033[0;31m' #Red Text
NC='\033[0m' # No Color
port=$1

# Usage Messages
if [ "$1" = "--help" ] ; then
  echo "Usage ./fwd-scripts.sh PORT"
  exit 0
fi
if [[ $# -eq 0 ]] ; then
    echo 'No port Supplied, quitting!'
    exit 1
fi
if [[ $1 =~ ^[0-9]+$ ]];then
      echo -e "${RED}$1${NC} is a number, we will use this ;)"
   else
      echo -e "${RED}$1${NC} is not a number, what are you doing?!?!? try ${RED}--help${NC} instead "
      exit 1
fi

#Find out our public ip
ip=$(curl -s ifconfig.me)

# Opening port on AWS EC2 Console
echo -e "Opening port ${RED}$1${NC} on AWS EC2 Console"
aws ec2 authorize-security-group-ingress --group-id XXXXXXXXXXXXXXXXXXX --ip-permissions IpProtocol=tcp,FromPort=$1,ToPort=$1,IpRanges='[{CidrIp=0.0.0.0/0}]'
echo ""
echo ""
echo -e "Check the AWS Firewall group | Grepping for ${RED}$1${NC}"
aws ec2 describe-security-groups --group-ids XXXXXXXXXXXXXXXXXXXXXXXX | grep $1
echo ""
echo "As you are using this as a forwarder, go to your firewall and allow the traffic in, I'm using PfSense, so..."
echo -e "Go and edit PfSense - https://192.168.X.X:XXXX/firewall_nat.php"
echo -e "Edit NAT rule on PfSense to allow traffic from"
echo -e "${RED}$ip${NC} and change the port to ${RED}$1${NC}"

#Enable port forwarding
echo -e "running this command - socat TCP4-LISTEN:${RED}$1${NC},fork TCP4:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:${RED}$1${NC}"

socat TCP4-LISTEN:$1,fork TCP4:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:$1
# Press Ctrl + C to quit
echo "cleaning up and quitting"
echo -e "removing ${RED}$1${NC} from AWS Firewall - if port is not shown directly below then it was successful and port was removed from AWS Console"
aws ec2 revoke-security-group-ingress --group-id XXXXXXXXXXXXXXXXXXXXXXXXXx --ip-permissions IpProtocol=tcp,FromPort=$1,ToPort=$1,IpRanges='[{CidrIp=0.0.0.0/0}]'
aws ec2 describe-security-groups --group-ids XXXXXXXXXXXXXXXXXXXXXXXXXXXXX | grep $1
echo ""
echo ""
echo "killing SOCAT"
