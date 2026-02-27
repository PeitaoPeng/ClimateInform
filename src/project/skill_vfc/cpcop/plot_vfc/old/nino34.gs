'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/obs/sst/nino34.3mon_mean.jfm95-mjj11.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*
*
c 'set t 1 12'
c 'define clim=ave(sst,t+0,t=181,1yr)'
c 'modify clim seasonal'
clim=0
*
*---------------------------string/caption
'set string 1 tc 4'
'set strsiz 0.18 0.18'
'draw string 5.5 7.5 Nino3.4 SST(C`ao`n)'
'set strsiz 0.15 0.15'
*'draw string 0.65 6.60 C`ao`n'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=0.5;  xlen=10;  xgap=0.0
ymax0=7.25; ylen=-2.5;  ygap=-0.25
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.2
  titly=ymax+0.0
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set gxout bar'
'set t 1 181'
'set axlim -2.5 2.5'
*'set xaxis 1995 2010 2'
'set vrange -2.5 2.5'
'set yaxis -2.5 2.5 1'
'set bargap 0'
'set barbase 0'
'set ccolor 29'
*'d maskout(sst-clim,sst-clim)'
'd maskout(sst,sst)'
'set ccolor 49'
*'d maskout(sst-clim,-sst+clim)'
'd maskout(sst,-sst)'
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
*----------
*if(iframe = 1); 'draw string 'titlx' 'titly' Tropical SST Index'; endif
*
  iframe=iframe+1
*'run /export-6/sgi9/wd52pp/bin/cbarn.gs 1.0 0 5.5 0.75'
endwhile
'printim nino34.png gif x800 y600'
'print'
*'c'
 'set vpage off':1

*----------
