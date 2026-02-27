'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/wk34/ac_1d_ca_olr_wkly.winter.mm10.ctl'
'open /cpc/home/wd52pp/data/wk34/nino34_wkly.winter.ctl'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
'draw string 4.25 10. NINO3.4 SST in IC-weeks of CA WK34 Forecast'
'draw string 4.25 9.75 DJFM 1982/83-2012/13'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.0;  xlen=6.5;  xgap=0.6
ymax0=9.5; ylen=-7.0;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.5
  titly=ymax+0.2
  labx=xmin+3.25
  laby=ymin-0.25
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set mproj scaled'
*'set xlab off'
'set xaxis 1 17 1'
'set grads off'
*'set grid off'
'set gxout shaded'
*'set clevs   -0.2 -0.1 0.10 0.2 0.3 0.4 0.5 0.6 0.7'
*'set ccols   43 41 0 21 23 25 27 29 64 66'
'set z 6'
'set t 1 34'
*'d ac'
'set clevs   -2 -1.5 -1. -0.5 0.5 1 1.5 2'
'set ccols   48 46 44 42 0 22 24 26 28'
'd t.2'
*
'draw string 'labx' 'laby' IC-weeks starts from Mid-Nov'
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 4.25 1.75'
endwhile
'printim nino34.png gif x600 y800'
'print'
*
*'c'
'set vpage off'
