if sudo docker ps -a | grep testing
then
sudo docker rm -f testing
sudo docker run -d -i -t -v /codetest:/usr/local/apache2/htdocs/  --name testing httpd
else
sudo docker run -d -i -t -v /codetest:/usr/local/apache2/htdocs/  --name testing httpd
fi
