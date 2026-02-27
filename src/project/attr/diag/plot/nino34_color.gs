'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/attr/nino34.jan1948-cur.ctl'
*'enable print  sst_nino34.gr'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
*
  'set t 1 12'
  'define clim=ave(sst,t+36,t=756,1yr)'
  'modify clim seasonal'
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
'set t 1 806'
'set axlim -2.5 2.5'
*'set xaxis 1948 2010 1'
'set vrange -2.5 2.5'
'set yaxis -2.5 2.5 1'
'set bargap 0'
'set barbase 0'
'set ccolor 29'
'd maskout(sst-clim,sst-clim)'
'set ccolor 49'
'd maskout(sst-clim,-sst+clim)'
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
*----------
  iframe=iframe+1
endwhile
'printim /cpc/home/wd52pp/data/peng/nino34.48-cur.png gif x800 y600'
'print'
*'c'
 'set vpage off'
*----------
