#!/bin/ksh
source ~/.profile
#######################################################################
#                                                                     #
# SCRIPT: cpyftp.ksh                                                  #
# LANGUAGE:  korn Shell                                               #
# MACHINE:   Compute Farm                                             #
# ACCOUNT  dunger.tst                                                 #
#---------------------------------------------------------------------#
# INITIATION METHOD:  Chrontab set for to run on the 3rd of each month#
#                     or the 15th of each month                       #
#---------------------------------------------------------------------#
# PURPOSE:  Copies the current NCDC processed datasets to FTP space   # 
#---------------------------------------------------------------------#
# USAGE:   ./cpyftp.ksh                                               #
#---------------------------------------------------------------------#
# INPUT FILES:  Input files are specified by the control file.        #
#  /cpc/data... ncdc climate divisions directory...                   #
#    cd344tg.dat,cd344pg.dat,cd344t.dat,cd344p.dat,cd102tg.dat,       #
#    cd102pg.dat,cd102t.dat,cd102p.dat                                #
#                                                                     #
# OUTPUT FILES:  RZDM ftp space                                       #
# wd53du@cpcrzdm.ncep.noaa.gov:/home/people/cpc/ftp/wd53du/NCDCdata/  # 
#    cd344tg.dat,cd344pg.dat,cd344t.dat,cd344p.dat,cd102tg.dat,       #
#    cd102pg.dat,cd102t.dat,cd102p.dat                                #
# SOURCED FILES:                                                      #
#---------------------------------------------------------------------#
# SUBROUTINE USED: No external scripted routines                      #
# EXECUTABLES USED:   None                                            #
#---------------------------------------------------------------------#
# COMMAND LINE VARIABLES:   None                                      #
# LOCAL VARIABLES:                                                    #
#     datadir  = directory holding internal CPC data                  #
#     FTP_OUT  = An intermediate place that somehow mirrors to FTP    #
#                space on rzdm                                        #
#     destdir  = FTP address (directory) on rzdm                      #   
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
datadir=${DATA_OUT}'/observations/land_air/long_range/conus/temp_precip/cds'
destdir='/wd53du/NCDCdata'
logdir='../logs'
echo ${datadir}
#   Copy data and test each status... any one will be found in the grep
#    Use append for all status checks because this is run after the copy job
cp ${datadir}/cd344tg.dat ${FTP_OUT}${destdir}/cd344tg.dat
echo $? >${logdir}/${pid}ftpstatus.txt
cp ${datadir}/cd344t.dat ${FTP_OUT}${destdir}/cd344t.dat
echo $? >>${logdir}/${pid}ftpstatus.txt
cp ${datadir}/cd344pg.dat ${FTP_OUT}${destdir}/cd344pg.dat
echo $? >>${logdir}/${pid}ftpstatus.txt
cp ${datadir}/cd344p.dat ${FTP_OUT}${destdir}/cd344p.dat
echo $? >>${logdir}/${pid}ftpstatus.txt
cp ${datadir}/cd102tg.dat ${FTP_OUT}${destdir}/cd102tg.dat
echo $? >>${logdir}/${pid}ftpstatus.txt
cp ${datadir}/cd102t.dat ${FTP_OUT}${destdir}/cd102t.dat
echo $? >>${logdir}/${pid}ftpstatus.txt
cp ${datadir}/cd102pg.dat ${FTP_OUT}${destdir}/cd102pg.dat
echo $? >>${logdir}/${pid}ftpstatus.txt
cp ${datadir}/cd102p.dat ${FTP_OUT}${destdir}/cd102p.dat
echo $? >>${logdir}/${pid}ftpstatus.txt


