'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/casst/real_ca_prd.had-oisst.tp_ml.15.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.had-oisst.tp_ml.20.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.had-oisst.tp_ml.25.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.had-oisst.tp_ml.30.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.had-oisst.tp_ml.35.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.had-oisst.tp_ml.40.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.had-oisst.tp_np.15.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.had-oisst.tp_np.20.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.had-oisst.tp_np.25.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.had-oisst.tp_np.30.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.had-oisst.tp_np.35.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.had-oisst.tp_np.40.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.ersst.tp_ml.15.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.ersst.tp_ml.20.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.ersst.tp_ml.25.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.ersst.tp_ml.30.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.ersst.tp_ml.35.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.ersst.tp_ml.40.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.ersst.tp_np.15.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.ersst.tp_np.20.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.ersst.tp_np.25.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.ersst.tp_np.30.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.ersst.tp_np.35.3mon.ctl'
'open /cpc/home/wd52pp/data/casst/real_ca_prd.ersst.tp_np.40.3mon.ctl'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 5.5 8. NINO34 AC Skill vs EOF Trunc for JAS ICs (1981-2013)'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.14 0.14'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=1.;  xlen=4.25;  xgap=0.5
ymax0=7.75; ylen=-3;  ygap=-0.5
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
  x0=xmin+0.5
  y0=ymax-1.2
  y1=ymax-1.5
  y2=ymax-1.7
  y3=ymax-1.9
  y4=ymax-2.1
  y5=ymax-2.3
  y6=ymax-2.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
'set x 1'
'set y 1'
'set grads off'
'set vrange 0.2i 1'
*'set grid off'
'set xlabs  OND | NDJ | DJF | JFM | FMA | MAM | AMJ | MJJ '
'set t 4 11'
icolor=1
ii=(iframe-1)*6+1
iie=iframe*6+1
while(ii<iie)
'set ccolor 'icolor''
'set cmark 1'
'd tloop(aave(ac.'ii',lon=190,lon=240,lat=-5,lat=5))'
ii=ii+1
icolor=icolor+1
endwhile
if(iframe=2); 'draw xlab Target Seasons'; endif
if(iframe=4); 'draw xlab Target Seasons'; endif
if(iframe<3); 'draw ylab AC'; endif
 'set string 1 tc 5 90'
 'set strsiz 0.12 0.12'
 'set string 1 tl 5 0'
 'draw string 'xx' 'y1' 15 EOFs'
 'set string 2 tl 5 0'
 'draw string 'xx' 'y2' 20 EOFs'
 'set string 3 tl 5 0'
 'draw string 'xx' 'y3' 25 EOFs'
 'set string 4 tl 5 0'
 'draw string 'xx' 'y4' 30 EOFs'
 'set string 5 tl 5 0'
 'draw string 'xx' 'y5' 35 EOFs'
 'set string 6 tl 5 0'
 'draw string 'xx' 'y6' 40 EOFs'
 'set string 1 tl 6 0'
if(iframe=1); 'draw string 'x0' 'y0' HAD-OI SST, 45S-45N'; endif
if(iframe=2); 'draw string 'x0' 'y0' HAD-OI SST, 30S-60N'; endif
if(iframe=3); 'draw string 'x0' 'y0' ER SST, 45S-45N'; endif
if(iframe=4); 'draw string 'x0' 'y0' ER SST, 30S-60N'; endif
  iframe=iframe+1
endwhile
'printim eof_trunc.vs.skill.png gif x1600 y1200'
'print'
*
*'c'
'set vpage off'
