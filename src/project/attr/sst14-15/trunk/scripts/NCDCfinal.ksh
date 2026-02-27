#!/bin/ksh
source ~/.profile
#######################################################################
#                                                                     #
# SCRIPT: NCDCfinal.ksh                                               #
# LANGUAGE:  korn Shell                                               #
# MACHINE:   Compute Farm                                             #
# ACCOUNT  dunger.tst                                                 #
#---------------------------------------------------------------------#
# INITIATION METHOD: Chrontab set for to run on the 15th of each month#
#---------------------------------------------------------------------#
# PURPOSE:  Updates the Climate division data with new NCDC data.     #
#---------------------------------------------------------------------#
# USAGE:   ./final.ksh $1  $2                                         #
#     YYYY=0 defaults to current month.    MM has leading 0's         #
#        If dates are specified, YYYY MM are the year and month of    #
#        the data that we want. NOTE:  This differs from the component#
#        script convention (to make it easier to know what month is   #
#        being re-run.)                                               #
#---------------------------------------------------------------------#
# INPUT FILES:  Input files are specified by the control files        #
#              of the component processes                             #
# OUTPUT FILES:  Specified in the control dataset of the component    #
#                processes                                            #
# SOURCED FILES:                                                      #
#    NCDC ftp file.                                                   #
#---------------------------------------------------------------------#
# SUBROUTINE USED: No external scripted routines                      #
# EXECUTABLES USED:   makencdc.x                                      #
#                      adjncdc.x                                      #
#                     mkcdlong.x                                      #
#                    transcdfd.x                                      #
#                     updthalf.x                                      #
#                updtncdcstats.x                                      #
#       notification for job status is done by component programs     #
#---------------------------------------------------------------------#
# COMMAND LINE VARIABLES:                                             #
#     $1 = YYYY=0 defaults to current month.  Otherwise it is the     #
#             year of the data that we want                           #
#     $2 = MM Month number, 2 numerals, has leading 0's               #
# LOCAL VARIABLES:                                                    #
#     workdir_  = directory used to execute code                      #
#   YYYY MM = The current year and month                              #
#   YYM1 MM1 = The month we want to retrieve usually the one month    #
#              before the current month and year                      #
#   YYP1 MP1 =  when $1 and $2 contain a month and year, that is the  #
#               actual month we want.  We make it look like this is   #
#               requested in the following month.  That way other     #
#               scripts behave correctly, as though they were run when#
#               the data arrive,one month AFTER the month we want.    # 
#                                                                     #
#---------------------------------------------------------------------#
# AUTHOR:   Unger,                                                    # 
#---------------------------------------------------------------------#
# DATE:     November, 2014                                            #
#---------------------------------------------------------------------#
# MODIFICATIONS:                                                      #
#######################################################################
pid='pid_107'
pgm='NCDCfinal'
#process_dir=$MAKECDS
process_dir='/cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/scripts'
#   Transfer control to working directory, load date and process
workdir='../work'
controldir='../library'
logdir='../logs'
process_owner='david.unger@noaa.gov'
echo ${process_owner}
#   Go into the scripts dir for this process!
cd ${process_dir}
#   Remove old log files so they don't get confused with this process.
rm ${logdir}/*.txt
if [ $1 = '0' ]; then
#   If this is a default, then the requested data is one month
#     prior to the current date.  

     date +%Y' '%m' '%d > ${workdir}/todaysdate.txt
      MM=`date +%m`
      YYYY=`date +%Y`
 else;
#      If $1 and $2 contain a date, that is the month we want.  Make it
#      look to subsequent scripts like the normal case where we grab
#      data from the month prior to the current time. So we bogus in the next
#      month as the "current date" when data usually arrive.
     let MP=${2}+1
     MP1=0${MP}
     YYYY=${1}
     if [ ${MP1} = '010' ]; then
          MP1='10'
     fi
     if [ ${MP1} = '011' ]; then
          MP1='11'
     fi
     if [ ${MP1} = '012' ]; then
          MP1='12'
     fi
     if [ ${MP1} = '013' ]; then
        let YYYY=${1}+1
        MP1='01'
     fi 
     MM=${MP1}
     sed -e "s/YYYY/${YYYY}/" -e "s/MM/${MP1}/" -e "s/DD/15/" ${controldir}/todaysdate.ctl > ${workdir}/todaysdate.txt
fi
#  Now todaysdate.txt contains the year and month
echo ${YYYY}
echo ${MM}
cat ${workdir}/todaysdate.txt
#  Read the NCDC data and update the temperature and precip data in 
#    separate runs.  (p and t)
./getncdc.ksh
./makencdc.ksh ${YYYY} ${MM} p
./makencdc.ksh ${YYYY} ${MM} t
sleep 5
#  add some time to make sure it finishes, and estimate the station-based
#   NCDC data. 
./adjncdc.ksh ${YYYY} ${MM} u
#   Write the data in by-division format, and translate to 102 forecast divisions
./mkcdlong.ksh  ${YYYY} ${MM} u
./transcdfd.ksh ${YYYY} ${MM} u
sleep 5
#   Do the same for the station-based data.
./mkcdlong.ksh  ${YYYY} ${MM} v
./transcdfd.ksh ${YYYY} ${MM} v
sleep 5
#  update the half-month datasets with new NCDC estimates
./updthalf.ksh ${YYYY} ${MM} 
#   monitor the bias adjustments for the CPC-grid - to NCDC division estimates
./updtncdcstats.ksh ${YYYY} ${MM} 
cat ${workdir}/${pid}status.txt | mutt -s " NCDC Job Status " ${process_owner}
ptest=`grep "failed" ${logdir}/${pid}status.txt`
echo ${ptest}
if [ " ${ptest}" = " " ]; then
   echo "All jobs worked copy to archive"
#  If this is run with a default command line input, then we want to copy this to the permanent place.
   if [ ${1} = '0' ]; then
     ./cpyupdt15.ksh 0
   fi
   cptest=`grep '1' ${logdir}/${pid}cpystatus.txt` 
   if [ " ${cptest}" = " " ]; then
       echo 'copy succeeded'
   else
       echo 'copy failed'
       echo " ${pgm} worked but copy failed" | mutt -s " ${pgm} failed. See ${process_dir} logs." ${process_owner}
       echo " ${pgm} worked but copy failed" | mutt -s " ${pgm} failed. See ${process_dir} logs." ${process_backup}
   fi
   ftptest=`grep '1' ${logdir}/${pid}ftpstatus.txt` 
   if [ " ${ftptest}" = " " ]; then
       echo 'Copy to ftp space succeeded'
   else
       echo 'copy failed'
       echo " ${pgm} worked but copy to ftp failed" | mutt -s " ${pgm} failed. See ${process_dir} logs." ${process_owner}
       echo " ${pgm} worked but copy to ftp failed" | mutt -s " ${pgm} failed. See ${process_dir} logs." ${process_backup}
   fi
else
  echo " At least one job failed, do not copy anything. "
  echo " ${pgm} failed " | mutt -s " ${pgm} failed. See ${process_dir} logs." ${process_owner}
  echo " ${pgm} failed " | mutt -s " ${pgm} failed. See ${process_dir} logs." ${process_backup}
fi

#  Yea!  We are done.


