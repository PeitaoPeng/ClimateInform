'reinit'
'enable print metafile'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
*'open /cpc/home/wd52pp/project/attr/win13-14/z200.ndjfm2013-14.mon.para.esm.ctl'
'open /cpc/home/wd52pp/project/attr/win13-14/psi_vlp.ndjfm2013-14.mon.para.esm.R15.ctl'
*'open /cpc/home/wd52pp/data/obs/sst/sst.had-oi.jan1979-cur.mon.anom.ctl'
'open /cpc/home/wd52pp/data/attr/winter13-14/wvflx.tn.DJF2013-14.para.ctl'
*'open prate.nov13-mar14.esm.ctl'
'open prate.nov13-mar14.esm.144x72.ctl'
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
*'define sstm=ave(sst.2,time=dec2013,time=feb2014)'
*'define z200=ave(z,time=dec2013,time=feb2014)'
'define s200=ave(psi,time=dec2013,time=feb2014)/1000000'
'define psim=s200-ave(s200,lon=0,lon=360,-b)'
'define u1=skip(xflx.2(time=jan2014),2,2)'
'define v1=skip(yflx.2(time=jan2014),2,2)'
'define prm=ave(p.3,time=dec2013,time=feb2014)'
'set t 1'
if(iframe = 1);
'set lon 0 360'
'set lat  -40 90'
*'set frame off'
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs   -4 -3 -2 -1 -0.5 0.5 1 2 3 4'
'set ccols   79 77 75 73 71 0 31 33 35 37 39'
'd prm'
'set gxout contour'
'set ccolor 8'
'set cint 2'
'd psim'
'set gxout vector'
'set arrscl  0.5 15'
'set arrowhead 0.05'
'set ccolor 4'
'd maskout(u1,sqrt(u1*u1+v1*v1)-1.);maskout(v1,sqrt(u1*u1+v1*v1)-1.)';
endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -40 180 90'
'set string 1 tl 5 0'
'set strsiz 0.12 0.12'
*if(iframe = 1); 'draw string 'tlx' 'tly' a)PSI200,Prate & wvflx'; endif
'set string 1 tl 5 0'

iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.6 1 'bx' 'by''
endwhile
'print'
'printim Fig5.png gif x1200 y1600'

