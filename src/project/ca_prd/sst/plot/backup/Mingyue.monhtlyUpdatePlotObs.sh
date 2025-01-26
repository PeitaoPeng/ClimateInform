#!/bin/sh
set -ax

# vargif: name for gif file to be created
# var   : name of variable to be used for plotting


tyy=`echo $tDate | cut -c1-4`
tmm=`echo $tDate | cut -c5-6`

gyy=`echo $gDate | cut -c1-4`
gmm=`echo $gDate | cut -c5-6`

iyy=`echo $iDate | cut -c1-4`
imm=`echo $iDate | cut -c5-6`

cd  $workDir

clevsSST="-3 -2 -1 -0.5 -0.25 0.25 0.5 1 2 3"
ccolsSST="59 49 46 44 42 70 22 24 26 29 79"
clevsPrecGL="-7 -5 -3 -1 -0.5 -0.2  0.2 0.5 1 3 5 7"
ccolsPrecGL="79 29 28 26 24  22  70  32  34 36 38 39 49"
clevsPrecNA="-3 -2 -1 -0.5 -0.3 -0.1  0.1 0.3 0.5 1  2 3"
ccolsPrecNA="79 29 28 26 24  22  70  32  34 36 38 39 49"
clevsT2mGL="-4 -3 -2 -1 -0.5 0.5 1 2 3 4"
ccolsT2mGL="59 56 49 46 43 70  23 26 29 74 78"
clevsT2mNA="-4 -3 -2 -1 -0.5 0.5 1 2 3 4"
ccolsT2mNA="59 56 49 46 43 70  23 26 29 74 78"
clevsSMGL="-150 -120 -90 -60 -30 30 60 90 120 150"
ccolsSMGL="79 75 29 26 23 70 33 36 39 45 49"
clevsSMNA="-150 -120 -90 -60 -30 30 60 90 120 150"
ccolsSMNA="79 75 29 26 23 70 33 36 39 45 49"
clevsz200GL="-90 -75 -60 -45 -30 -15 0 15 30 45 60 75 90"
ccolsz200GL="49 47 46 45 43 42 70 70 22 23 25 26 27 29"
clevsz200NA="-90 -75 -60 -45 -30 -15 0 15 30 45 60 75 90"
ccolsz200NA="49 47 46 45 43 42 70 70 22 23 25 26 27 29"
var1=Prec
var2=z200
var3=T2m
var4=SM

for vargif in SST GL NA; do 
 if [ $vargif = 'SST' ] ; then
  var=SST
  region=GL
  lat1=-75
  lat2=65
  lon1=0
  lon2=360
  xlint=60
  ylint=15
  maxpanel=1
 fi
 if [ $vargif = 'GL' ] ; then
  var=GL
  region=GL
  lat1=-90
  lat2=90
  lon1=0
  lon2=360
  xlint=60
  ylint=30
  maxpanel=4
 fi
 if [ $vargif = 'NA' ] ; then
  var=NA
  region=NA
  lat1=20
  lat2=80
  lon1=185
  lon2=305
  xlint=20
  ylint=10
  maxpanel=4
 fi

gsfile=SSNmean.obs.$vargif.gs
giffile=SSNmean.obs.${vargif}.gif
cat >$gsfile<< EOFgs
'reinit'
'enable print fig.meta'
'set display color white'
'c'
*'set mproj scaled'
'set map 1 1 1'
'set font 0'

region=$region
var=$var
'open /cpc/noscrub/Wanqiu.Wang/data/obs/sst/monthly/NCDC1x1sstaRT/NCDC1x1SSTa.ctl'
'open /cpc/noscrub/Mingyue.Chen/OBS/CFSv2MonRT/PrecOpiMonAnmT126.ctl'
'open /cpc/noscrub/Mingyue.Chen/OBS/CFSv2MonRT/cfsrZ200MonAnm.ctl'
'open /cpc/noscrub/Mingyue.Chen/OBS/CFSv2MonRT/T2mGhcnT126MonAnm.ctl'
'open /cpc/noscrub/Mingyue.Chen/OBS/CFSv2MonRT/cfsrSMMonAnm.ctl'
'open /u/Mingyue.Chen/mask/landsfcGFSt126.ctl'

xmin=0.5
xmax=10.5
ymin=1.0
ymax=7.5
xgap=0.8
ygap=1.5
xlen=(xmax-xmin-xgap)/2
ylen=(ymax-ymin-ygap)/2

  'set grads off'
  'set grid on'
  'set xlopts 1 5 0.15'
  'set ylopts 1 5 0.15'
  'set rgb  80  200 200 200'
  'set rgb  70  255 255 255'
  'run /u/Mingyue.Chen/grads.2.0.2/scripts/rgbset.gs'
