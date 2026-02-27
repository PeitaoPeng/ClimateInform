'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/adam/real_wk34_sat_prd.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.map.cpc.gr'
*
*---------------------------string/caption
'define hds1=hss'
'define hds2=hss.2'
*
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.25 HSS of Week3-4 SAT Hindcast'
'draw string 4.25 10.0  for Mar-Apr over 1979-2015'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.;  xlen=6.5;  xgap=0.75
ymax0=9.35; ylen=-3.5;  ygap=-0.85
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+3
  titly=ymax+0.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
if(iframe = 1)
'set lat -90 90'
'set lon 0 360'
endif
if(iframe = 2)
'set lat 10 75'
'set lon 190 300'
endif
*'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
'set gxout shaded'
*'set gxout grfill'
'set mpdset mres'
'set clevs   0 10 20 30 40 50 60'
'set ccols   0 21 23 24 25 26 27 29'
*'set xlab off'
*'set ylab off'
*'set yaxis -80 80 20'
'd hss'
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
if(iframe = 1)
'run /cpc/home/wd52pp/bin/dline.gs 180 -90 180 90'
endif
'set gxout shaded'
*'set csmooth on'
*'set cint 0.5'
*'set ccolor 1'
* if(iframe = 6); 'set xlab on'; endif
* if(iframe = 12); 'set xlab on'; endif
*'set clopts -1 3 0.05'
*'set cthick 4'
*'d hds'%iframe
 'set string 1 tc 4'
 'set strsiz 0.16 0.16'
*----------
*if(iframe = 1); 'draw string 'titlx' 'titly' Global'; endif
*if(iframe = 2); 'draw string 'titlx' 'titly' North America'; endif
*
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.9 0 4.25 0.8'
endwhile
'print'
'printim hss_sat.history.map.png gif x1200 y1600'
*'c'
* 'set vpage off'
*----------
