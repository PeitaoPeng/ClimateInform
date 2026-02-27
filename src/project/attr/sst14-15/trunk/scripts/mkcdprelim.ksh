#!/bin/ksh
source ~/.profile
#######################################################################
#                                                                     #
# SCRIPT: mkcdprelim.ksh                                              #
# LANGUAGE:  korn Shell                                               #
# MACHINE:   Compute Farm                                             #
# ACCOUNT  dunger.tst                                                 #
#---------------------------------------------------------------------#
# INITIATION METHOD:  Called from a parent script NCDCprelim.ksh      #
#       Can also be run independently.                                #
#---------------------------------------------------------------------#
# PURPOSE:  Updates the Climate division data with monthly estimates  #
#          from CPC gridded data.                                     #
#---------------------------------------------------------------------#
# USAGE:   ./mkcdprelim.ksh $1  $2  $3                                #
#     $1 =YYYY=0 defaults to current month. $2 = MM has leading 0's   #
#    $3 = a single character id for locating the proper control file  #
#---------------------------------------------------------------------#
# INPUT FILES:  Input files are specified by the control file.        #
#             input file 'todaysdate.txt' created in the script       #
# OUTPUT FILES:  Specified in the control dataset.  output file       #
#               ncdcstatus is created in this script                  #
# SOURCED FILES:                                                      #
#---------------------------------------------------------------------#
# SUBROUTINE USED: No external scripted routines                      #
# EXECUTABLES USED:   mkcdprelim.x                                    #
#---------------------------------------------------------------------#
# COMMAND LINE VARIABLES:                                             #
#     $1 = YYYY=0 defaults to current month.                          #
#     $2 = MM Month number, 2 numerals, has leading 0's  0 for default#
#     $3 = An single character variable that directs the              #
#          program to the proper control file, and logfile name       # 
#          $3= p for preliminary updates, =h for Half-month updates,  #
#     A non-zero YYYY instructs the program to behave as it would if  #
#     the current month were YYYY MM.  NOTE:  This processes the month#
#     prior to YYYY MM, as would be the case if this were running in  #
#     real time.  The NCDC data don't come in until the month is      #
#     complete and therefore is the next month.                       # 
# LOCAL VARIABLES:                                                    #
#   controldir = location of the control file for this run            #
#     workdir_  = directory used to execute code                      #
#     objectdir, objectfile = location of executable                  #   
#     logfile = output file for log info                              #
#   YYMM,MM, YYm1,MM1  Year and month of requested, and previous one  #
#    VV = $3 From command line.                                       #
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
pgm='mkcdprelim'
pid='pid_107'
process_dir='$MAKECDS no quotes'
process_dir='/cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/scripts'
#
#  Define directories, executables and control files.
#
process_owner='david.unger@noaa.gov'
echo ${process_owner}
process_backup='adam.allgood@noaa.gov'
echo ${process_backup}
# *******************************************************TEST STATEMEMTS
DATA_IN='/cpc/data/'
# *******************************************************REMOVE BEFORE COMMIT
controldir='../library'
workdir='../work'
objectdir='../build'
arcdir='../library/rotating'
logdir='../logs'
cdfile='cpcgrid'
VV=${3}
controlfile=${controldir}/${pgm}${VV}'.ctl'
objectfile=${objectdir}/${pgm}'.x'
logfile=${logdir}/${pgm}${VV}'.txt'
echo $controlfile
echo $objectfile
echo $logfile
#   Go to the process directory holding scripts, then everything is relative to that directory
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
     echo ${MM1}
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
#   Subtract another month to get the last good files.
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
echo $YY
echo $MM
echo $MM1
echo $YYm1
#   Test and make new archive directory
if [ -d ${arcdir}/${YYm1}'/'${MM1} ]; then
   echo 'Archive directory exists '
else
   echo 'Making new directory' ${arcdir}/${YYm1}/${MM1}
   mkdir -p ${arcdir}/${YYm1}/${MM1}
fi
#    Test for adam allgoods file here.
if [ -f ${workdir}/${cdfile}${MM1}${VV}.txt ]; then
   echo 'new file exists '
else
   echo "New file containing prelim data is not there "
   echo ${workdir}/${cdfile}${MM1}${VV}.txt
  echo "CPC Preliminary climate division data not there " | mutt -s " CPC Forecast Division preliminary estimation failed. See makencdc logs." ${process_owner}
  echo "CPC Preliminary climate division data not there " | mutt -s " CPC Forecast Division preliminary estimation failed. See makencdc logs." ${process_backup}

fi
#
# Use stream editor to insert proper path in a temporary copy of the control file 
#   
sed -e "s%MM1%${MM1}%g" -e "s%YYm1%${YYm1}%g" -e "s%MM2%${MM2}%g" -e "s%DATAIN%${DATA_IN}%g" ${controlfile} >controlfile.ctl
${objectfile}  controlfile.ctl >${logfile}
#    The FORTRAN code monitors success, and Quality control. This is
#      written to the logfile as a numerical status variable, gotten
#      through the grep/cut commmand. only copy to archive if status=0
gtest=' 0'
ptest=`grep 'PROGRAM STATUS' ${logfile} |cut -f2 -d=`
if [ " ${ptest}" = " ${gtest}" ]; then
   echo " CPC Preliminary data added JOB "${pgm}", STATUS1 = 0" >>${logdir}/${pid}status.txt
else;
   echo " CPC Preliminary data failed JOB "${pgm}", STATUS1 = "${ptest} >>${logdir}/${pid}status.txt 
fi