trgyy=$tyy
trgmm=$tmm
trgDate=mmyyconv(trgmm,trgyy)
trgSSN= mmyycsea(trgmm,trgyy)
gradsyy=$gyy
gradsmm=$gmm
gradsDate=mmyyconv(gradsmm,gradsyy) 
say 'trgDate='trgDate
say 'trgSSN='trgSSN
say 'gradsDate='gradsDate

iniyy=$iyy
inimm=$imm
iniDate=mmyyconv(inimm,iniyy)
say 'iniDate='iniDate

ssnmm1=gradsmm
ssnyy1=gradsyy
ssntime1=mmyyconv(ssnmm1,ssnyy1)
say 'ssntime1='ssntime1

ssnmm2=gradsmm+2
ssnyy2=gradsyy
if(ssnmm2>12)
ssnmm2=ssnmm2-12
ssnyy2=ssnyy2+1
endif
ssntime2=mmyyconv(ssnmm2,ssnyy2)
say 'ssntime2='ssntime2

'set time 'gradsDate 
'set lat -90 90'
'set lon 0 360'
'set z 1'
'set lat $lat1 $lat2'
'set lon $lon1 $lon2'
'set xlint $xlint'
'set ylint $ylint'

ic=0
while(ic<2)
ic=ic+1
jc=0
while(jc<2)
jc=jc+1
panel=99

if(ic=1&jc=1)
panel=1
if (var='SST')
'define a=ave(ssta$climprd.1,time='ssntime1',time='ssntime2')'
'set clevs $clevsSST'
'set ccols $ccolsSST'
ctitle='Obs SST(K)'
else
'define a=ave(opi$climprd.2,time='ssntime1',time='ssntime2')'
'set clevs $clevsPrecGL'
'set ccols $ccolsPrecGL'
ctitle='Obs Prec(mm/day)'
if(region='NA')
'set mpdset mres'
'set clevs $clevsPrecNA'
'set ccols $ccolsPrecNA'
'define a=maskout(a,landsfc.6(t=1,z=1)-0.5)'
endif
endif
endif
say 'panel='panel

if(ic=1&jc=2)
panel=2
'define a=ave(z200$climprd.3,time='ssntime1',time='ssntime2')'
'set clevs $clevsz200GL'
'set ccols $ccolsz200GL'
ctitle='Obs z200(m)'
if(region='NA')
'set mpdset mres'
'set clevs $clevsz200NA'
'set ccols $ccolsz200NA'
endif
endif
say 'panel='panel

if(ic=2&jc=1)
panel=3
'define a=maskout(ave(TMP2m$climprd.4,time='ssntime1',time='ssntime2'),landsfc.6(t=1,z=1)-0.5)'
'set clevs $clevsT2mGL'
'set ccols $ccolsT2mGL'
ctitle='Obs T2m(K)'
if(region='NA')
'set mpdset mres'
'set clevs $clevsT2mNA'
'set ccols $ccolsT2mNA'
endif
endif
say 'panel='panel

if(ic=2&jc=2)
panel=4
'define a=maskout(ave(SM$climprd.5,time='ssntime1',time='ssntime2'),landsfc.6(t=1,z=1)-0.5)'
'set clevs $clevsSMGL'
'set ccols $ccolsSMGL'
ctitle='Obs SoilM(mm)'
if(region='NA')
'set mpdset mres'
'set clevs $clevsSMNA'
'set ccols $ccolsSMNA'
endif
endif
say 'panel='panel

if(panel<=$maxpanel)
if(region='GL')
'set gxout shaded'
endif
if(region='NA')
'set gxout grfill'
endif
if(var='SST')
x1=2.0
x2=9.0
y2=7.0
y1=1.0
else
x1=xmin+(ic-1)*(xlen+xgap)
x2=x1+xlen
y2=ymax-(jc-1)*(ylen+ygap)
y1=y2-ylen
endif
'set parea  'x1' 'x2' 'y1' 'y2
'd a'
if(region='GL')
'run eq.gs'
endif
xmid=(x1+x2)/2
if(var='SST')
ymid=y1+0.5
'run cbarn.gs 1.0 0 'xmid' 'ymid
else
ymid=y1-0.6
'run cbarn.gs 0.6 0 'xmid' 'ymid
endif

