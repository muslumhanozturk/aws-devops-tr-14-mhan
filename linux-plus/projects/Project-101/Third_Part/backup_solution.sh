#!/bin/bash

# Check if we are root privilage or not
if [[ ${UID} -ne 0 ]]
then
   echo "Please use this bash script with root privilage"
   exit 1
fi

# Define the backup directory
BACKUP_DIR="/mnt/backup"

# Define the directories to be backed up
DIRECTORIES=("/home/ec2-user/data")

# Get the hostname of the instance
HOSTNAME=$(hostname)

# Get the current date and time
DATE=$(date +%F-%H-%M)

# Print start status message.
echo "We will back up ${DIRECTORIES[@]} to under ${BACKUP_DIR}"
date
echo

# Create the backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir "$BACKUP_DIR"
fi

# Iterate through the directories to be backed up
for DIR in "${DIRECTORIES[@]}"; do
    # Create the filename for the backup
    FILENAME="$BACKUP_DIR/$HOSTNAME-$DATE-$(basename $DIR).tgz"

    # Create the backup using tar
    tar -zcvf "$FILENAME" "$DIR"
    # tar "/mnt/backup/ec2-user-060606-data.tgz" "/home/ec2-user/data"
     
    # Print the backup file name
    echo "Backup file: $FILENAME"
done

# Run "sed -i -e 's/\r$//' scriptname.sh" command before running script.

# Print end status message.
echo
echo "Congrulations! Your Backup is ready"
date

# Install cronjob on your 2023 AMI instance
sudo yum install cronie -y
sudo systemctl enable crond.service
sudo systemctl start crond.service

# To set this script for executing in every 5 minutes, we'll create cronjob
```bash
crontab -e
```

```bash
*/5 * * * * sudo /home/ec2-user/backup.sh
```

# To see a listing of the archive contents. From a terminal prompt type:
tar -tzvf /mnt/backup/ip-172-31-89-147-2021_11_02_12_26_AM.tgz

# To restore a file from the archive to a different directory enter:
tar -xzvf /mnt/backup/ip-172-31-89-147-2021_11_02_12_26_AM.tgz -C /tmp etc/hosts
