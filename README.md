# Assignment
Shell script and docker file
## Shell script 
Steps to consider to execute the script
1. Install awscli on the machine and configure keys, incase if you are not using aws instance.
2. Create IAM role with required access and attach the role to instance if you are running this script in the aws instance.
3. Output will be displayed on the screen also saved on the file ```/tmp/output```.
4. Find the sample output below
```
bharath.sat@xxxxxxxx:~$ ./assignment.sh
aws cli is installed
Configuring default accesskey and secret key's
AWS Access Key ID [None]: AKIAZ77IJUDR6OSH5QX2
AWS Secret Access Key [None]: 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
Default region name [None]: us-east-1
Default output format [None]:
Total number of objects in buckets = 270
Total bucket size = 11 GB
Total cost for the s3 storage is =.253 USD
bharath.sat@xxxxxxxx:~$
```


## Docker
1. Attached docker file and nginx config file which can be used to build the image.
2. Run ```docker build --tag=assignment``` to build the image.
3. Run ```docker run -d -p 80:3000 assignment``` to run the docker.
