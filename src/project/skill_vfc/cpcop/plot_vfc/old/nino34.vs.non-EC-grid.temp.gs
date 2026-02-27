'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_temp.95-cur.cpc.ctl'
'open /export-12/cacsrv1/wd52pp/obs/sst/nino34.3mon_mean.jfm95-fma10.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.5 CPC Temp Forecast'
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
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set t 1 12'
'define clm=ave(nec,t+0,t=180,1yr)'
'modify clm seasonal'
'set gxout scatter'
'set t 1 181'
*'set vrange 0 120'
'set vrange2 0 2.5'
'd nec-clm;abs(sst.2)'
*'d abs(sst.2)'
*'d nec-clm'
'draw ylab abs(nino34 idx)'
'draw xlab Non-EC grid # (%)(anom)'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'print'
'printim nino34.vs.non-EC-grid.temp.scat.png gif x800 y600'
*'c'
 'set vpage off'
*----------
