'reinit'
'enable print metafile'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/djf14-15/z_s_v.200mb.jan1979-feb2015.cfsr.mon.R15.ctl'
'open /cpc/home/wd52pp/data/obs/sst/sst.had-oi.jan1979-cur.mon.anom.ctl'
'open /cpc/home/wd52pp/data/attr/winter13-14/wvflx.tn.djfm2013-14.ctl'
'open prate.oct13-mar14.ctl'
*'open prate.oct13-mar14.tp.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
*'draw string 5.5 7.5 200mb HGT(m) and SST(K), DJFM2013/14'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
nframe3=3
xmin0=1.25;  xlen=6.;  xgap=0.2
ymax0=10.; ylen=-3.;  ygap=-0.15
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  if (iframe > nframe3); icx=3; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if (iframe > nframe3); icy=iframe-nframe3; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin+0.
  tly=ymax+0.
  bx=xmax+0.25
  by=ymin + 1.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'define sstm=ave(sst.2,time=dec2013,time=mar2014)'
*'define z200=ave(z,time=dec2013,time=mar2014)'
'define sstm=ave(sst.2,time=dec2013,time=feb2014)'
'define z200=ave(z,time=dec2013,time=feb2014)'
'define s200=ave(s,time=dec2013,time=feb2014)/1000000'
'define psim=s200-ave(s200,lon=0,lon=360,-b)'
'define u1=skip(xflx.3,2,2)'
'define v1=skip(yflx.3,2,2)'
*'define u1=xflx.3'
*'define v1=yflx.3'
'define prm=ave(p.4,time=dec2013,time=mar2014)'
'set t 1'
if(iframe = 1);
'set lon 0 360'
'set lat  -40 90'
*'set frame off'
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs    -2 -1 -0.75 -0.5 -0.25 0.25 0.5 0.75 1 2'
'set ccols   49 47 45 43 41 0 21 23 25 27 29'
*'set clevs   -2.5 -2 -1.5 -1 -0.5 -0.25 0.25 0.5 1 1.5 2 2.5'
*'set ccols   49 47 45 44 43 42 0 22 23 24 25 27 29'
'd sstm'
'set gxout contour'
'set ccolor 1'
'set cint 30'
'd z200'
endif
if(iframe = 3);
'set lon 0 360'
'set lat  -40 90'
*'set frame off'
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs -4. -3. -2. -1 1 2 3 4'
'set ccols 44 43 42 41 0 21 22 23 24'
'd 200000*hdivg(xflx.3,yflx.3)'
'set gxout contour'
'set ccolor 8'
'd psim'
'set gxout vector'
'set ccolor 1'
*'d maskout(u1,sqrt(u1*u1+v1*v1)-1.5);maskout(v1,sqrt(u1*u1+v1*v1)-1.5)';
'd maskout(u1,sqrt(u1*u1+v1*v1)-10);maskout(v1,sqrt(u1*u1+v1*v1)-10)';
*'d u1;v1'
endif
if(iframe = 2);
'set lon 0 360'
'set lat  -40 90'
*'set frame off'
'set grads off'
*'set grid off'
'set gxout shaded'
*'set clevs   -3 -2.5 -2 -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
*'set ccols   79 77 76 75 74 72 0 32 34 35 36 37 39'
*'set clevs -3 -2 -1 -0.5 0.5 1 2 3'
*'set ccols 77 75 73 71 0 31 33 35 37'
'set clevs   -4 -3 -2 -1 -0.5 0.5 1 2 3 4'
'set ccols   79 77 75 73 71 0 31 33 35 37 39'
'd prm'
'set gxout contour'
'set ccolor 4'
'set cint 2'
'd psim'
endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -40 180 90'
'set string 1 tl 5 0'
'set strsiz 0.12 0.12'
if(iframe = 1); 'draw string 'tlx' 'tly' a)SST & Z200'; endif
if(iframe = 3); 'draw string 'tlx' 'tly' c)PSI200 & Wave Activity Flux'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' b)PSI200 & Prate'; endif
'set string 1 tl 5 0'

iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.6 1 'bx' 'by''
endwhile
'print'
'printim fig1.png gif x1200 y1600'

