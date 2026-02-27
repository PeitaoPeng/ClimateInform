'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
*
tgts1=ASO2016
tgts2=NDJ2016_17
tgts3=FMA2017
analy_1=ersst
analy_2=hadoisst
eofrange_1=tp_ml
ic_mon=Jun2016
*
'enable print real.2d-sst_fcst.'ic_mon'IC.gm' 
ics=1
while ( ics <= 4 )
ieof=15
while ( ieof <= 40 )
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_1'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
ieof=ieof+5
endwhile
ics=ics+1
endwhile
*
ics=1
while ( ics <= 4 )
ieof=15
while ( ieof <= 40 )
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_2'.'eofrange_1'.'ieof'.'ics'ics.3mon.ctl'
ieof=ieof+5
endwhile
ics=ics+1
endwhile
*
'set t 5'
'define fcst1=(sst.1+sst.2+sst.3+sst.4+sst.5+sst.6+sst.7+sst.8+sst.9+sst.10+sst.11+sst.12+sst.13+sst.14+sst.15+sst.16+sst.17+sst.18+sst.19+sst.20+sst.21+sst.22+sst.23+sst.24+sst.25+sst.26+sst.27+sst.28+sst.29+sst.30+sst.31+sst.32+sst.33+sst.34+sst.35+sst.36+sst.37+sst.38+sst.39+sst.40+sst.41+sst.42+sst.43+sst.44+sst.45+sst.46+sst.47+sst.48)/48'
'set t 8'
'define fcst2=(sst.1+sst.2+sst.3+sst.4+sst.5+sst.6+sst.7+sst.8+sst.9+sst.10+sst.11+sst.12+sst.13+sst.14+sst.15+sst.16+sst.17+sst.18+sst.19+sst.20+sst.21+sst.22+sst.23+sst.24+sst.25+sst.26+sst.27+sst.28+sst.29+sst.30+sst.31+sst.32+sst.33+sst.34+sst.35+sst.36+sst.37+sst.38+sst.39+sst.40+sst.41+sst.42+sst.43+sst.44+sst.45+sst.46+sst.47+sst.48)/48'
'set t 11'
'define fcst3=(sst.1+sst.2+sst.3+sst.4+sst.5+sst.6+sst.7+sst.8+sst.9+sst.10+sst.11+sst.12+sst.13+sst.14+sst.15+sst.16+sst.17+sst.18+sst.19+sst.20+sst.21+sst.22+sst.23+sst.24+sst.25+sst.26+sst.27+sst.28+sst.29+sst.30+sst.31+sst.32+sst.33+sst.34+sst.35+sst.36+sst.37+sst.38+sst.39+sst.40+sst.41+sst.42+sst.43+sst.44+sst.45+sst.46+sst.47+sst.48)/48'
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.14 0.14'
'draw string 4.25 10.250 CA SST Forecast, ICs through 'ic_mon''
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
'set lat -65 65'
*'set xlab off'
'set yaxis -65 65 20'
if(iframe = 5);'set xlab on';endif
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs -2 -1.5 -1 -0.5 -0.25 0.25 0.5 1 1.5 2'
'set ccols  49 47 45 43 41 0 21 23 25 27 29'
'd fcst'%iframe
*
 'set string 1 tl 5 0'
 'set strsiz 0.13 0.13'
if(iframe = 1);'draw string 'tlx' 'tly' 'tgts1'';endif
if(iframe = 2);'draw string 'tlx' 'tly' 'tgts2'';endif
if(iframe = 3);'draw string 'tlx' 'tly' 'tgts3'';endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -65 180 65'
 'set string 1 tc 5 0'
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 0 4.25 0.75'
endwhile
'print'
'printim real.2d-sst_fcst.'ic_mon'IC.png gif x1200 y1600'
*
*'c'
'set vpage off'
