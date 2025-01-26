'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/sst14-15/eof.sst.had-oi.dec1949-dec2014.djf.tnp.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/corr.sstpc.vs.sz.1949-cur.djf.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/corr.sstpc.vs.prate.1979-cur.djf.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
*'draw string 5.5 7.5 Regr&Corr of PSI200 to SST PCs jfm1949-jfm2015'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=3
nframe3=6
xmin0=1.25;  xlen=4.5;  xgap=0.1
ymax0=7.5; ylen=-2.25;  ygap=0.4
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
  tlx=xmin-0.5
  tly=ymax-1.125
  bx=xmin+2.25
  by=ymin-0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define s1=-1.01*reg(t=1)'
'define s2=-0.46*reg(t=2)'
'define s3=-2.91*reg(t=3)'
'define s4=-1.01*sreg.2(t=1)'
'define s5=-0.46*sreg.2(t=2)'
'define s6=-2.91*sreg.2(t=3)'
'define p4=-1.01*preg.3(t=1)'
'define p5=-0.46*preg.3(t=2)'
'define p6=-2.91*preg.3(t=3)'
*
'define cs1=s3'
'define cs2=s3+s1'
'define cs3=s3+s1+s2'
'define cs4=s6'
'define cs5=s6+s4'
'define cs6=s6+s4+s5'
'define cp4=p6'
'define cp5=p6+p4'
'define cp6=p6+p4+p5'

'set t 1'
'set lon 0 360'
'set lat  -30 80'
'set yaxis -30 80 20'
'set xlab off'
if(iframe = 3); 'set xlab on'; endif
if(iframe = 6); 'set xlab on'; endif
if(iframe > 3); 'set ylab off'; endif
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
if(iframe < 4);
 'set gxout shaded'
 'set clevs   -1.5 -1.2 -0.8 -0.6 -0.3  0.3 0.6 0.9 1.2 1.5'
 'set ccols   49 47 45 43 41 0 21 23 25 27 29'
'd cs'%iframe
endif
if(iframe > 3);
'set gxout shaded'
'set clevs   -4 -3 -2 -1 -0.5 0.5 1 2 3 4'
'set ccols   79 77 75 73 72 0 32 33 35 37 39'
'd cp'%iframe
'set gxout contour'
'set ccolor 4'
'set cint 2'
'd 0.000001*cs'%iframe
endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 80'
'set string 1 tc 6 90'
'set strsiz 0.14 0.14'
*if(iframe = 1); 'draw string 'tlx' 'tly'  PC1(40.6%)'; endif
*if(iframe = 2); 'draw string 'tlx' 'tly'  PC2(9.8%)'; endif
*if(iframe = 3); 'draw string 'tlx' 'tly'  PC3(7.6%)'; endif
if(iframe = 1); 'draw string 'tlx' 'tly'  PC3'; endif
if(iframe = 2); 'draw string 'tlx' 'tly'  PC1+3'; endif
if(iframe = 3); 'draw string 'tlx' 'tly'  PC1+2+3'; endif
'set string 1 tl 5 0'

if(iframe = 3);'run /cpc/home/wd52pp/bin/cbarn2.gs 0.5 0 'bx' 'by'';endif
if(iframe = 6);'run /cpc/home/wd52pp/bin/cbarn2.gs 0.5 0 'bx' 'by'';endif
iframe=iframe+1
endwhile
'print'
'printim fig4.png gif x1600 y1200'

