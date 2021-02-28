if test -d /codetest
then
sudo cp -v -r -f * /codetest
else
sudo mkdir /codetest
sudo cp -v -r -f * /codetest
fi 