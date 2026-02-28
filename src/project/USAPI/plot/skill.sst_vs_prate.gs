'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
island=Kwajalein
*
'open /cpc/consistency/USAPI/skill/skill.mlr.eof.2V.NMME_tmpsfc_2_'island'_prec.ss.1982-2018.ld-1.ctl'
'open /cpc/consistency/USAPI/skill/skill.mlr.eof.1V.NMME_prate_2_'island'_prec.ss.1982-2018.ld-1.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.cons.gr'
*---------------------------string/caption
'set string 1 tc 4'
'set strsiz 0.18 0.18'
'draw string 5.75 7.5 MLR Hindcast Skill (HSS) of Prate of 'island' (1982-2018)'
'draw string 5.75 7.2 Predictor: SST vs Prate'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.;  xlen=9.5;  xgap=0.75
ymax0=6.8; ylen=-5;  ygap=-0.65
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
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set xlabs JFM | FMA | MAM | AMJ | MJJ | JJA | JAS | ASO | SON | OND | NDJ | DJF '
'set vrange -30 80'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 12'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd tloop(hss))'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
'd tloop(hss.2)'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.14 0.14'
'set string 1 tl 5'
'draw string 3.5 6.5 MLR_SST   ave=15.9'
'set string 2 tl 5'
'draw string 3.5 6.2 MLR_Prate ave=14.2'
'print'
'printim skill.sst_vs_prate.'island'.png gif x800 y600'
*'c'
 'set vpage off'
*----------
