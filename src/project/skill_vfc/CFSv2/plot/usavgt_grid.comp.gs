'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print usavgt_grid.comp.2p.mega'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.16 0.16'
*'draw string 4.25 9.75 CONUS Temp'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.5;  xlen=6.;  xgap=0.
ymax0=9.; ylen=-3;  ygap=-0.75
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
  titly=ymax+0.25
  titlx2=xmin-0.6
  titly=ymax+0.25
  titly2=ymax-1.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
if (iframe = 1);
'open /cpc/home/wd52pp/data/CFS_vfc/0data/temp.jfm1995-jfm2011.cfs.esm_anom.us.ctl'
'open /cpc/home/wd52pp/data/CFSv2_vfc/0data/temp.jfm95-djf09.cfsv2.esm_anom.us.ctl'
'open /cpc/home/wd52pp/data/prd_skill/temp.jfm1995-djf2009.anom.2x2.ctl'
*
'set x 1'
'set y 1'
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set vrange -0.5 2'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 7 174'
'define obs=ave(aave(t.3,x=1,x=36,y=1,y=19),t-6,t+6)'
'define cv1=ave(aave(t,x=1,x=36,y=1,y=19),t-6,t+6)'
'define cv2=ave(aave(t.2,x=1,x=36,y=1,y=19),t-6,t+6)'
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
'd obs'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
'close 3'
'close 2'
'close 1'
endif
*
if (iframe = 2);
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/ctgtemp.jfm1995-djf2009.prd.vs.obs.ctl'
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
'set t 7 174'
'define obs=ave(100*obsa/232,t-6,t+6)'
'define cv1=ave(100*v1a/232,t-6,t+6)'
'define cv2=ave(100*v2a/232,t-6,t+6)'
'define op=ave(100*opa/232,t-6,t+6)'
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
'set ccolor 5'
'd op'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
'd obs'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
'set strsiz 0.11 0.11'
'set string 1 tl 4'
'draw string 3. 9.18 US Averaged Temp (13mon mean)'
'draw string 1.75 5.4 Number of Grid (%) with Above Normal Temp (13mon mean)'
'set strsiz 0.13 0.13'
'set string 1 tl 5'
'draw string 2. 8.6 CFSv1'
'set string 2 tl 5'
'draw string 2. 8.4 CFSv2'
'set string 4 tl 5'
'draw string 2. 8.2 OBS'
'set string 1 tl 5'
'draw string 2. 5.0 CFSv1'
'set string 2 tl 5'
'draw string 2. 4.8 CFSv2'
'set string 5 tl 5'
'draw string 2. 4.6 CPC'
'set string 4 tl 5'
'draw string 2. 4.4 OBS'
endif
iframe=iframe+1
endwhile
'print'
'printim usavgt_grid.comp.2p.png gif x600 y800'
*'c'
'set vpage off'
*----------
