#!/bin/bash
echo 'Total requests from 22025 server :'
ssh root@prh22025.prod.fedex.com "/usr/bin/mailq | grep 'Total requests:'"
echo 'Total requests from 22026 server :'
ssh root@prh22026.prod.fedex.com "/usr/bin/mailq | grep 'Total requests:'"
echo 'Total requests from 22027 server :'
ssh root@prh22027.prod.fedex.com "/usr/bin/mailq | grep 'Total requests:'"
echo 'Total requests from 22028 server :'
ssh root@prh22028.prod.fedex.com "/usr/bin/mailq | grep 'Total requests:'"