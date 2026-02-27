* hss map
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print rlb_hsg.comp.6p.2.mega'
*
*---------------------------string/caption
'set string 1 tc 6 0'
'set strsiz 0.13 0.13'
*'draw string 4.25 10.5 Rliability of Seasonal Forecast'
 'draw string 2.85 10.8 Temp'
 'draw string 6.5 10.8 Prec'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=3
nframe3=6
xmin0=0.5;  xlen=4.;  xgap=-0.4
ymax0=10.8; ylen=-3.6;  ygap=0.2
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
  titlx=xmin-0.35
  titly=ymax-0.85
  lsx=xmin
  lsy=ymin
  lex=xmax
  ley=ymax
*
  dx0=0.85
  dx=1.20
  dy0=0.25
  dy=0.5
  w1x1=dx0+xmin
  w1x2=dx0+xmin+dx
  w1y1=ymax-dy0-dy
  w1y2=ymax-dy0
*
  dx2=0.14
  w2x1=xmax-dx2-dx
  w2x2=xmax-dx2
  dy2=0.38
  w2y1=ymin+dy2
  w2y2=ymin+dy+dy2
if(iframe=1); 
'open /cpc/home/wd52pp/data/CFS_vfc/skill/rlb_hsg.temp.95-cur.ctl'
endif
if(iframe=4); 
'open /cpc/home/wd52pp/data/CFS_vfc/skill/rlb_hsg.prec.95-cur.ctl'
endif
if(iframe=2); 
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/rlb_hsg.temp.95-cur.ctl'
endif
if(iframe=5); 
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/rlb_hsg.prec.95-cur.ctl'
endif
if(iframe=3); 
'open /cpc/home/wd52pp/data/cpc_vfc/skill/rlb_hsg.temp.95-cur.cpc.ctl'
endif
if(iframe=6); 
'open /cpc/home/wd52pp/data/cpc_vfc/skill/rlb_hsg.prec.95-cur.cpc.ctl'
endif
*
  'set vpage 'xmin' 'xmax' 'ymin' 'ymax''
