'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/obs/sst/sst.had-oi.jan1949-cur.3mon.anom.ctl'
'open /cpc/home/wd52pp/data/attr/djf14-15/uv.1000mb.R1.jfm1949-cur.3mon.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
*'draw string 5.5 7.5 Regr&Corr of PSI200 to SST PCs jfm1949-jfm2015'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=4
nframe3=4
xmin0=2.5;  xlen=3.5;  xgap=0.2
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
  tly=ymax-1.25
  bx=xmax+0.35
  by=ymin+4.75
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define s1=sst(t=783)'
'define s2=sst(t=786)'
'define s3=sst(t=789)'
'define s4=sst(t=792)'
'define u1=skip(u.2(t=783),2,2)'
'define u2=skip(u.2(t=786),2,2)'
'define u3=skip(u.2(t=789),2,2)'
'define u4=skip(u.2(t=792),2,2)'
'define v1=skip(v.2(t=783),2,2)'
'define v2=skip(v.2(t=786),2,2)'
'define v3=skip(v.2(t=789),2,2)'
'define v4=skip(v.2(t=792),2,2)'
'set t 1'
'set lon 120 290'
'set lat  -30 60'
'set yaxis -30 60'
'set xlab off'
if(iframe = 4); 'set xlab on'; endif
if(iframe > 4); 'set ylab off'; endif
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
 'set gxout shaded'
'set arrlab off'
if(iframe = 4); 'set arrlab on'; endif
* 'set clevs    -0.6 -0.3  0.3 0.6 1.0 1.5 2.0'
 'set clevs    -1.5 -1.2 -0.9 -0.6 -0.3  0.3 0.6 0.9 1.2 1.5'
 'set ccols    49 47 45 43 41 0 21 23 25 27 29'
'd s'%iframe
'set ccolor 1' 
'set arrscl  0.5 6' 
'set arrowhead 0.05' 
if (iframe = 5)
'set arrlab on'
endif
if (iframe = 1)
'd maskout(u1,sqrt(u1*u1+v1*v1)-0.75);maskout(v1,sqrt(u1*u1+v1*v1)-0.75)'
endif
if(iframe = 2)
'd maskout(u2,sqrt(u2*u2+v2*v2)-0.75);maskout(v2,sqrt(u2*u2+v2*v2)-0.75)'
endif
if(iframe = 3)
'd maskout(u3,sqrt(u3*u3+v3*v3)-0.75);maskout(v3,sqrt(u3*u3+v3*v3)-0.75)'
endif
if(iframe = 4)
'd maskout(u4,sqrt(u4*u4+v4*v4)-0.75);maskout(v4,sqrt(u4*u4+v4*v4)-0.75)'
endif
'run /cpc/home/wd52pp/bin/dline.gs 120 0 290 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 60'
'set string 1 tc 5 90'
'set strsiz 0.13 0.13'
if(iframe = 1); 'draw string 'tlx' 'tly'  MAM14'; endif
if(iframe = 2); 'draw string 'tlx' 'tly'  JJA14'; endif
if(iframe = 3); 'draw string 'tlx' 'tly'  SON14'; endif
if(iframe = 4); 'draw string 'tlx' 'tly'  DJF14/15'; endif
'set string 1 tl 5 0'

if(iframe = 4);'run /cpc/home/wd52pp/bin/cbarn2.gs 1 1 'bx' 'by'';endif
iframe=iframe+1
endwhile
'print'
'printim obs.sst.uv.png gif x1200 y1600'

