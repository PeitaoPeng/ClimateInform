'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/CFS_vfc/skill/rpss_prec.95-cur.cfs.ctl'
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/rpss_prec.95-cur.cfsv2.ctl'
'open /cpc/home/wd52pp/data/cpc_vfc/skill/rpss_prec.95-cur.cpc.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print rpss_t2m.cfs.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 RPSS of Seasonal Temp Forecast'
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
'set vrange -0.5 0.5'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 180'
'set cmark 0'
'set cstyle 1'
'set cthick 7'
'set ccolor 1'
*'d tloop(rpss)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
'set t 6 175'
'define ts=ave(rpss,t-5,t+5)'
'define ts2=ave(rpss.2,t-5,t+5)'
'define ts3=ave(rpss.3,t-5,t+5)'
'set t 1 180'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd tloop(ts)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
'd tloop(ts2)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
'd tloop(ts3)'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.13 0.13'
'set string 1 tl 4'
'draw string 1.6 6.9 CFSv1 mean=-0.047'
'set string 2 tl 4'
'draw string 1.6 6.7 CFSv2 mean=-0.013'
'set string 4 tl 4'
'draw string 1.6 6.5 CPC   mean= 0.003'
'print'
'printim rpss_prec.ts.cfsv2.comp.png gif x800 y600'
*'c'
 'set vpage off'
*----------
