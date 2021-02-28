if test -d /production_code
then
sudo cp -v -r -f * /production_code
else
sudo mkdir /production_code
sudo cp -v -r -f * /production_code
fi