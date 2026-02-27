'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
*
tgts1=SON2016
tgts2=DJF2016_17
tgts3=MAM2017
analy_1=ersst
analy_2=hadoisst
eofrange_1=tp_ml
ic_mon=Jul2016
*
'enable print real.2d-sst_fcst.'ic_mon'IC.gm' 
ics=1
while ( ics <= 4 )
icut=1
while ( icut <= 3 )
if (icut = 1); ieof=15; endif
if (icut = 2); ieof=25; endif
if (icut = 3); ieof=40; endif
'open /cpc/home/wd52pp/data/casst/real_ca_prd.temp.'analy_1'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
icut=icut+1
endwhile
ics=ics+1
endwhile
*
ics=1
while ( ics <= 4 )
icut=1
while ( icut <= 3 )
if (icut = 1); ieof=15; endif
if (icut = 2); ieof=25; endif
if (icut = 3); ieof=40; endif
'open /cpc/home/wd52pp/data/casst/real_ca_prd.temp.'analy_2'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
icut=icut+1
endwhile
ics=ics+1
endwhile
*
'set t 5'
'define fcst1=100*(ac.1+ac.2+ac.3+ac.4+ac.5+ac.6+ac.7+ac.8+ac.9+ac.10+ac.11+ac.12+ac.13+ac.14+ac.15+ac.16+ac.17+ac.18+ac.19+ac.20+ac.21+ac.22+ac.23+ac.24)/24'
'set t 8'
'define fcst2=100*(ac.1+ac.2+ac.3+ac.4+ac.5+ac.6+ac.7+ac.8+ac.9+ac.10+ac.11+ac.12+ac.13+ac.14+ac.15+ac.16+ac.17+ac.18+ac.19+ac.20+ac.21+ac.22+ac.23+ac.24)/24'
'set t 11'
'define fcst3=100*(ac.1+ac.2+ac.3+ac.4+ac.5+ac.6+ac.7+ac.8+ac.9+ac.10+ac.11+ac.12+ac.13+ac.14+ac.15+ac.16+ac.17+ac.18+ac.19+ac.20+ac.21+ac.22+ac.23+ac.24)/24'
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.14 0.14'
'draw string 4.25 10.250 CA T2m_AC Skill, SST ICs through 'ic_mon''
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.25;  xlen=6;  xgap=0.6
ymax0=9.75; ylen=-2.5;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin+0.2
  tly=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
'set vpage 0 8.5 0 11'
'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
'set lon 0 360'
'set lat -60 80'
*'set xlab off'
'set yaxis -60 80 20'
if(iframe = 5);'set xlab on';endif
'set grads off'
*'set grid off'
'set gxout shaded'
*'set clevs 10 20 30 40 50 60 70 80 90'
*'set ccols  0 91 92 31 33 35 37 81 82 85'
'set clevs 20 30 40 50 60 70 80 90'
'set ccols  0 43 42 62 63 64 65 67 69'
'd fcst'%iframe
*
'set string 1 tl 5 0'
'set strsiz 0.13 0.13'
if(iframe = 1);'draw string 'tlx' 'tly' 'tgts1'';endif
if(iframe = 2);'draw string 'tlx' 'tly' 'tgts2'';endif
if(iframe = 3);'draw string 'tlx' 'tly' 'tgts3'';endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -60 180 80'
'set string 1 tc 5 0'
 iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 0 4.25 0.75'
endwhile
'print'
'printim real.2d-temp_ave_ac.'ic_mon'IC.png gif x1200 y1600'
*
*'c'
'set vpage off'
