'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/sst14-15/sst.had-oi.jan1949-cur.3mon.anom.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/uv.10m.R1.jan1949-cur.3mon.2.5x2.5.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/prate.1979-cur.cmap.3mon.R15.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4. 10.5 Oberved SST and 10m-wind'
*---------------------------set dimsnesion, page size and style
nframe=5
nframe2=5
nframe3=5
xmin0=1.5;  xlen=5.;  xgap=0.2
ymax0=10.35; ylen=-2.;  ygap=0.1
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
  tlx=xmin-0.6
  tly=ymax-1.
  bx=xmax+0.35
  by=ymin+2.95
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define s1=sst(t=780)'
'define s2=sst(t=783)'
'define s3=sst(t=786)'
'define s4=sst(t=789)'
'define s5=sst(t=792)'
'define u1=skip(u.2(t=780),2,2)'
'define u2=skip(u.2(t=783),2,2)'
'define u3=skip(u.2(t=786),2,2)'
'define u4=skip(u.2(t=789),2,2)'
'define u5=skip(u.2(t=792),2,2)'
'define v1=skip(v.2(t=780),2,2)'
'define v2=skip(v.2(t=783),2,2)'
'define v3=skip(v.2(t=786),2,2)'
'define v4=skip(v.2(t=789),2,2)'
'define v5=skip(v.2(t=792),2,2)'
'define p1=p.3(t=420)'
'define p2=p.3(t=423)'
'define p3=p.3(t=426)'
'define p4=p.3(t=429)'
'define p5=p.3(t=432)'
'set t 1'
'set lon 120 290'
'set lat  -25 25'
'set yaxis -25 25'
'set xlab off'
if(iframe = 5); 'set xlab on'; endif
if(iframe > 5); 'set ylab off'; endif
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
 'set gxout shaded'
'set arrlab off'
if(iframe = 5); 'set arrlab on'; endif
 'set clevs    -1.5 -1.2 -0.9 -0.6 -0.3  0.3 0.6 0.9 1.2 1.5'
 'set ccols    49 47 45 43 41 0 21 23 25 27 29'
'd s'%iframe
'set gxout contour'
'set ccolor 1'
'set clevs -4 -3 -2 2 3 4'
*'d p'%iframe
'set ccolor 1' 
'set arrscl  0.5 4' 
'set arrowhead 0.05' 
if (iframe = 5)
'set arrlab on'
endif
if (iframe = 1)
'd maskout(u1,sqrt(u1*u1+v1*v1)-0.5);maskout(v1,sqrt(u1*u1+v1*v1)-0.5)'
endif
if(iframe = 2)
'd maskout(u2,sqrt(u2*u2+v2*v2)-0.5);maskout(v2,sqrt(u2*u2+v2*v2)-0.5)'
endif
if(iframe = 3)
'd maskout(u3,sqrt(u3*u3+v3*v3)-0.5);maskout(v3,sqrt(u3*u3+v3*v3)-0.5)'
endif
if(iframe = 4)
'd maskout(u4,sqrt(u4*u4+v4*v4)-0.5);maskout(v4,sqrt(u4*u4+v4*v4)-0.5)'
endif
if(iframe = 5)
'd maskout(u5,sqrt(u5*u5+v5*v5)-0.5);maskout(v5,sqrt(u5*u5+v5*v5)-0.5)'
endif
'run /cpc/home/wd52pp/bin/dline.gs 120 0 290 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -25 180 25'
'set string 1 tc 5 90'
'set strsiz 0.13 0.13'
if(iframe = 1); 'draw string 'tlx' 'tly'  DJF13/14'; endif
if(iframe = 2); 'draw string 'tlx' 'tly'  MAM14'; endif
if(iframe = 3); 'draw string 'tlx' 'tly'  JJA14'; endif
if(iframe = 4); 'draw string 'tlx' 'tly'  SON14'; endif
if(iframe = 5); 'draw string 'tlx' 'tly'  DJF14/15'; endif
'set string 1 tl 5 0'

if(iframe = 4);'run /cpc/home/wd52pp/bin/cbarn2.gs 1 1 'bx' 'by'';endif
iframe=iframe+1
endwhile
'print'
'printim sst_uv10m_prate.2.png gif x1200 y1600'

