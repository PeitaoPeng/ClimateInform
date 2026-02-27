#!/bin/sh

set -eaux

lcdir=/home/ppeng/ClimateInform/src/opr/src
tmp=/home/ppeng/data/tmp_opr
bindir=/home/ppeng/ClimateInform/src/bin
#
curyr=`date --date='today' '+%Y'`
curmo=`date --date='today' '+%m'`  # current month
#curyr=2025
#for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
#for curmo in 01; do
#
if [ $curmo = 01 ]; then cmon=1; icmon=12; icmonc=Dec; tgtmon=jan; tgtss=jfm; fi #tgtmon:1st mon of the lead-0 season
if [ $curmo = 02 ]; then cmon=2; icmon=1 ; icmonc=Jan; tgtmon=feb; tgtss=fma; fi
if [ $curmo = 03 ]; then cmon=3; icmon=2 ; icmonc=Feb; tgtmon=mar; tgtss=mam; fi
if [ $curmo = 04 ]; then cmon=4; icmon=3 ; icmonc=Mar; tgtmon=apr; tgtss=amj; fi
if [ $curmo = 05 ]; then cmon=5; icmon=4 ; icmonc=Apr; tgtmon=may; tgtss=mjj; fi
if [ $curmo = 06 ]; then cmon=6; icmon=5 ; icmonc=May; tgtmon=jun; tgtss=jja; fi
if [ $curmo = 07 ]; then cmon=7; icmon=6 ; icmonc=Jun; tgtmon=jul; tgtss=jas; fi
if [ $curmo = 08 ]; then cmon=8; icmon=7 ; icmonc=Jul; tgtmon=aug; tgtss=aso; fi
if [ $curmo = 09 ]; then cmon=9; icmon=8 ; icmonc=Aug; tgtmon=sep; tgtss=son; fi
if [ $curmo = 10 ]; then cmon=10; icmon=9; icmonc=Sep; tgtmon=oct; tgtss=ond; fi
if [ $curmo = 11 ]; then cmon=11; icmon=10; icmonc=Oct; tgtmon=nov; tgtss=ndj; fi
if [ $curmo = 12 ]; then cmon=12; icmon=11; icmonc=Nov; tgtmon=dec; tgtss=djf; fi
#
yyyy=$curyr
yyym=`expr $curyr - 1`
yyyp=`expr $curyr + 1`
#
tgtmoyr=$tgtmon$yyyy  # 1st mon of lead-1 season
#
if [ $icmon -eq 12 ]; then outyr_s=1952; skill_yr_s=1982; fi
#
icyr=$curyr
if [ $icmon = 12 ]; then icyr=`expr $curyr - 1`; fi
#
yr_end=`expr $curyr - 1952`
#
datadir=/home/ppeng/data/ss_fcst/pcr/$icyr/$icmon
#
nino_prd_ctl=nino34.prd.mics4.mlead8.ncut3.icut1_15.id_ceof1.cv1.3mon.pac.ctl
nino_obs_ctl=nino34.obs.icmon_$icmon.3mon.pac.ctl
#
skill=skill_nino34
#
cd $tmp
#
cat >nino_skill<<EOF
run skill.gs
EOF

cat >skill.gs<<EOFgs
'reinit'
'run $bindir/white.gs'
'run $bindir/rgbset.ss.gs'
*
'open $datadir/${nino_prd_ctl}'
'open $datadir/${nino_obs_ctl}'
*
'set gxout fwrite'
'set fwrite $datadir/$skill.gr'
ie=1
while(ie<=8)
'set e 'ie''
'define pp=sqrt(ave(x*x,t=30,t=${yr_end}))'
'define oo=sqrt(ave(x.2*x.2,t=30,t=${yr_end}))'
'define cor=ave(x*x.2,t=30,t=${yr_end}))/(oo*pp)'
'define rms=sqrt(ave((x-x.2)*(x-x.2),t=30,t=${yr_end}))'
'd cor'
'd rms'
ie=ie+1
endwhile
'disable fwrite'
EOFgs

/usr/bin/grads -bl <nino_skill

cat>$datadir/$skill.ctl}<<EOF
dset ^$skill.gr
undef -9.99E+33
title EXP1
XDEF   1 LINEAR    0    1.0
YDEF   1 LINEAR  -89.5  1.0
zdef   1 linear 1 1
tdef   8 linear ${tgtmoyr} 1mon
vars  2
ac  1 99 corr
rms 1 99 rmse
endvars
#
EOF
#======================================
# plot nino34 skill
#======================================
cat >skill_ts<<EOF
run skill_plot.gs
EOF
cat >skill_plot.gs<<EOFgs
'reinit'
'run $bindir/white.gs'
'run $bindir/rgbset.gs'
*
'open $datadir/$skill.ctl}'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.16 0.16'
'draw string 5.5 7.75 AC Skill of Seasonal Nino3.4 Index FCST ($icmonc ICs)'
'draw string 5.5 7.5 Verified over 1981-$yyym'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.14 0.14'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.;  xlen=9.5;  xgap=0.6
ymax0=7.25; ylen=-6;  ygap=-0.1
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin-0.4
  tly=ymin+0.875
  x1=xmin+2.5
  y1=ymax-0.5
  y2=ymax-0.7
  y3=ymax-0.9
  y4=ymax-1.1
  y5=ymax-1.3
  x2=xmin+4.
* y11=ymax-0.5
* y22=ymax-0.7
* y33=ymax-0.9
* y44=ymax-1.1
  x3=xmin+3.0
  ftx=xmin-0.75
  fty=ymin-1. 
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
'set xlabs 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 '
*
*'set mproj scaled'
'set x 1'
'set y 1'
'set grads off'
'set vrange 0. 1.'
*'set grid off'
'set t 1 8'
'set cthick 7'
'set ccolor 4'
'set cmark 1'
'd ac'
*
'draw xlab Lead Months'
'draw ylab AC Skill Score'

 'set string 1 tc 5 90'
 'set strsiz 0.13 0.13'
 'set string 1 tc 5 0'
  iframe=iframe+1
endwhile
*
'set string 4 tl 6'
'set strsiz 0.11 0.11'
'draw string 'ftx' 'fty' ClimateInform' 
*
'gxprint skill_nino34.png x1600 y1200'
*'print'
*
'c'
'set vpage off'
EOFgs

/usr/bin/grads -bl <skill_ts
cp skill_nino34.png $datadir

#done # mcur loop
