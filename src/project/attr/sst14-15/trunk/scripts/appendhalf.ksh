#!/bin/ksh
source ~/.profile
#######################################################################
#                                                                     #
# SCRIPT: appendhalf.ksh                                              #
# LANGUAGE:  korn Shell                                               #
# MACHINE:   Compute Farm                                             #
# ACCOUNT  dunger.tst                                                 #
#---------------------------------------------------------------------#
# INITIATION METHOD:  Chrontab set for to run on the 3rd of each month#
#                     or the 15th of each month                       #
#---------------------------------------------------------------------#
# PURPOSE:  Makes half-month estimates of CPC "Forecast Divisions"    #
#   (Mega-divisions) from NCDC Climate division data                  #
#---------------------------------------------------------------------#
# USAGE:   ./appendhalf.ksh YYYY MM                                   #
#     YYYY=0 defaults to current month.    MM has leading 0's         #
#---------------------------------------------------------------------#
# INPUT FILES:  Input files are specified by the control file.        #
#             input file 'todaysdate.txt' created in the script       #
# OUTPUT FILES:  Specified in the control dataset.  output file       #
#               ncdcstatus is created in this script                  #
# SOURCED FILES:                                                      #
#---------------------------------------------------------------------#
# SUBROUTINE USED: No external scripted routines                      #
# EXECUTABLES USED:   transcdfd.x                                     #
#---------------------------------------------------------------------#
# COMMAND LINE VARIABLES:   FORTRAN control file dataset name         #
#     $1 = YYYY=0 defaults to current month.                          #
#     $2 = MM Month number, 2 numerals, has leading 0's               #
#     $3 = An optional single character variable that directs the     #
#          program to the proper control file, and logfile name       # 
#          $3= p for preliminary updates, =h for Half-month updates,  #
#              u for final NCDC updates                               #         
# LOCAL VARIABLES:                                                    #
#   controldir = location of the control file for this run            #
#     workdir_  = directory used to execute code                      #
#     objectdir, objectfile = location of executable                  #   
#     logfile = output file for log info                              #
#   YYMM,MM, YYm1,MM1  Year and month of requested, and previous one  #
#   ptest, gtest  completion status written on the                    #
#    logfile obtained through grep/cut and a matching sucessful value #
#                                                                     #
#---------------------------------------------------------------------#
# AUTHOR:   Unger,                                                    # 
#---------------------------------------------------------------------#
# DATE:     November, 2014                                            #
#---------------------------------------------------------------------#
# MODIFICATIONS:                                                      #
#######################################################################
#
#     DEFINE VARIABLES
pid='pid_107'
pgm='appendhalf'
process_dir='${MAKECDS} no quotes'
process_dir='/cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/scripts'
#
#  Define directories, executables and control files.
#
process_owner='david.unger@noaa.gov'
echo ${process_owner}
controldir='../library'
workdir='../work'
logdir='../logs'
objectdir='../build'
controlfile=${controldir}/${pgm}'.ctl'
objectfile=${objectdir}/${pgm}'.x'
logfile=${logdir}/${pgm}'.txt'
cd ${process_dir}
#   Transfer control to working directory, load date and process
cd ${workdir}
#  0 date indicates default to current date, otherwise read data from command line.
if [ ${1} = '0' ]; then
     date +%Y' '%m' '%d > todaysdate.txt
      MM=`date +%m`
      YY=`date +%Y`
 else;
     sed -e "s/YYYY/${1}/" -e "s/MM/${2}/" -e "s/DD/15/" ${controldir}/todaysdate.ctl > todaysdate.txt
     MM=${2}
     YY=${1}
fi
#    Find one month prior to specified date, Add leading zero and fix up format for months 10 and 11
     let MM1=${MM}-1
     MM1=0${MM1}
     YYm1=${YY}
     if [ ${MM1} = '010' ]; then
          MM1='10'
     fi
     if [ ${MM1} = '011' ]; then
          MM1='11'
     fi
     if [ $MM1 = '00' ]; then
        let YYm1=${YY}-1
        MM1='12'
     fi 
#   Subtract another month to get the last good file.
     let MM2=${MM1}-1
     MM2=0${MM2}
     
     YYm2=${YYm1}
     if [ ${MM2} = '010' ]; then
          MM2='10'
     fi
     if [ ${MM2} = '011' ]; then
          MM2='11'
     fi
     if [ $MM2 = '00' ]; then
        let YYm2=${YYm1}-1
        MM2='12'
     fi 
echo ' script appendhalf is running on ' ${YY} ${MM}' processing '${YYm1}' '${MM1}
# Use stream editor to insert proper path in a temporary copy of the control file 
sed -e "s%MM1%${MM1}%g" -e "s%YYm1%${YYm1}%g" -e "s%MM2%${MM2}%g" ${controlfile} >controlfile.ctl
${objectfile}  controlfile.ctl >${logfile}
#    The FORTRAN code monitors success, and Quality control. This is
#      written to the logfile as a numerical status variable, gotten
#      through the grep/cut commmand. only copy to archive if status=0
gtest=' 0'
ptest=`grep 'PROGRAM STATUS' ${logfile} |cut -f2 -d=`
if [ " ${ptest}" = " ${gtest}" ]; then
   echo " Half month data appended  , JOB "${pgm}" STATUS = 0" >>${logdir}/${pid}status.txt
else;
   echo "  Half month data append failed , JOB "${pgm} " STATUS = "${ptest} >>${logdir}/${pid}status.txt 
fi


