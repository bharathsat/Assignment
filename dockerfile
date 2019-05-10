#Using centosbase image
FROM centos 

#Copying nginx repo
COPY nginx.repo /etc/yum.repos.d/

#installing dependencies
RUN yum -y install epel-release
RUN yum -y install gcc c++ make
RUN yum -y install nodejs
RUN yum -y update
RUN yum -y install nginx


#Creating working directory
WORKDIR /assignmnt

#Copying project related docs
COPY . /assignmnt
COPY nginx.conf /etc/nginx/nginx.conf

#Making port 80 to outside of this container
EXPOSE 80 

#Starting application
CMD [ "nginx", "-g", "daemon off;" ]
CMD [ "npm", "start" ]

