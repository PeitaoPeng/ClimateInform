'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/sst14-15/sst.had-oi.dec1949-dec2014.djf.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/corr.nino34.vs.sst.1949-cur.djf.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/psi_hgt.200mb.R1.dec1949-dec2014.djf.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/prate.dec1979-dec2014.djf.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/corr.nino34.vs.sz.1949-cur.djf.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/corr.nino34.vs.prate.1979-cur.djf.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
*'draw string 5.5 7.5 Regr&Corr of PSI200 to SST PCs jfm1949-jfm2015'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
nframe3=4
xmin0=1.;  xlen=4.5;  xgap=0.1
ymax0=7.5; ylen=-2.5;  ygap=0.75
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
  tlx1=xmin-0.5
  tly1=ymax-1.25
  tlx2=xmin+2.25
  tly2=ymax-0.2
  bx=xmin+2.25
  by=ymin-0.1
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define s1=sst(t=66)'
'define s2=sreg.2(t=1))'
'define s3=s.3(t=66)'
'define s4=sreg.5(t=1)'
'define p3=p.4(time=dec2014)'
'define p4=preg.6(t=1)'
'set t 1'
'set lon 0 360'
'set lat  -30 80'
'set yaxis -30 80 20'
'set xlab off'
'set ylab off'
if(iframe = 2); 'set xlab on'; endif
if(iframe = 1); 'set ylab on'; endif
if(iframe = 2); 'set ylab on'; endif
if(iframe = 4); 'set xlab on'; endif
if(iframe > 3); 'set ylab off'; endif
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
if(iframe < 3);
 'set gxout shaded'
'set clevs   -1.5 -1.2 -0.9 -0.6 -0.3 0.3 0.6 0.9 1.2 1.5'
'set ccols   49 47 45 43 41 0 21 23 25 27 29'
'd s'%iframe
endif
if(iframe > 2);
'set gxout shaded'
'set clevs   -4 -3 -2 -1 -0.5 0.5 1 2 3 4'
'set ccols   79 77 75 73 72 0 32 33 35 37 39'
'd p'%iframe
'set gxout contour'
'set ccolor 4'
'set cint 2'
if(iframe = 4);'set cint 1';endif
'd 0.000001*s'%iframe
endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 80'
'set string 1 tc 5 90'
'set strsiz 0.14 0.14'
if(iframe = 1);'draw string 'tlx1' 'tly1' DJF OBS';endif
if(iframe = 2);'draw string 'tlx1' 'tly1' Regressed';endif
'set string 1 tc 5 0'
'set strsiz 0.14 0.14'
if(iframe = 1);'draw string 'tlx2' 'tly2' SST';endif
if(iframe = 3);'draw string 'tlx2' 'tly2' psi200 & Prate';endif

if(iframe = 2);'run /cpc/home/wd52pp/bin/cbarn2.gs 0.5 0 'bx' 'by'';endif
if(iframe = 4);'run /cpc/home/wd52pp/bin/cbarn2.gs 0.5 0 'bx' 'by'';endif
iframe=iframe+1
endwhile
'print'
'printim fig1.png gif x1600 y1200'

