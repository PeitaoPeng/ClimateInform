'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
analy_1=ersst
analy_2=hadoisst
eofrange_1=tp_np
eofrange_2=tp_ml
ic_season=mjj
*
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_1'.'eofrange_1'.15.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_1'.'eofrange_1'.20.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_1'.'eofrange_1'.25.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_1'.'eofrange_1'.30.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_1'.'eofrange_1'.35.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_1'.'eofrange_1'.40.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_1'.'eofrange_2'.15.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_1'.'eofrange_2'.20.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_1'.'eofrange_2'.25.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_1'.'eofrange_2'.30.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_1'.'eofrange_2'.35.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_1'.'eofrange_2'.40.3mon.ctl'
*
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_2'.'eofrange_1'.15.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_2'.'eofrange_1'.20.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_2'.'eofrange_1'.25.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_2'.'eofrange_1'.30.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_2'.'eofrange_1'.35.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_2'.'eofrange_1'.40.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_2'.'eofrange_2'.15.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_2'.'eofrange_2'.20.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_2'.'eofrange_2'.25.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_2'.'eofrange_2'.30.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_2'.'eofrange_2'.35.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.'analy_2'.'eofrange_2'.40.3mon.ctl'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 5.5 8. NINO34-area averaged AC Skill of 'ic_season' ICs (1981-2013)'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.14 0.14'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.;  xlen=9;  xgap=0.6
ymax0=7.75; ylen=-6;  ygap=-0.1
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
  xx=xmin+1
  y1=ymax-2.0
  y2=ymax-2.3
  y3=ymax-2.6
  y4=ymax-2.9
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
'set x 1'
'set y 1'
'set grads off'
'set vrange 0. 1'
*'set grid off'
'set xlabs  DJF | JFM | FMA | MAM | AMJ | MJJ | JJA | JAS '
'set t 4 11'
ii=1
'set ccolor 1'
'set cmark 0'
'd tloop(aave((ac+ac.2+ac.3+ac.4+ac.5+ac.6)/6.,lon=190,lon=240,lat=-5,lat=5))'
'set ccolor 2'
'set cmark 0'
'd tloop(aave((ac.7+ac.8+ac.9+ac.10+ac.11+ac.12)/6.,lon=190,lon=240,lat=-5,lat=5))'
'set ccolor 3'
'set cmark 0'
'd tloop(aave((ac.13+ac.14+ac.15+ac.16+ac.17+ac.18)/6.,lon=190,lon=240,lat=-5,lat=5))'
'set ccolor 4'
'set cmark 0'
'd tloop(aave((ac.19+ac.20+ac.21+ac.22+ac.23+ac.24)/6.,lon=190,lon=240,lat=-5,lat=5))'
'draw xlab Target Seasons'
'draw ylab AC'
 'set string 1 tc 5 90'
 'set strsiz 0.14 0.14'
 'set string 1 tc 5 0'
  iframe=iframe+1
endwhile
 'set string 1 tl 5 0'
 'draw string 'xx' 'y1' HAD-OI SST, 45S-45N'
 'set string 2 tl 5 0'
 'draw string 'xx' 'y2' HAD-OI SST, 30S-60N'
 'set string 3 tl 5 0'
 'draw string 'xx' 'y3' ER SST, 45S-45N'
 'set string 4 tl 5 0'
 'draw string 'xx' 'y4' ER SST, 30S-60N'
'printim real.nino34_area.ac.'ic_season'ic.png gif x1600 y1200'
'print'
*
*'c'
'set vpage off'
