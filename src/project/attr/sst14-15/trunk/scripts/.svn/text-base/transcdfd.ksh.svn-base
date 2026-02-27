#!/bin/ksh
source ~/.profile
#######################################################################
#                                                                     #
# SCRIPT: trancdfd.ksh                                                #
# LANGUAGE:  korn Shell                                               #
# MACHINE:   Compute Farm                                             #
# ACCOUNT  dunger.tst                                                 #
#---------------------------------------------------------------------#
# INITIATION METHOD:  Called by parent scripts NCDCprelim.ksh or      #
#                     NCDCfinal.ksh but can be run as an individual   #
#                     process as well.                                #
#---------------------------------------------------------------------#
# PURPOSE:  Makes CPC "Forecast Divisions"  (Mega-divisions) from NCDC#
#     Climate division data                                           #
#---------------------------------------------------------------------#
# USAGE:   ./transcdfd.ksh $1 $2 $3                                   #
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
# COMMAND LINE VARIABLES:                                             #
#     $1 = YYYY=0 defaults to current month.                          #
#     $2 = MM Month number, 2 numerals, has leading 0's               #
#     $3 = An optional single character variable that directs the     #
#          program to the proper control file, and logfile name       # 
#          $3= p for preliminary updates, =h for Half-month updates,  #
#              u for final NCDC updates                               #         
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
#    VV = $3 From command line.
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
pgm='transcdfd'
pid='pid_107'
process_dir='$MAKECDS no quotes'
process_dir='/cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/scripts'
#
#  Define directories, executables and control files.
#
controldir='../library'
workdir='../work'
objectdir='../build'
logdir='../logs'
controlfile=${controldir}/${pgm}${3}'.ctl'
objectfile=${objectdir}/${pgm}'.x'
logfile=${logdir}/${pgm}${3}'.txt'
process_owner='david.unger@noaa.gov'
echo ${process_owner}
#   Go to the process directory holding scripts, then everything is relative to that directory
cd ${process_dir}
#   Transfer control to working directory, load date and process
cd ${workdir}
if [ $1 = '0' ]; then
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
echo 'in script transcdfd '$YY' '${MM} ${3}
# Use stream editor to insert proper path in a temporary copy of the control file 
sed -e "s%MM1%${MM1}%g" -e "s%YYm1%${YYm1}%g" -e "s%MM2%${MM2}%g" ${controlfile} >controlfile.ctl
${objectfile}  controlfile.ctl >${logfile}
#    The FORTRAN code monitors success, and Quality control. This is
#      written to the logfile as a numerical status variable, gotten
#      through the grep/cut commmand. only copy to archive if status=0
gtest=' 0'
ptest=`grep 'PROGRAM STATUS' ${logfile} |cut -f2 -d=`
echo 'completion status check '${ptest} ' should be '${gtest}
if [ " ${ptest}" = " ${gtest}" ]; then
   echo " CD to FD  computed  , JOB "${3}" "${pgm}" STATUS = 0" >>${logdir}/${pid}status.txt
   echo "  CD to FD  computed  , JOB "${3}" "${pgm}" STATUS = 0" 
else
   echo " CD to FD  computed  failed , JOB "${3}" "${pgm}" STATUS = "${ptest} >>${logdir}/${pid}status.txt 
fi