'set strsiz 0.15'
'set string 4 L 6 0'
xstr=x1
ystr=y2+0.2
if(var='SST')
ystr=y2-1.0
'set strsiz 0.25'
endif
'draw string 'xstr' 'ystr' 'ctitle

'set string 4 R 6 0'
xstr=x2
ystr=y2+0.2
if(var='SST')
ystr=y2-1.0
'set strsiz 0.25'
endif
'set strsiz 0.15'
'draw string 'xstr' 'ystr' 'trgSSN
endif
endwhile
endwhile
'print'

function mmyyconv(mm,yyyy)
  if(mm=1); cmo='Jan'; endif
  if(mm=2); cmo='Feb'; endif
  if(mm=3); cmo='Mar'; endif
  if(mm=4); cmo='Apr'; endif
  if(mm=5); cmo='May'; endif
  if(mm=6); cmo='Jun'; endif
  if(mm=7); cmo='Jul'; endif
  if(mm=8); cmo='Aug'; endif
  if(mm=9); cmo='Sep'; endif
  if(mm=01); cmo='Jan'; endif
  if(mm=02); cmo='Feb'; endif
  if(mm=03); cmo='Mar'; endif
  if(mm=04); cmo='Apr'; endif
  if(mm=05); cmo='May'; endif
  if(mm=06); cmo='Jun'; endif
  if(mm=07); cmo='Jul'; endif
  if(mm=08); cmo='Aug'; endif
  if(mm=09); cmo='Sep'; endif
  if(mm=10); cmo='Oct'; endif
  if(mm=11); cmo='Nov'; endif
  if(mm=12); cmo='Dec'; endif
return (cmo''yyyy)

function dmycnv(dd,mm,yyyy)
  if(mm=1); cmo='Jan'; endif
  if(mm=2); cmo='Feb'; endif
  if(mm=3); cmo='Mar'; endif
  if(mm=4); cmo='Apr'; endif
  if(mm=5); cmo='May'; endif
  if(mm=6); cmo='Jun'; endif
  if(mm=7); cmo='Jul'; endif
  if(mm=8); cmo='Aug'; endif
  if(mm=9); cmo='Sep'; endif
  if(mm=01); cmo='Jan'; endif
  if(mm=02); cmo='Feb'; endif
  if(mm=03); cmo='Mar'; endif
  if(mm=04); cmo='Apr'; endif
  if(mm=05); cmo='May'; endif
  if(mm=06); cmo='Jun'; endif
  if(mm=07); cmo='Jul'; endif
  if(mm=08); cmo='Aug'; endif
  if(mm=09); cmo='Sep'; endif
  if(mm=10); cmo='Oct'; endif
  if(mm=11); cmo='Nov'; endif
  if(mm=12); cmo='Dec'; endif
return (dd''cmo''yyyy)
function mmyycsea(mm,yyyy)
  if(mm=1); sea='DJF'; endif
  if(mm=2); sea='JFM'; endif
  if(mm=3); sea='FMA'; endif
  if(mm=4); sea='MAM'; endif
  if(mm=5); sea='AMJ'; endif
  if(mm=6); sea='MJJ'; endif
  if(mm=7); sea='JJA'; endif
  if(mm=8); sea='JAS'; endif
  if(mm=9); sea='ASO'; endif
  if(mm=01); sea='DJF'; endif
  if(mm=02); sea='JFM'; endif
  if(mm=03); sea='FMA'; endif
  if(mm=04); sea='MAM'; endif
  if(mm=05); sea='AMJ'; endif
  if(mm=06); sea='MJJ'; endif
  if(mm=07); sea='JJA'; endif
  if(mm=08); sea='JAS'; endif
  if(mm=09); sea='ASO'; endif
  if(mm=10); sea='SON'; endif
  if(mm=11); sea='OND'; endif
  if(mm=12); sea='NDJ'; endif
  if(mm<12&mm>1); cyyyy=yyyy; endif
  if(mm=1|mm=01)
   yyyy0=yyyy-1
   cyyyy=yyyy0'/'yyyy
  endif
  if(mm=12)
   yyyy2=yyyy+1
   cyyyy=yyyy'/'yyyy2
  endif
return (sea''cyyyy)

EOFgs


/usrx/local/GrADS/2.0.2/bin/grads -bl <<EOF
run $gsfile
quit
EOF

/u/Mingyue.Chen/utl/meta2gifLM fig.meta  $giffile
cp $giffile $saveDir/
/bin/rm fig.meta

done

