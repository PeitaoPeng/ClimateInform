'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
icmon=may
nino=n1_4
nt=38
'open /cpc/home/wd52pp/data/obs/sst/nino34.oi.1982-2020.djf.ctl'
'open /cpc/home/wd52pp/data/nn/cfsv2/CFSv2.nino34.'icmon'_ic.1982-2020.djf.2c.ctl'
'open /cpc/home/wd52pp/data/nn/cfsv2/mlp.djf.grdsst_2_n34.'icmon'_ic.whole.1c.ctl'
*'open /cpc/home/wd52pp/data/nn/cfsv2/mlr.grdsst_2_n34.may_ic.1982-2020.djf.whole.1c.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.cons.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 NINO3.4 Index: DJF 1983-2020'
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
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set vrange -3 4'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 'nt''
'set cmark 2'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd o'
'set cmark 2'
'set cstyle 1'
'set cthick 5'
'set ccolor 4'
'd f.2'
'set cmark 2'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
'd p.3'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
 'define zero=0.'
 'set cstyle 1'
 'set cthick 5'
 'set cmark 0'
 'set ccolor 1'
 'd zero'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.13 0.13'
'set string 1 tl 4'
'draw string 4.5 6.9 OBS(OI)'
'set string 4 tl 4'
'draw string 4.5 6.6 CFSv2(May_IC, 2_Clim): AC=0.86, RMSE=0.61'
'set string 2 tl 4'
'draw string 4.5 6.3 ANN(1_Clim Input) AC=0.90, RMSE=0.54'
'print'
'printim cfsv2.comp.ts.grd.djf.1c.png gif x800 y600'
*'c'
 'set vpage off'
*----------
