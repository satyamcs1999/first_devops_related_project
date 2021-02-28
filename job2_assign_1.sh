if sudo docker ps | grep production
then
echo "Already running"
else
sudo docker run -d -it -p 8081:80  -v /production_code:/usr/local/apache2/htdocs/  --name production httpd
fi