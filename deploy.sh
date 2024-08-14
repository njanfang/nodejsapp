#!/bin/bash


#navigate to the directy of jenkins workspace


#copy to project dir
cp -r /var/nodeapp/nodejsapp /var/nodeapp/new_nodejsapp


#navigate to dir

cd /var/nodeapp

#find the process pid of instance 3000

PID=$(lsof -t -i :3000)

#if the pid not empty the kill it
if [ -n "$PID" ]; then
    su -c "kill -9 $PID" -s /bin/bash root
fi

#stop the pm2 process
pm2 stop ecosystem.config.js

#install nodejs

npm install

#start app with pm2

pm2 start ecosystem.config.js

#output

echo "the deployment is successfully , running on port 3000 with new pid of instance & pm2 "
