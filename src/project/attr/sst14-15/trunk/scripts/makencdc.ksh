#!/bin/ksh
source ~/.profile
#######################################################################
#                                                                     #
# SCRIPT: makencdc.ksh                                                #
# LANGUAGE:  korn Shell                                               #
# MACHINE:   Compute Farm                                             #
# ACCOUNT  dunger.tst                                                 #
#---------------------------------------------------------------------#
# INITIATION METHOD: Called from Parent Script NCDCfinal.ksh.         #
#          Can be run independently from parent scripts too.          #
#---------------------------------------------------------------------#
# PURPOSE:  Updates the Preliminary Climate division data with NCDC   #
#          final values                                               #
#---------------------------------------------------------------------#
# USAGE:   ./makencdc.ksh YYYY MM                                     #
#     YYYY=0 defaults to current month.    MM has leading 0's         #
#     A non-zero YYYY instructs the program to behave as it would if  #
#     the current month were YYYY MM.  NOTE:  This processes the month#
#     prior to YYYY MM, as would be the case if this were running in  #
#     real time.  The NCDC data don't come in until the month is      #
#     complete and therefore is the next month.                       # 
#---------------------------------------------------------------------#
# INPUT FILES:  Input files are specified by the control file.        #
#             input file 'todaysdate.txt' created in the script       #
# OUTPUT FILES:  Specified in the control dataset.  output file       #
#               ncdcstatus is created in this script                  #
# SOURCED FILES:                                                      #
#---------------------------------------------------------------------#
# SUBROUTINE USED: No external scripted routines                      #
# EXECUTABLES USED:   makencdc.x                                      #
#---------------------------------------------------------------------#
# COMMAND LINE VARIABLES:   FORTRAN control file dataset name         #
#     $1 = YYYY=0 defaults to current month.                          #
#     $2 = MM Month number, 2 numerals, has leading 0's               #
#     $3 = An single character variable that directs the              #
#          program to the proper control file, and logfile name       # 
#          $3= p for precipitation, =t for temperature                #
# LOCAL VARIABLES:   ptest, gtest  completion status written on the   #
#   controldir = location of the control file for this run            #
#     workdir_  = directory used to execute code                      #
#     objectdir, objectfile = location of executable                  #   
#     logfile = output file for log info                              #
#   YYMM,MM, YYm1,MM1  Year and month of requested, and previous one  #
#   ptest, gtest  completion status written on the                    #
#    logfile obtained through grep/cut and a matching sucessful value #
#                                                                     #
#---------------------------------------------------------------------#
# AUTHOR:   Unger                                                     # 
#---------------------------------------------------------------------#
# DATE:     November, 2014                                            #
#---------------------------------------------------------------------#
# MODIFICATIONS:                                                      #
#######################################################################
#
#     DEFINE VARIABLES
pid='pid_107'
pgm='makencdc'
process_dir='$MAKECDS no quotes'
process_dir='/cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/scripts'
#
process_owner='david.unger@noaa.gov'
echo ${process_owner}
process_backup='adam.allgood@noaa.gov'
echo ${process_backup}
controldir='../library'
workdir='../work'
logdir='../logs'
objectdir='../build'
controlfile=${controldir}/${pgm}${3}'.ctl'
objectfile=${objectdir}/${pgm}'.x'
logfile=${logdir}/${pgm}'.txt'
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
#   Subtract another month to get the last good stats file.
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
echo 'in script makencdc '$YY' '${MM}
#    Test for NCDC file here.
# Use stream editor to insert proper path in a temporary copy of the control file 
sed -e "s%MM1%${MM1}%g" -e "s%YYm1%${YYm1}%g" -e "s%MM2%${MM2}%g" ${controlfile} >controlfile.ctl
${objectfile}  controlfile.ctl >${logfile}
#    The FORTRAN code monitors success, and Quality control. This is
#      written to the logfile as a numerical status variable, gotten
#      through the grep/cut commmand. only copy to archive if status=0
#     quotes in test prevent error when ptest is null 
gtest=' 0'
ptest=`grep 'PROGRAM STATUS' ${logfile} |cut -f2 -d=`
echo 'completion status check '${ptest} ' should be '${gtest}
if [ " ${ptest}" = " ${gtest}" ]; then
   echo " NCDC data added Job "${pgm}", STATUS1 = 0" >>${logdir}/${pid}status.txt
   echo " NCDC data added Job "${pgm}", STATUS1 = 0"
else
   echo " NCDC data not added Job "${pgm}" failed ,  STATUS = "${ptest} >>${logdir}/${pid}status.txt 
fi


