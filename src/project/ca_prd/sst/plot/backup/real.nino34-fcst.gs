'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
*
analy_1=ersst
analy_2=hadoisst
eofrange_1=tp_ml
eofrange_2=tp_np
ic_mon=Jun2016
*
'enable print real.nino34.ca_fcst.'ic_mon'ic.gm'
*
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
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.14 0.14'
'draw string 5.5 7.5 CA Forecast for Nino3.4 SST Index'
'draw string 5.5 7.25 48 members, data thru 'ic_mon''
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.14 0.14'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.5;  xlen=8;  xgap=0.6
ymax0=7.0; ylen=-6;  ygap=-0.1
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
  x2=xmin+4.
  y11=ymax-0.5
  y22=ymax-0.7
  y33=ymax-0.9
  y44=ymax-1.1
  x3=xmin+3.0
  y55=ymax-0.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
'set x 1'
'set y 1'
'set grads off'
'set vrange -3. 3.'
*'set grid off'
'set t 1 11'
*'set cthick 1'
ii=1
while(ii<7)
'set ccolor 1'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
ii=7
while(ii<13)
'set ccolor 2'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
ii=13
while(ii<19)
'set ccolor 3'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
ii=19
while(ii<25)
'set ccolor 4'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
ii=25
while(ii<31)
'set ccolor 5'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
ii=31
while(ii<37)
'set ccolor 6'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
ii=37
while(ii<43)
'set ccolor 7'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
ii=43
while(ii<49)
'set ccolor 8'
'set cmark 0'
'd tloop(aave(sst.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
endwhile
* ens mean
'set ccolor 1'
'set cthick 25'
'set cmark 5'
'd tloop(aave((sst.1+sst.2+sst.3+sst.4+sst.5+sst.6+sst.7+sst.8+sst.9+sst.10+sst.11+sst.12+sst.13+sst.14+sst.15+sst.16+sst.17+sst.18+sst.19+sst.20+sst.21+sst.22+sst.23+sst.24+sst.25+sst.26+sst.27+sst.28+sst.29+sst.30+sst.31+sst.32+sst.33+sst.34+sst.35+sst.36+sst.37+sst.38+sst.39+sst.40+sst.41+sst.42+sst.43+sst.44+sst.45+sst.46+sst.47+sst.48)/48,lon=190,lon=240,lat=-5,lat=5))'
*
'draw xlab central month of season'
'draw ylab SST-anomaly(C`ao`n)'
 'set string 1 tc 5 90'
 'set strsiz 0.13 0.13'
 'set string 1 tc 5 0'
  iframe=iframe+1
endwhile
 'set string 1 tl 5 0'
 'draw string 'x1' 'y1' ER-SST,IC-1'
 'set string 2 tl 5 0'
 'draw string 'x1' 'y2' ER-SST,IC-2'
 'set string 3 tl 5 0'
 'draw string 'x1' 'y3' ER-SST,IC-3'
 'set string 4 tl 5 0'
 'draw string 'x1' 'y4' ER-SST,IC-4'
*
 'set string 5 tl 5 0'
 'draw string 'x2' 'y11' OI-SST,IC_1'
 'set string 6 tl 5 0'
 'draw string 'x2' 'y22' OI-SST,IC-2'
 'set string 7 tl 5 0'
 'draw string 'x2' 'y33' OI-SST,IC-3'
 'set string 8 tl 5 0'
 'draw string 'x2' 'y44' OI-SST,IC-4'
 'set string 1 tl 7 0'
 'draw string 'x3' 'y55' ENSEMBL MEAN'
'print'
'printim real.nino34.ca_fcst.'ic_mon'ic.png gif x1600 y1200'
*'c'
'set vpage off'
