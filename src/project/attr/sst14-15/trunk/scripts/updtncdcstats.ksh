#!/bin/ksh
source ~/.profile
#######################################################################
#                                                                     #
# SCRIPT: updtncdcstats.ksh                                           #
# LANGUAGE:  korn Shell                                               #
# MACHINE:   Compute Farm                                             #
# ACCOUNT  dunger.tst                                                 #
#---------------------------------------------------------------------#
# INITIATION METHOD:  Called by script NCDCfinal.ksh     Can be run  #
#                     independently as well.                          #
#---------------------------------------------------------------------#
# PURPOSE:  Updates the bias correction coefficients to estimate      #
#   NCDC grid-based climate division data from CPC grids.             #
#---------------------------------------------------------------------#
# USAGE:   ./tupdtncdcstats.ksh YYYY MM                               #
#     YYYY=0 defaults to current month.    MM has leading 0's         #
#---------------------------------------------------------------------#
# INPUT FILES:  Input files are specified by the control file.        #
#             input file 'todaysdate.txt' created in the script       #
# OUTPUT FILES:  Specified in the control dataset.  output file       #
#               ncdcstatus is created in this script                  #
# SOURCED FILES:                                                      #
#---------------------------------------------------------------------#
# SUBROUTINE USED: No external scripted routines                      #
# EXECUTABLES USED:   updtncdcstats.x                                 #
#---------------------------------------------------------------------#
# COMMAND LINE VARIABLES:   FORTRAN control file dataset name         #
#     YYYY=0 defaults to current month.    MM has leading 0's         #
#     A non-zero YYYY instructs the program to behave as it would if  #
#     the current month were YYYY MM.  NOTE:  This processes the month#
#     prior to YYYY MM, as would be the case if this were running in  #
#     real time.  The NCDC data don't come in until the month is      #
#     complete and therefore is the next month.                       # 
# LOCAL VARIABLES:   ptest, gtest  completion status written on the   #
#    logfile obtained through grep/cut and a matching sucessful value #
#     objectdir_, objectfile = location of executable                 #
#     localdir_  = directory used to execute code                     #
#     localdir_  = destination directory of output (temporary)        #
#     arcdir_ = location of archive directory (output files are       #
#               coppied only upon sucessful completion.               #                                     
#---------------------------------------------------------------------#
# AUTHOR:   Unger,                                                    # 
#---------------------------------------------------------------------#
# DATE:     MARCH 2015                                                #
#---------------------------------------------------------------------#
# MODIFICATIONS:                                                      #
#######################################################################
#
#     DEFINE VARIABLES
pgm='updtncdcstats'
pid='pid_107'
process_dir='$MAKECDS no quotes'
process_dir='/cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/scripts'
#
controldir='../library'
workdir='../work'
objectdir='../build'
logdir='../logs'
controlfile=${controldir}/${pgm}'.ctl'
objectfile=${objectdir}/${pgm}'.x'
logfile=${logdir}/${pgm}'.txt'
process_owner='david.unger@noaa.gov'
echo ${process_owner}
#   Go to the process directory holding scripts, then everything is relative to that directory
cd ${process_dir}
#   Transfer control to working directory, load date and process
cd ${workdir}
if [ ${1} = '0' ]; then
     date +%Y' '%m' '%d > todaysdate.txt
      MM=`date +%m`
      YY=`date +%Y`
 else;
     sed -e "s/YYYY/$1/" -e "s/MM/$2/" -e "s/DD/15/" ${controldir}/todaysdate.ctl > todaysdate.txt
     MM=${2}
     YY=${1}
fi
#    Subtract one month from current data to point to correct directory
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
echo 'in script updtncdcstats '$YY' '${MM} 
sed -e "s%MM1%${MM1}%g" -e "s%YYm1%${YYm1}%g" -e "s%MM2%${MM2}%g" ${controlfile} >controlfile.ctl

${objectfile}  controlfile.ctl >${logfile}
#    The FORTRAN code monitors success, and Quality control. This is
#      written to the logfile as a numerical status variable, gotten
#      through the grep/cut commmand. only copy to archive if status=0
gtest=' 0'
ptest=`grep 'PROGRAM STATUS' ${logfile} |cut -f2 -d=`
if [ " ${ptest}" = " ${gtest}" ]; then
   echo " Forecast divs statistics computed  , JOB "${pgm}" STATUS = 0" >>${logdir}/${pid}status.txt
   echo " Forecast divs statistics computed  , JOB "${pgm}" STATUS = 0" 
else
   echo " CPC Forecast Division stats computation failed , JOB "${pgm}" STATUS = "${ptest} >>${logdir}/${pid}status.txt 
fi


