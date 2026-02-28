'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_olr_sat_wkly.winter.mm3.detrd.ctl'
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_olr_sat_wkly.winter.mm5.detrd.ctl'
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_olr_sat_wkly.winter.mm10.detrd.ctl'
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_olr_sat_wkly.winter.mm15.detrd.ctl'
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_olr_sat_wkly.winter.mm20.detrd.ctl'
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_olr_sat_wkly.winter.mm25.detrd.ctl'
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_olr_sat_wkly.winter.mm30.detrd.ctl'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 5.5 7.25 NA T2m Forecast Skill Based on OLR CA vs Kept EOFs'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.5;  xlen=8.5;  xgap=0.6
ymax0=7.; ylen=-6.0;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.5
  titly=ymax+0.2
  labx=xmin-0.65
  laby=ymin+3.
  sx1=6
  sy1=6
  sy2=5.6
  sy3=5.2
  sy4=4.8
  sy5=4.4
  sy6=4.0
  sy7=3.6
  
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
*'set xlab off'
'set xlabs CIC | WEEK1 | WEEK2 | WEEK3 | WEEK4 '
'set vrange 0 0.5'
'set grads off'
*'set grid off'
'set x 1'
'set y 50'
'set cthick 7'
'set cstyle 1'
'set t 1 5'
'set cmark 5'
'set ccolor 1'
'd tloop(aave(ac,lon=220,lon=310,lat=10,lat=75))'
'set ccolor 2'
'set cmark 5'
'd tloop(aave(ac.2,lon=220,lon=310,lat=10,lat=75))'
'set ccolor 3'
'set cmark 5'
'd tloop(aave(ac.3,lon=220,lon=310,lat=10,lat=75))'
'set ccolor 4'
'set cmark 5'
'd tloop(aave(ac.4,lon=220,lon=310,lat=10,lat=75))'
'set ccolor 5'
'set cmark 5'
'd tloop(aave(ac.5,lon=220,lon=310,lat=10,lat=75))'
'set ccolor 6'
'set cmark 5'
'd tloop(aave(ac.6,lon=220,lon=310,lat=10,lat=75))'
'set ccolor 7'
'set cmark 5'
'd tloop(aave(ac.7,lon=220,lon=310,lat=10,lat=75))'
*
'set string 1 tc 6 90'
'set strsiz 0.15 0.15'
'draw string 'labx' 'laby' ACC'
'set string 1 tl 5 0'
'draw string 'sx1' 'sy1' 3EOFs'
'set string 2 tl 5 0'
'draw string 'sx1' 'sy2' 5EOFs'
'set string 3 tl 5 0'
'draw string 'sx1' 'sy3' 10EOFs'
'set string 4 tl 5 0'
'draw string 'sx1' 'sy4' 15EOFs'
'set string 5 tl 5 0'
'draw string 'sx1' 'sy5' 20EOFs'
'set string 6 tl 5 0'
'draw string 'sx1' 'sy6' 25EOFs'
'set string 7 tl 5 0'
*'draw string 'sx1' 'sy7' 30EOFs'
  iframe=iframe+1
*'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 4.25 1.75'
endwhile
'printim aveac.olr_sat.vs.mm.png gif x800 y600'
'print'
*
*'c'
'set vpage off'
