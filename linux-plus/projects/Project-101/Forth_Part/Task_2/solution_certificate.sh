MY_KEY=$(cat certificate.pem)

echo $MY_KEY # This command is used for seeing the difference between echo -e 

echo -e $MY_KEY > new.pem

cat certificate.pem | sed -e 's/\\n/\n/g' # Another way to solve it