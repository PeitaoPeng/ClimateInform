#!/bin/ksh
source ~/.profile
#######################################################################
#                                                                     #
# SCRIPT: cpyupdt15.ksh                                               #
# LANGUAGE:  korn Shell                                               #
# MACHINE:   Compute Farm                                             #
# ACCOUNT  dunger.tst                                                 #
#---------------------------------------------------------------------#
# INITIATION METHOD: Chrontab set for to run on the 15th of each month#
#             after sucessful completion of NCDCfinal.ksh             #
#---------------------------------------------------------------------#
# PURPOSE:  Copies the NCDC processed datasets to archive directory   # 
#---------------------------------------------------------------------#
# USAGE:   ./cpyupdt15.ksh YYYY MM                                    #
#     YYYY=0 defaults to copying the data normally processed around   #
#     the middle of the current month. The PROCESSED MONTH is one     #
#     month prior to the current month. IF YYYY MM is specified as    #
#     non-zero integers, then the PROCESSED month "MM" is copied      #
#     from the rotating file directory /${MM}/   MM has leading 0's   #
#---------------------------------------------------------------------#
# INPUT FILES: 12-month backup rotating directory 1-month prior to the#
#     processed month (2 months prior to the current month for YYYY=0)#  
#  /cpc/data... ncdc climate divisions rotating directory...          #
#   cd344tg.dat,cd344pg.dat,cd344t.dat,cd344p.dat,cd102tg.dat         #
#   cd102pg.dat,cd102tg.dat,cd102pg.dat,tg.long,pg.long,t.long        #
#    p.long,cdh102t.dat,cdh102p.dat,stat1CPCncdct.gds,                #
#    stat1CPCncdcp.gds ${destdir}/stat1CPCncdcp.gds                   #
#                                                                     #
# OUTPUT FILES:  Rotating directory of processed month                #
#  /cpc/data... ncdc climate divisions directory...  /archives        #
#   cd344tg.dat,cd344pg.dat,cd344t.dat,cd344p.dat,cd102tg.dat         #
#   cd102pg.dat,cd102tg.dat,cd102pg.dat,tg.long,pg.long,t.long        #
#    p.long,cdh102t.dat,cdh102p.dat,stat1CPCncdct.gds,                #
#    stat1CPCncdcp.gds ${destdir}/stat1CPCncdcp.gds                   #
#                                                                     #
# SOURCED FILES:                                                      #
#---------------------------------------------------------------------#
# SUBROUTINE USED: No external scripted routines                      #
# EXECUTABLES USED:   None                                            #
#---------------------------------------------------------------------#
# COMMAND LINE VARIABLES:   FORTRAN control file dataset name         #
#     $1 = YYYY=0 defaults to current month.                          #
#     $2 = MM Month number, 2 numerals, has leading 0's               #
# LOCAL VARIABLES:                                                    #
#     datadir  = Rotating ncdc data directory                         #
#     destdir, = Archive directory                                    #   
#   YYMM,MM, YYm1,MM1  Year and month of requested, and previous one  #
#                                                                     #
#---------------------------------------------------------------------#
# AUTHOR:   Unger,                                                    # 
#---------------------------------------------------------------------#
# DATE:     January, 2015                                             #
#---------------------------------------------------------------------#
# MODIFICATIONS:                                                      #
#######################################################################
pid='pid_107'
process_dir='/cpc/prod_tst/dunger/sandboxes/makencdc/ncdccds/trunk/scripts'
logdir='../logs'
destdir=${DATA_OUT}'/observations/land_air/long_range/conus/temp_precip/cds'
cd ${process_dir}
if [ $1 = '0' ]; then
      MM=`date +%m`
      YY=`date +%Y`
     let MM1=${MM}-1
     echo $MM1
     MM1=0${MM1}
     
     YYm1=${YY}
     if [ ${MM1} = '010' ]; then
          MM1=10
     fi
     if [ ${MM1} = '011' ]; then
          MM1=11
     fi
     if [ $MM1 = '00' ]; then
        let YYm1=${YY}-1
        MM1='12'
     fi 
 else;
#      If $1 and $2 contain a date, that is the month we want.  Make it
#      look to subsequent scripts like the normal case where we grab
#      data from the month prior to the current time. So we bogus in the next
#      month as the "current date" when data usually arrive.
   MM=${2}
   YY=${1}
   MM1=${2}
   YYm1=${1}
fi
echo $YY
echo $MM
echo $MM1
echo $YYm1
datadir='../library/rotating/'${MM1}
cp ${datadir}/cd344tg.dat ${destdir}/cd344tg.dat
echo $? >${logdir}/${pid}cpystatus.txt
cp ${datadir}/cd344pg.dat ${destdir}/cd344pg.dat
echo $? >>${logdir}/${pid}cpystatus.txt
cp ${datadir}/cd344t.dat ${destdir}/cd344t.dat
echo $? >>${logdir}/${pid}cpystatus.txt
cp ${datadir}/cd344p.dat ${destdir}/cd344p.dat
echo $? >>${logdir}/${pid}cpystatus.txt
cp ${datadir}/cd102tg.dat ${destdir}/cd102tg.dat
echo $? >>${logdir}/${pid}cpystatus.txt
cp ${datadir}/cd102pg.dat ${destdir}/cd102pg.dat
echo $? >>${logdir}/${pid}cpystatus.txt
cp ${datadir}/cd102t.dat ${destdir}/cd102t.dat
echo $? >>${logdir}/${pid}cpystatus.txt
cp ${datadir}/cd102p.dat ${destdir}/cd102p.dat
echo $? >>${logdir}/${pid}cpystatus.txt
cp ${datadir}/tg.long ${destdir}/tg.long
echo $? >>${logdir}/${pid}cpystatus.txt
cp ${datadir}/pg.long ${destdir}/pg.long
echo $? >>${logdir}/${pid}cpystatus.txt
cp ${datadir}/t.long ${destdir}/t.long
echo $? >>${logdir}/${pid}cpystatus.txt
cp ${datadir}/p.long ${destdir}/p.long
echo $? >>${logdir}/${pid}cpystatus.txt
cp ${datadir}/cdh102t.dat ${destdir}/cdh102t.dat
echo $? >>${logdir}/${pid}cpystatus.txt
cp ${datadir}/cdh102p.dat ${destdir}/cdh102p.dat
echo $? >>${logdir}/${pid}cpystatus.txt
cp ${datadir}/stat1CPCncdct.gds ${destdir}/stat1CPCncdct.gds
echo $? >>${logdir}/${pid}cpystatus.txt
cp ${datadir}/stat1CPCncdcp.gds ${destdir}/stat1CPCncdcp.gds
echo $? >>${logdir}/${pid}cpystatus.txt
./cpyftp.ksh


