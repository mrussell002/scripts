#!/bin/bash

# does this host have internet access
inet="no"

# see if dns resolution is working
if [ $inet == "yes" ]; then
	dig @10.100.1.10 www.google.com
fi

# restart named if needed
if [ $? != 0 ] && [ $inet == "yes" ]; then
        echo "Named is not working, restarting..."
        logger System TechOps-Named not working, restarting service
        service named restart

else
        echo "Named is working, doing nothing...."
fi
