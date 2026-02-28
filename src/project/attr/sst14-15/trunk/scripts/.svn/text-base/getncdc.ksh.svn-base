#!/bin/ksh
source ~/.profile
#######################################################################
#                                                                     #
# SCRIPT: getncdc.ksh                                                 #
# LANGUAGE:  korn Shell                                               #
# MACHINE:   Compute Farm                                             #
# ACCOUNT  dunger.tst                                                 #
#---------------------------------------------------------------------#
# INITIATION METHOD:  Called from Parent Script NCDCfinal.ksh or      #
#   Can be run independently from parent scripts too.                 #
#---------------------------------------------------------------------#
# PURPOSE: examines the NCDC ftp site and pulls NCDC Climate division #
#    data if the 'procdate.txt' files agrees with the current month   #
#    if the parent script calls for backdating, the script will       #
#    squawk (print a message) and transfer anyway.                    #
#---------------------------------------------------------------------#
# USAGE:   ./getncdc.ksh                                              #
#---------------------------------------------------------------------#
# INPUT FILES:  Input files hardwired NCDC ftp addresses              #
#            procdate.txt - gives the date of NCDC data               #
#          climdiv-pcpndv-v1.0.0-YYYYMMDD - NCDC precip data          #
#          climdiv-pcpndv-v1.0.0-YYYYMMDD - NCDC temperature data     #
# OUTPUT FILES:  ncdcdivp.txt - Ncdc precip data, renamed to standard #
#                file name, as is ncdcdivp.txt                        #
# SOURCED FILES:                                                      #
#---------------------------------------------------------------------#
# SUBROUTINE USED: No external scripted routines                      #
# EXECUTABLES USED:   none                                            #
#---------------------------------------------------------------------#
#Get todays date and move to a work directory
pid='pid_107'
process_dir='$MAKECDS no quotes'
process_dir='/cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/scripts'
controldir='../library'
workdir='../work'
objectdir='../build'
logdir='../logs'
cd ${process_dir}
cd ${workdir}

      MM=`date +%m`
      YYYY=`date +%Y`
wget ftp.ncdc.noaa.gov:/pub/data/cirs/climdiv/procdate.txt 
DT=`grep ${YYYY}${MM} procdate.txt`
echo ${DT} ' will be appended to file names to locate them properly ' 
if [ " ${DT}" = " " ]; then
#   data are not there yet, but get the most recent file anyway, since
#   we may have cleaned out the existing files to avoid conflicts. 
#   and we may be requesting a back-dated processing. 
  echo "no new ncdc data yet "
  cat procdate.txt
  DT=`cat procdate.txt`
  echo ${DT}
  wget ftp.ncdc.noaa.gov:/pub/data/cirs/climdiv/climdiv-pcpndv-v1.0.0-${DT} 
  wget ftp.ncdc.noaa.gov:/pub/data/cirs/climdiv/climdiv-tmpcdv-v1.0.0-${DT} 
  mv climdiv-pcpndv-v1.0.0-${DT} ncdcdivp.dat
  mv climdiv-tmpcdv-v1.0.0-${DT} ncdcdivt.dat
else
  wget ftp.ncdc.noaa.gov:/pub/data/cirs/climdiv/climdiv-pcpndv-v1.0.0-${DT} 
  wget ftp.ncdc.noaa.gov:/pub/data/cirs/climdiv/climdiv-tmpcdv-v1.0.0-${DT} 
  mv climdiv-pcpndv-v1.0.0-${DT} ncdcdivp.dat
  mv climdiv-tmpcdv-v1.0.0-${DT} ncdcdivt.dat
  echo 'copy new data '
fi
