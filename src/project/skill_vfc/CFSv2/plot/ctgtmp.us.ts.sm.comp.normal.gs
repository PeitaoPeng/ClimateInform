'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/ctgtemp.jfm1995-djf2009.prd.vs.obs.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 Grid #(%) with Below Normal Seasonal Temp (13mon mean)'
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
'set x 1'
'set y 1'
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set vrange 0 100'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 180'
 'define obsn=100-100*(obsb+obsa)/232'
 'define cv1n=100-100*(v1b+v1a)/232'
 'define cv2n=100-100*(v2b+v2a)/232'
 'define opn=100-100*(opb+opa)/232'
'set t 7 174'
'define obs=ave(obsn,t-6,t+6)'
'define cv1=ave(cv1n,t-6,t+6)'
'define cv2=ave(cv2n,t-6,t+6)'
'define op=ave(opn,t-6,t+6)'
'set t 1 180'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd  cv1'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
'd cv2'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
'd op'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 5'
'd obs'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.13 0.13'
'set string 1 tl 4'
'draw string 2. 6.8 CFSv1'
'set string 2 tl 4'
'draw string 2. 6.6 CFSv2'
'set string 4 tl 4'
'draw string 2. 6.4 CPC'
'set string 5 tl 4'
'draw string 2. 6.2 OBS'
'print'
'printim ctgtmp_us.normal.ts.sm.comp.png gif x800 y600'
*'c'
 'set vpage off'
