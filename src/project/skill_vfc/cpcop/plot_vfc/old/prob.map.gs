'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/0data/temp01_forecast_above.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/0data/temp01_forecast_below.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
'enable print meta.fig16'
*
*---------------------------string/caption
 'define temp1=t(t=49)'
 'define temp2=t(t=60)'
 'define temp3=t(t=96)'
 'define temp4=t(t=96)'
*
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
'draw string 4.25 10.55 "Above Normal" Prob Fcst with Max Value > 70%'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.5;  xlen=5.5;  xgap=0.5
ymax0=10; ylen=-2.75;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.75
  titly=ymax+0.15
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set x 1 36'
'set y 3 17'
'set xlab off'
'set ylab off'
*'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
*'set gxout shaded'
'set gxout grfill'
'set mpdset mres'
'set clevs    30 40 50 60 70'
'set ccols    0 21 23 25 27 29'
*'set xlab off'
*'set ylab off'
'set xlabs 130W | 120W | 110W | 100W | 90W | 80W | 70W | 60W'
*'set yaxis -80 80 20'
'd temp'%iframe
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout contour'
*'set csmooth on'
*'set cint 0.5'
*'set ccolor 1'
* if(iframe = 6); 'set xlab on'; endif
* if(iframe = 12); 'set xlab on'; endif
*'set clopts -1 3 0.05'
*'set cthick 4'
*'d hds'%iframe
 'set string 1 tc 4'
 'set strsiz 0.12 0.12'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' JFM 1999'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' DJF 1999'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' DJF 2002'; endif
*
  iframe=iframe+1
'run /export/hobbes/wd52pp/bin/cbarn2.gs 1 1 7.5 5.4'
endwhile
'print'
'printim prob_fcst.png gif x600 y800'
*'c'
* 'set vpage off'
*----------
