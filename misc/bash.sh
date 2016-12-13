#!/bin/bash
echo 'Getting info from server 22025'
ssh root@prh22025.prod.fedex.com "/usr/bin/mailq | grep 'Total requests:'"
echo 'Getting info from server 22026'
ssh root@prh22026.prod.fedex.com "/usr/bin/mailq | grep 'Total requests:'"
echo 'Getting info from server 22027'
ssh root@prh22027.prod.fedex.com "/usr/bin/mailq | grep 'Total requests:'"
echo 'Getting info from server 22028'
ssh root@prh22028.prod.fedex.com "/usr/bin/mailq | grep 'Total requests:'"