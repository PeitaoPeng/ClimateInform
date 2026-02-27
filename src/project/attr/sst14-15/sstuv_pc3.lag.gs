'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/sst14-15/corr.sstpc.vs.sst.lag-lead.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/corr.sstpc.vs.uv1000mb.lag-lead.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
*'draw string 5.5 7.5 Regr&Corr of PSI200 to SST PCs jfm1949-jfm2015'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=4
nframe3=4
xmin0=2.5;  xlen=3.5;  xgap=0.1
ymax0=10.5; ylen=-2.5;  ygap=0.2
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
if(iframe > 4);tlx=xmax+0.25;endif
  tly=ymax-1.125
  bx=xmax+0.4
  by=ymin+4.75
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define s1=-reg3(t=5)'
'define s2=-reg3(t=6)'
'define s3=-reg3(t=7)'
'define s4=-reg3(t=8)'
'define u1=skip(-ureg3.2(t=5),2,2)'
'define u2=skip(-ureg3.2(t=6),2,2)'
'define u3=skip(-ureg3.2(t=7),2,2)'
'define u4=skip(-ureg3.2(t=8),2,2)'
'define v1=skip(-vreg3.2(t=5),2,2)'
'define v2=skip(-vreg3.2(t=6),2,2)'
'define v3=skip(-vreg3.2(t=7),2,2)'
'define v4=skip(-vreg3.2(t=8),2,2)'
'set t 1'
'set lon 120 290'
'set lat  -30 60'
'set yaxis -30 60 20'
'set xlab off'
if(iframe = 4); 'set xlab on'; endif
if(iframe = 8); 'set xlab on'; endif
*if(iframe > 4); 'set ylab off'; endif
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
 'set gxout shaded'
 'set clevs   -0.5 -0.4 -0.3 -0.2 -0.1  0.1 0.2 0.3 0.4 0.5'
 'set ccols    49 47 45 43 41 0 21 23 25 27 29'
'd s'%iframe
'set ccolor 1'
'set arrscl  0.8 2'
'set arrowhead 0.05'
'set arrlab off'
if(iframe = 4);'set arrlab on';endif
if(iframe = 1)
'd maskout(u1,sqrt(u1*u1+v1*v1)-0.15);maskout(v1,sqrt(u1*u1+v1*v1)-0.15)'
endif
if(iframe = 2)
'd maskout(u2,sqrt(u2*u2+v2*v2)-0.15);maskout(v2,sqrt(u2*u2+v2*v2)-0.15)'
endif
if(iframe = 3)
'd maskout(u3,sqrt(u3*u3+v3*v3)-0.15);maskout(v3,sqrt(u3*u3+v3*v3)-0.15)'
endif
if(iframe = 4)
'd maskout(u4,sqrt(u4*u4+v4*v4)-0.15);maskout(v4,sqrt(u4*u4+v4*v4)-0.15)'
endif
'run /cpc/home/wd52pp/bin/dline.gs 120 0 290 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 60'
'set string 1 tc 5 90'
if(iframe > 4);'set string 1 tc 5 270';endif
'set strsiz 0.13 0.13'
if(iframe = 1); 'draw string 'tlx' 'tly'  Lag 1(MAM)'; endif
if(iframe = 2); 'draw string 'tlx' 'tly'  Lag 2(JJA)'; endif
if(iframe = 3); 'draw string 'tlx' 'tly'  Lag 3(SON)'; endif
if(iframe = 4); 'draw string 'tlx' 'tly'  Lag 4(DJF)'; endif
'set string 1 tl 5 0'

if(iframe = 4);'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 1 'bx' 'by'';endif
iframe=iframe+1
endwhile
'print'
'printim sstuv_lag_pc3.png x1200 y1600'

