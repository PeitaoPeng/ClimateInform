#!/bin/ksh
source ~/.profile
#######################################################################
#                                                                     #
# SCRIPT: ncdcprelim.ksh                                              #
# LANGUAGE:  korn Shell                                               #
# MACHINE:   Compute Farm                                             #
# ACCOUNT  dunger.tst                                                 #
#---------------------------------------------------------------------#
# INITIATION METHOD:  Chrontab set for to run on the 3rd of each month#
#---------------------------------------------------------------------#
# PURPOSE:  Initiates the series of scripts required to take monthly  #
#          gridded CPC data and estimate NCDC climate division data   #
#          from it                                                    #
#---------------------------------------------------------------------#
# USAGE:   ./mkcdprelim.ksh $1  $2                                    #
#     YYYY=0 defaults to current month.    MM has leading 0's         #
#     if non-zero, YYYY MM refer to the month of data we want         #
#---------------------------------------------------------------------#
# INPUT FILES:  Input files are specified by the control files        #
#               of the component programs.                            #
#             input file 'todaysdate.txt' created in the script       #
# /cpc/prod_tst/aallgood/data/observations/land_air/all_ranges/conus/C#
#limateDivisions344/${YYm1}/${MM1}/summary_01m.txt                    #
#/cpc/prod_tst/aallgood/data/observations/land_air/all_ranges/conus/Cl#
#imateDivisions344//${YYm1}/${MM1}/summary_first15days.txt            #
# OUTPUT FILES:  Specified in the control dataset of each script      #
#---------------------------------------------------------------------#
# SUBROUTINE USED: external scripted routines                         #
# EXECUTABLES USED:   mkcdprelim.x                                    #
#                     adjncdc.x                                       #
#                    mkcdlong.x                                       #
#                   transcdfd.x                                       #
#                  appendhalf.x                                       #
#       notification for job status is done by component programs     #
#---------------------------------------------------------------------#
# COMMAND LINE VARIABLES:                                             #
#     $1 = YYYY=0 defaults to current month.                          #
#     $2 = MM Month number, 2 numerals, has leading 0's               #
#     if non-zero, YYYY MM refer to the month of data we want         #
#      NOTE this is different from the convention used on the         #
#      component scripts.                                             #
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
pid='pid_107'
pgm='NCDCprelim'
#process_dir=$MAKECDS
process_dir='/cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/scripts'
controldir='../library'
workdir='../work'
logdir='../logs'
process_owner='david.unger@noaa.gov'
echo ${process_owner}
cd ${process_dir}
#   Remove old log files so they don't get confused with this process.
rm ${logdir}/*.txt
if [ $1 = '0' ]; then
     date +%Y' '%m' '%d > todaysdate.txt
      MM=`date +%m`
      YY=`date +%Y`
 else;
#      If $1 and $2 contain a date, that is the month we want.  Make it
#      look to subsequent scripts like the normal case where we grab
#      data from the month prior to the current time. So we bogus in the next
#      month as the "current date" when data usually arrive.
     let MP=${2}+1
     MP1=0${MP}
     YYP1=${1}
     if [ ${MP1} = '010' ]; then
          MP1='10'
     fi
     if [ ${MP1} = '011' ]; then
          MP1='11'
     fi
     if [ ${MP1} = '012' ]; then
          MP1='12'
     fi
     if [ $MP1 = '013' ]; then
        let YYP1=${1}-1
        MP1='01'
     fi 
     MM=${MP1}
     YY=${YYP1}
     sed -e "s/YYYY/${YY}/" -e "s/MM/${MM}/" -e "s/DD/15/" ${controldir}/todaysdate.ctl > ${workdir}/todaysdate.txt
fi
#  Todays date is loaded with the date that the data (would have) come in in real time, now back up one month to
#    Find month the data are valid for, Add leading zero and fix up format for months 10 and 11
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
echo  'begin scripts  '${YY}' '${MM}
echo ' Begin Processing for '${YY}' '${MM} >${workdir}ncdcstatus.txt
echo  ' Process month '${YYm1}'  '${MM1}
#   COPY CPC GRID ESTIMATES TO THE WORK DIRECTORY FOR THIS PROCESS
cp /cpc/prod_tst/aallgood/data/observations/land_air/all_ranges/conus/ClimateDivisions344/${YYm1}/${MM1}/summary_01m.txt ${workdir}/cpcgrid${MM1}p.txt
cp /cpc/prod_tst/aallgood/data/observations/land_air/all_ranges/conus/ClimateDivisions344/${YYm1}/${MM1}/summary_first15days.txt ${workdir}/cpcgrid${MM1}h.txt
#  make the preliminary 344 cd estimates, wait for it to finish
../scripts/mkcdprelim.ksh ${YY} ${MM} p
sleep 5
#  Translate to the old NCDC estimates
../scripts/adjncdc.ksh ${YY} ${MM} p
#   make the t.long and p.long formated files
../scripts/mkcdlong.ksh  ${YY} ${MM} g
#    translate 344 cds to 102 fds, both grid and station versions
../scripts/transcdfd.ksh ${YY} ${MM} g
../scripts/transcdfd.ksh ${YY} ${MM} s
#   make the t.long and p.long version of the station based NCDC data
../scripts/mkcdlong.ksh ${YY} ${MM} s
#   Make the half-month data for the SMLR and CCA, then make the station 
#  based estimates, translate it to 102 divisions, and append to existing
#   data
../scripts/mkcdprelim.ksh ${YY} ${MM} h
sleep 5
../scripts/adjncdc.ksh ${YY} ${MM} h
sleep 5 
../scripts/transcdfd.ksh ${YY} ${MM} h
sleep 5
../scripts/appendhalf.ksh ${YY} ${MM} h
echo   "  All done.  Summary stats "
cat ${logdir}/${pid}status.txt |mutt -s " NCDC Job Status " ${process_owner}
ptest=`grep "failed" ${logdir}/${pid}status.txt`
echo ${ptest}
if [ " ${ptest}" = " " ]; then
   echo "All jobs worked copy to archive"
#  If this is run with a default command line input, then we want to copy this to the permanent place.
   if [ ${1} = '0' ]; then
     ./cpyupdt.ksh 0
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

#   We are all done.
