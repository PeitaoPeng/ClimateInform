'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.ss.gs'
*
nt=8
tool=ann
*'open /cpc/consistency/nn/cfsv2_ww/skill.ann.tgtss.3V.SSTem_sst_d20_2_nino34.ld1-7.nmod3_3_3.ctl'
'open /cpc/consistency/nn/cfsv2_ww/skill.ann.tgtss.3V.SSTem_sst_d20_2_nino34.ld1-7.nmod5.eeof.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print Fig1.meta'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.14 0.14'
'draw string 5.5 8. Skill of Nino34: CFSv2 vs ANN(CFSv2_SST, OBS_SST_D20)'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=1.25;  xlen=4.;  xgap=0.75
ymax0=7.3; ylen=-2.5;  ygap=-1.
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tx=xmin
  ty=ymax+0.22
  xlabx=xmin+2.25
  xlaby=ymin-0.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set x 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'

'set ylabs  | JFM | FMA | MAM | AMJ | MJJ | JJA | JAS | ASO | SON | OND | NDJ | DJF |'
'set xlabs  | 1 | 2 | 3 | 4 | 5 | 6 | 7 |'
 'set string 1 tc 4'
'draw string 'xlabx' 'xlaby' Lead Time (month)'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 0 'nt''
*if(iframe >= 2); 'set t 0 8'; endif
'set e 0 13'
'set gxout grfill'
'set mpdset mres'
*'set clevs   0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95'
*'set ccols   35 34 33 32 31 21 22 23 24 25 26 27 29 81 83'
'set clevs   0.3 0.4 0.5 0.6 0.7 0.8 0.9'
'set ccols   35 33 31 21 23 25 27 29'

if(iframe = 1); 'd acn'; endif
if(iframe = 2); 'd rmsn'; endif
if(iframe = 3); 'd acm'; endif
if(iframe = 4); 'd rmsm'; endif

'set string 1 tl 5'
if(iframe = 1); 'draw string 'tx' 'ty' a) AC of ANN'; endif
if(iframe = 3); 'draw string 'tx' 'ty' b) AC of CFSv2'; endif
if(iframe = 2); 'draw string 'tx' 'ty' c) RMSE of ANN'; endif
if(iframe = 4); 'draw string 'tx' 'ty' d) RMSE of CFSv2'; endif

iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.9 0 5.5 0.5'
endwhile
'print'
'printim skill.tgtss_vs_lead.ann.hybrid.png gif x800 y600'
*'c'
 'set vpage off'
*----------