* 'set parea 'xmin' 'xmax' 'ymin' 'ymax''
*
'set line 1 1 3'
'draw line 2. 0.75 8.0 6.92'
'set gxout line'
'set grads off'
'set grid off'
'set ylab on'
'set xlab on'
*'set vrange 0 1'
'set vrange 0.025 0.975'
'set yaxis 0.05 0.95 0.1'
'set xlopts 1 4 0.15'
'set ylopts 1 4 0.15'
*'set xaxis 0.1 1. 0.1'
'set xaxis 0.05 0.95 0.1'
if(iframe=3 | iframe=6); 'set xaxis 0.025 0.975 0.05'; endif
'set cthick 7'
'set ccolor 2'
if(iframe=4 | iframe=5 | iframe=6);
'set ccolor 3'
endif
'set cstyle 1'
'set cmark 3'
'd hoa'
'set ccolor 2'
if(iframe=4 | iframe=5 | iframe=6);
'set ccolor 3'
endif
'set cstyle 2'
'set cmark 0'
'd rga'
'set ccolor 4'
if(iframe=4 | iframe=5 | iframe=6);
'set ccolor 8'
endif
'set cstyle 1'
'set cmark 3'
'd hob'
'set cstyle 2'
'set cmark 0'
'set ccolor 4'
if(iframe=4 | iframe=5 | iframe=6);
'set ccolor 8'
endif
'd rgb'
'draw xlab Forecast probability'
'draw ylab Observed relative frequency'
*'draw title CFSv2 seasonal Temp Forecast'
'set string 1 tl 4'
'set strsiz 0.16 0.16'
'draw string 2.1 5.6 Upper Tercile:'
'set string 2 tl 4'
'set strsiz 0.14 0.14'
if(iframe=1);
'draw string 2.05 5.2 mean forecast probability=0.34'
'draw string 2.05 5.0 mean observed relative freq=0.47'
endif
if(iframe=4);
'set string 3 tl 4'
'draw string 2.05 5.2 mean forecast probability=0.31'
'draw string 2.05 5.0 mean observed relative freq=0.39'
endif
if(iframe=2);
'draw string 2.05 5.2 mean forecast probability=0.39'
'draw string 2.05 5.0 mean observed relative freq=0.47'
endif
if(iframe=5);
'set string 3 tl 4'
'draw string 2.05 5.2 mean forecast probability=0.31'
'draw string 2.05 5.0 mean observed relative freq=0.39'
endif
if(iframe=3);
'draw string 2.05 5.2 mean forecast probability=0.36'
'draw string 2.05 5.0 mean observed relative freq=0.47'
endif
if(iframe=6);
'set string 3 tl 4'
'draw string 2.05 5.2 mean forecast probability=0.33'
'draw string 2.05 5.0 mean observed relative freq=0.39'
endif
'set string 1 tl 4'
'set strsiz 0.16 0.16'
'draw string 5.05 2.2 Lower Tercile:'
'set string 4 tl 4'
'set strsiz 0.14 0.14'
if(iframe=1);
'draw string 2.05 1.7 mean forecast probability=0.31'
'draw string 2.05 1.5 mean observed relative freq=0.23'
endif
if(iframe=4);
'set string 8 tl 4'
'draw string 2.05 1.7 mean forecast probability=0.32'
'draw string 2.05 1.5 mean observed relative freq=0.31'
endif
if(iframe=2);
'draw string 2.05 1.7 mean forecast probability=0.24'
'draw string 2.05 1.5 mean observed relative freq=0.23'
endif
if(iframe=5);
'set string 8 tl 4'
'draw string 2.05 1.7 mean forecast probability=0.32'
'draw string 2.05 1.5 mean observed relative freq=0.31'
endif
if(iframe=3);
'draw string 2.05 1.7 mean forecast probability=0.29'
'draw string 2.05 1.5 mean observed relative freq=0.23'
endif
if(iframe=6);
'set string 8 tl 4'
'draw string 2.05 1.7 mean forecast probability=0.33'
'draw string 2.05 1.5 mean observed relative freq=0.30'
endif
*
'set string 1 tl 4'
'set strsiz 0.10 0.10'
*'draw string 2.85 5.85 Forecast probability'
*'set string 1 tl 4'
*'draw string 1 6.5 ForecatForecast probability'
'set line 2 1 6'
if(iframe=4 | iframe=5 | iframe=6);
'set line 3 1 6'
endif
'draw line 3.9 5.5 4.8 5.5'
'set line 4 1 6'
if(iframe=4 | iframe=5 | iframe=6);
'set line 8 1 6'
endif
'draw line 6.85 2.1 7.75 2.1'
*
'set vpage 'w1x1' 'w1x2' 'w1y1' 'w1y2''
'set grads off'
*'set xlab off'
*'set ylab off'
*'set t 'iday''
'set vrange 0 0.8 0.1'
'set xlopts 1 5 0.4'
'set ylopts 1 5 0.4'
'set yaxis 0.0 0.8 0.2'
'set xaxis 0.05 0.95 0.1'
'set gxout bar'
'set bargap 30'
'set ccolor 2'
if(iframe=4 | iframe=5 | iframe=6);
'set ccolor 3'
endif
'd foa'
'set vpage 'w2x1' 'w2x2' 'w2y1' 'w2y2''
'set grads off'
*'set ylab off'
*'set xlab off'
'set vrange 0 0.8 0.1'
'set yaxis 0.0 0.8 0.2'
'set xaxis 0.025 0.975 0.1'
'set gxout bar'
'set bargap 30'
'set ccolor 4'
if(iframe=4 | iframe=5 | iframe=6);
'set ccolor 8'
endif
'd fob'
*----------
* if(iframe = 1); 'draw string 'titlx' 'titly' Temp'; endif
* if(iframe = 2); 'draw string 'titlx' 'titly' Prec'; endif
*
 'close 1'
  iframe=iframe+1
 'set vpage off'
endwhile
'set string 1 tl 6 90'
'set strsiz 0.15 0.15'
'draw string 0.6 8.4 CFSv1'
'draw string 0.6 5. CFSv2'
'draw string 0.6 1.6 CPC'
 'set string 1 tc 5 0'
*'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 3.1'
'print'
'printim rlb_hsg.comp.6p.2.png gif x700 y800'
*'c'
 'set vpage off'
*----------
