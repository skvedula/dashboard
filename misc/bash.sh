#!/bin/bash
ssh root@prh22025.prod.fedex.com "/usr/bin/mailq | grep 'Total requests:'"
echo '\n'
ssh root@prh22026.prod.fedex.com "/usr/bin/mailq | grep 'Total requests:'"
echo '\n'
ssh root@prh22027.prod.fedex.com "/usr/bin/mailq | grep 'Total requests:'"
echo '\n'
ssh root@prh22028.prod.fedex.com "/usr/bin/mailq | grep 'Total requests:'"
echo '\n'