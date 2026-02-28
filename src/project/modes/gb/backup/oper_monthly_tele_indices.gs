******************************************************************
* PROGRAM: 
* directory: /cpc/prod_tst/cwlinks/indices/gerry/cdb_teleconnections/scripts
* script name: oper_monthly_tele_indices.gs
*
* LANGUAGE: grads scripting language
*
* MACHINE: Compute Farm
*----------------------------------------------------------------*
*
* PURPOSE: 
*Write out standardized 500-hpa monthly height anomalies to file
*Write out 700-hPa heights to file 
*    
*----------------------------------------------------------------*
* USAGE: Data used as input for calculating monthly 500-hPa teleconnection indices
* by code ../sources/oper_monthly_tele_indices.f 
* Data used as input for calculating monthly 700-hPa teleconnection indices
* by codes ../sources/read700.f and ../sources/oper_monthly_old_teleindices_update.f
*----------------------------------------------------------------*
* INPUT FILES:   
* fdir: Grads control file for monthly 500-hPa heights 
*              
* OUTPUT FILES 
* ../work/oper_monthly_tele_indices.gerry.in: monthly 500-hPa standardized height anomalies
* ../work/oper_monthly_700data.in: 700-hPa monthly mean heights
* ../work/daymon.gerry.dat: file specifying dates that were read in
*
*---------------------------------------------------------------
* FUNCTIONS USED:   Grads
*                     
*----------------------------------------------------------------
* INPUT VARIABLES:   
*
*cmoi, cyri:  beginning month and year to get data
*cmof, cyrf: ending month and year to get data
*hgt: monthly mean heights

*LOCAL VARIABLES
*z500: monthly 500-hPa heights
*z500c: 500-hPa monthly climo means (1950-2000)
*varzc: 500-hPa monthly climo standard deviations (1950-2000)
*nmo: number of months read in
*
*----------------------------------------------------------------*
* AUTHOR(S):        Gerry Bell
*----------------------------------------------------------------*
* DATE               3/2/2011
*----------------------------------------------------------------*
* MODIFICATIONS:
*******************************************************************
function test1(args)
fdir = subwrd(args,1)
cmoi= subwrd(args,2)
cyri= subwrd(args,3)
cmof= subwrd(args,4)
cyrf= subwrd(args,5)
*
********************************
'reinit'
'open 'fdir
*
'set lat 20 87.5'
'set lon 0 357.5'
'define rad = 3.14159/180'
*
'set time 'cmoi''cyri
'q dims'
temp = sublin(result,5)
beg = subwrd(temp,9)
*
'set time 'cmof''cyrf
'q dims'
temp = sublin(result,5)
end = subwrd(temp,9)
****************************************
*
nmo= end-beg+1
if(nmo=1);say 'Writing grids for 'cmof''cyrf;endif
if(nmo >1)
say 'Writing grids for 'nmo' months from 'cmoi''cyri' to 'cmof''cyrf
endif
'set lev 500'
'set t 1 last'
'define z500=hgt'
*
* Caluclate 1950-2000 monthly climatology 
* for standardizing the anomalies
*
'set t 1 12'
'define z500c=ave(z500,t+12,t=624,12)'
'modify z500c seasonal'
'define varzc=ave(pow(z500-z500c,2),t+12,t=624,12)'
'modify varzc seasonal'
*
'set gxout fwrite'
'set fwrite ../work/oper_monthly_tele_indices.gerry.in'
'set t 'beg' 'end
'd (z500-z500c)/sqrt(varzc)*sqrt(cos(lat*rad))'
'disable fwrite'
*
*get monthly 700-hPa data for old monthly teleconnection indices
*
'set lev 700'
'set gxout fwrite'
'set fwrite ../work/oper_monthly_700data.in'
'set lat 0 90'
'set lon 0 357.5'
'd hgt'
'disable fwrite'
*
write ('../work/daymon.gerry.dat',nmo)
write ('../work/daymon.gerry.dat',cmoi,append)
write ('../work/daymon.gerry.dat',cyri,append)
write ('../work/daymon.gerry.dat',cmof,append)
write ('../work/daymon.gerry.dat',cyrf,append)
close ('../work/daymon.gerry.dat')
*
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

