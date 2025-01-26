'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
island=Yap
* island: Chuuk, Guam, Kwajalein, PagoPago, Pohnpei, Yap
*
'open /cpc/consistency/USAPI/skill/skill.NMME.'island'.prate.ss.1982-2018.ld-1.ctl'
'open /cpc/consistency/USAPI/skill/skill.ann.eof.2V.NMME_tmpsfc_2_'island'_prec.ss.1982-2018.ld-1.ctl'
'open /cpc/consistency/USAPI/skill/skill.mlr.eof.2V.NMME_tmpsfc_2_'island'_prec.ss.1982-2018.ld-1.ctl'
'open /cpc/consistency/USAPI/skill/skill.pls.2V.NMME_tmpsfc_2_'island'_prec.ss.1982-2018.ld-1.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.cons.gr'
*---------------------------string/caption
'set string 1 tc 4'
'set strsiz 0.18 0.18'
'draw string 5.75 7.3 Seasonal Hindcast Skill (HSS) of Prate of 'island' (1982-2018)'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.;  xlen=9.5;  xgap=0.75
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
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
'd tloop(hss.3)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
'd tloop(hss.4)'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.14 0.14'
'set string 1 tl 5'
*'draw string 3.5 6.7 NMME ave=20.9'
*'draw string 3.5 6.7 NMME ave=17.9'
*'draw string 3.5 6.7 NMME ave=20.3'
*'draw string 3.5 6.7 NMME ave=7.8'
*'draw string 3.5 6.7 NMME ave=17.6'
'draw string 3.5 6.7 NMME ave=21.6'
'set string 2 tl 5'
*'draw string 3.5 6.4 ANN  ave=7.4'
*'draw string 3.5 6.4 ANN  ave=12.2'
*'draw string 3.5 6.4 ANN  ave=15.9'
*'draw string 3.5 6.4 ANN  ave=6.8'
*'draw string 3.5 6.4 ANN  ave=13.5'
'draw string 3.5 6.4 ANN  ave=14.9'
'set string 3 tl 5'
*'draw string 3.5 6.1 MLR  ave=9.5'
*'draw string 3.5 6.1 MLR  ave=12.2'
*'draw string 3.5 6.1 MLR  ave=16.9'
*'draw string 3.5 6.1 MLR  ave=9.8'
*'draw string 3.5 6.1 MLR  ave=15.9'
'draw string 3.5 6.1 MLR  ave=15.9'
'set string 4 tl 5'
*'draw string 3.5 5.8 PLSR ave=13.9'
*'draw string 3.5 5.8 PLSR ave=11.5'
*'draw string 3.5 5.8 PLSR ave=14.9'
*'draw string 3.5 5.8 PLSR ave=4.1'
*'draw string 3.5 5.8 PLSR ave=17.9'
'draw string 3.5 5.8 PLSR ave=20.3'
'print'
'printim skill_compare.'island'.png gif x800 y600'
*'c'
 'set vpage off'
*----------
