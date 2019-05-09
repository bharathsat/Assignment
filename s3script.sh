#!/bin/bash

#Files and its absolute paths
objfile="/tmp/objectfile"
sizeofbkt="/tmp/bktsize"
outputfile="/tmp/output"
awsconfig="~/.aws/credentials"

#Emptying files
>$objfile
>$sizeofbkt
>$outputfile

#Required variables
stprice=0.023
pvpriec=0.022
objc=1
objs=0
noobj=0
mb=1024

#Verifiying and configuring awscli
which aws >/dev/null

if [[ $? -ne 0 ]]; then
        echo "aws cli is not installed"
        pipvar=`pip --version | rev | awk '{print $1 $2}' | rev | sed 's/[^a-z  A-Z]//g'`
        if [[ $pipvar -ne "python" ]]; then
                echo "Installing pip to install aws-cli"
                curl -O https://bootstrap.pypa.io/get-pip.py
                sleep 2
                python get-pip.py >/dev/null
                sleep 2
                echo "Installing Awscli..."
                pip install awscli
        else
                echo "Installing Awscli...."
                pip install awscli
        fi
        read -p "Enter aws_access_key_id: "  username
        read -p "Enter aws_secret_access_key: "  password
        echo "[default]" >>$awsconfig
        echo "aws_access_key_id = $username" >>$awsconfig
        echo "aws_secret_access_key = $password" >>$awsconfig
        echo "Awscli is installed and configured properly"
else
        echo "aws cli is installed"
fi


#s3 commands
bkts=(`aws s3 ls | awk '{print $3}'`)

for bkt in ${bkts[@]}; do
        aws s3 ls s3://$bkt --recursive | grep -v -E "(Bucket: |Prefix: |LastWriteTime|^$|--)" | awk 'BEGIN {total=0}{total+=$3}END{print total/1024/1024" MB"}' >>$sizeofbkt
        aws s3 ls s3://$bkt/ --recursive | wc -l >>$objfile
done

#Calculate the size of objects in all buckets
while read -r objsize; do
        size=`echo $objsize | awk '{print $1}'`
        ns=`printf %0.2f ${size}`
        objs=`echo "${objs} + ${ns}" | bc`
done < "$sizeofbkt"


#Calculate no.of objects in all bucktes
while read -r objc; do
        noobj=`echo "${noobj} + ${objc}" | bc`
done < "$objfile"
echo "Total number of objects in buckets = $noobj" >>$outputfile

#Storage cost calculation
gbsize=`echo "${objs} / ${mb}" | bc`
tbsize=`echo "${gbsize} / ${mb}" | bc`
echo "Total bucket size = $gbsize GB" >>$outputfile

if [ ${tbsize} -ge 50 ]; then
        echo "Size of all objects are exided more than 50TB" >>$outputfile
        total=`echo "${gbsize} * ${pvprice}" | bc`
        echo "Total cost for the s3 storage is =$total USD" >>$outputfile
else
        total=`echo "${gbsize} * ${stprice}" | bc`
        echo "Total cost for the s3 storage is =$total USD" >>$outputfile
fi

cat $outputfile
