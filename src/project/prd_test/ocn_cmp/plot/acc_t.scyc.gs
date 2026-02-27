'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/prd_test/gocn.acc_t.vs.cd_ss.rms.ctl'
'open /cpc/home/wd52pp/data/prd_test/eocn.acc_t.vs.cd_ss.rms.sm.ctl'
'open /cpc/home/wd52pp/data/prd_test/gocn.acc_t.vs.cd_ss.rms.ss.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 COR Spatially Averaged over CONUS for Each Season'
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
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
'set xlabs JFM | FMA | MAM | AMJ | MJJ | JJA | JAS | ASO | SON | OND | NDJ | DJF '
*'set ylab off'
'set vrange 0.0 0.6'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 12'
'set x 1'
'set y 1'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd tloop(aave(acc,x=1,x=36,y=1,y=19))'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
'd tloop(aave(acc15,x=1,x=36,y=1,y=19))'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
'd tloop(aave(acc.3,x=1,x=36,y=1,y=19))'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
'd tloop(aave(ac.2,x=1,x=36,y=1,y=19))'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.13 0.13'
'set string 1 tl 4'
*'draw string 1.8 6.8 Annually Averaged:'
'set string 1 tl 4'
'draw string 2. 6.5 K(ss,cd), avg=.35'
'set string 3 tl 4'
'draw string 2. 6.3 K(ss), avg=.27'
'set string 2 tl 4'
'draw string 2. 6.1 K,  avg=.26'
'set string 4 tl 4'
'draw string 2. 5.9 EOCN, avg=0.30'
'print'
'printim acc_t.scyc.png gif x800 y600'
*'c'
 'set vpage off'
*----------
