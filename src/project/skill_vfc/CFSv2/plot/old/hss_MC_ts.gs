'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/heidke_t2m.95-07.offi.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print Fig_12'
*
*---------------------------string/caption
*
'set string 1 tc 4'
'set strsiz 0.18 0.18'
'draw string 4.25 10.5 HSS of CPC Seasonal SFC Temp Forecast'

*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.;  xlen=6.5;  xgap=0.75
ymax0=9.75; ylen=-3.5;  ygap=-0.8
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+3.25
  titly=ymax+0.25
  lx1=xmin-0.25
  lx2=lx1+0.75
  lxx1=lx2+0.9
  lx3=lx2+2.
  lx4=lx3+0.75
  lxx2=lx4+1.65
  lx5=lx4+2.0
  lx6=lx5+0.6
  lxx3=lx6+0.8
  ly=ymin-0.75
  ly2=ymin-0.65
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
 'set strsiz 0.18 0.18'
if(iframe = 1); 'draw string 'titlx' 'titly' All Data'; endif
if(iframe = 2); 'draw string 'titlx' 'titly' Non-EC Only'; endif
'set vrange -50 100'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
*'set frame off'
'set grads off'
'set grid off'
*'set xlab off'
*'set ylab off'
'set gxout line'
'set t 1 146'
'set cmark 0'
'set cstyle 1'
'set cthick 7'
'set ccolor 1'
'set vrange -50 100'
if(iframe = 1);'d tloop(hs1))'; endif
if(iframe = 2);'d tloop(hs2))'; endif
'set cmark 0'
'set cstyle 1'
'set cthick 4'
'set ccolor 2'
 if(iframe = 1);'d tloop(mhs1+sdv1*1.28))'; endif
*if(iframe = 1);'d tloop(mhs1+sdv1*1.65))'; endif
*if(iframe = 1);'d tloop(rank1)'; endif
'set cmark 0'
'set cstyle 1'
'set cthick 4'
'set ccolor 2'
 if(iframe = 2);'d tloop(mhs2+sdv2*1.28))'; endif
*if(iframe = 2);'d tloop(mhs2+sdv2*1.65))'; endif
*if(iframe = 1);'d tloop(rank2)'; endif
'draw ylab HSS'
*----------
  iframe=iframe+1
endwhile
*----------
'set line 1 1 8'
'draw line 'lx1' 'ly' 'lx2' 'ly''
'draw string 'lxx1' 'ly2' Official HSS'
'set line 2 1 8'
'draw line 'lx3' 'ly' 'lx4' 'ly''
'draw string 'lxx2' 'ly2' 90% Significance level'
'print'
 'printim hss_MC_ts.png gif x600 y800'
*'c'
 'set vpage off'
*----------
