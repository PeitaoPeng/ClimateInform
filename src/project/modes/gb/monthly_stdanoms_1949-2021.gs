*This script creates data file for calculating monthly teleconnection indices
* from Jan1950 to present.
*
*After this script is run you then execute the FORTRAN CODE 
*        monthly_tele_indices_1950-pres.f 
*The FORTRAN code USES IMSL ROUTINES that must be MUST RUN ON cacsrv1.
*So, to run this script you first must ssh to cacsrv1
*Then enter the following command to bring up the IMSL subroutines
*          /usr/local/vni/CTT5.0/ctt/bin/cttsetup.csh
*
*Then Compile on cacsrv1 using command
*$F90 $F90FLAGS $LINK_F90 monthly_tele_indices_1950-pres.f
*The executable will be named a.out by default, and MUST BE RENAMED TO
*       monthly_tele_indices_1950-pres.exe
*
*The Grads control file for the monthly non-standardized indices is
*          monthly_raw_tele_indices.ctl 
********************************
'reinit'
'open /cpc/analysis/cdas/month/prs/mean/prs.grib.mean.y1949-cur.ctl'
*
* Caluclate 1950-2000 monthly climatology for standardizing the anomalies
'set lat 20 87.5'
'set lon 0 357.5'
'set lev 500'
'define rad = 3.14159/180'
*
'set time jan1949 dec2021'
'define z500=hgt'
'set t 1 12'
'define z500c=ave(z500,t+12,t=864,12)'
'modify z500c seasonal'
'define varzc=ave(pow(z500-z500c,2),t+12,t=864,12)'
'modify varzc seasonal'
*
'set time dec2021'
'q dims'
temp = sublin(result,5)
end = subwrd(temp,9)
cdate = mydate()
cmof = subwrd(cdate,2)
cyrf = subwrd(cdate,3)
*
'set time jan1949'
'q dims'
temp = sublin(result,5)
beg = subwrd(temp,9)
cdate = mydate()
cmoi = subwrd(cdate,2)
cyri = subwrd(cdate,3)
****************************************
*
nmo= end-beg+1
if(nmo=1);say 'Writing grids for 'cmof''cyrf;endif
if(nmo >1)
say 'Writing grids for 'nmo' months from 'cmoi''cyri' to 'cmof''cyrf
endif
*
'set gxout fwrite'
'set fwrite /cpc/consistency/telecon/gb/monthly_tele_pattern_1949-2021.in'
'set t 'beg' 'end
'd (z500-z500c)/sqrt(varzc)*sqrt(cos(lat*rad))'
'disable fwrite'
'quit'
*
function mydate
'query time'
sres = subwrd(result,3)
i=1
while (substr(sres,i,1)!='Z')
i=i+1
endwhile
hour = substr(sres,1,i)
isav = i
i = i + 1
while (substr(sres,i,1)>='0' & substr(sres,i,1)<='9')
i = i + 1
endwhile
day = substr(sres,isav+1,i-isav-1)
month = substr(sres,i,3)
year = substr(sres,i+3,4)
return (day' 'month' 'year)

