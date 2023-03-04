#!/bin/bash

sudo service docker start
sudo docker run -p 8080:6000 -d gstmoniz/app-node:1.4