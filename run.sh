docker rm -f phpldapadmin 

docker run --name phpldapadmin -d 80 $*
