'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_prec.95-cur.cpc.ctl'
'open /export-12/cacsrv1/wd52pp/CFS_vfc/skill/hss_prec.95-cur.cfs.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 HSS of Prec Forecast: CPC vs CFS for All Seasons'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.5;  xlen=8.;  xgap=0.75
ymax0=7.0; ylen=-5;  ygap=-0.65
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.15
  titly=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout scatter'
'set t 1 181'
'set vrange -50 100'
'set vrange2 -50 100'
'set cmark 3'
'd hs1;hs1.2'
'draw ylab CFS'
'draw xlab CPC'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'print'
'printim hss_ts.cfs-vs-cpc.prec.png gif x800 y600'
*'c'
 'set vpage off'
*----------
