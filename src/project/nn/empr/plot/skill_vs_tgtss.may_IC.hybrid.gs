'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
nt=8
*'open /cpc/consistency/nn/cfsv2_ww/skill.mlr.3V.SSTem_sst_d20_2_nino34.ss.may_ic.1982-2019.ld1-7.nmod3_3_3.ctl'
*'open /cpc/consistency/nn/cfsv2_ww/skill.ann.3V.SSTem_sst_d20_2_nino34.ss.may_ic.1982-2019.ld1-7.nmod3_3_3.ctl'
'open /cpc/consistency/nn/cfsv2_ww/skill.mlr.3V.SSTem_sst_d20_2_nino34.ss.may_ic.1982-2019.ld1-7.nmod5.eeof.ctl'
'open /cpc/consistency/nn/cfsv2_ww/skill.ann.3V.SSTem_sst_d20_2_nino34.ss.may_ic.1982-2019.ld1-7.nmod5.eeof.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print Fig1.meta'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
'draw string 5.5 7.75 Skill of Nino3.4 Fcsts from May_IC'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=3.25;  xlen=4.5;  xgap=0.75
ymax0=7.2; ylen=-2.5;  ygap=-1.
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
  ty=ymax+0.25
  lx1=xmin+0.3
  lx2=xmin+2.5
  ly11=ymin+1.0
  ly12=ymin+0.8
  ly13=ymin+0.6
  ly14=ymin+0.4
*
  ly21=ymin+2.2
  ly22=ymin+2.0
  ly23=ymin+1.8
  ly24=ymin+1.6
*
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
'set xlabs  | JJA | JAS | ASO | SON | OND | NDJ | DJF |'
 'set string 1 tc 4'
'draw string 'xlabx' 'xlaby' Target Season'
if(iframe = 1);'set vrange 0.5 1';endif
if(iframe = 2);'set vrange 0.25 0.75';endif
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 0 'nt''
'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
if(iframe = 1); 'd ave(acm,e=1,e=12)'; endif
if(iframe = 2); 'd ave(rmsm,e=1,e=12)'; endif
'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
if(iframe = 1); 'd ave(aca,e=1,e=12)'; endif
if(iframe = 2); 'd ave(rmsa,e=1,e=12)'; endif
'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
if(iframe = 1); 'd ave(aca.2,e=1,e=12)'; endif
if(iframe = 2); 'd ave(rmsa.2,e=1,e=12)'; endif
*----------
'set string 1 tl 4'
if(iframe = 1);'draw string 'lx1' 'ly11' CFSv2'; endif
'set string 2 tl 4'
if(iframe = 1);'draw string 'lx1' 'ly12' MLR(SSTm,SST,D20)'; endif
'set string 3 tl 4'
if(iframe = 1);'draw string 'lx1' 'ly13' ANN(SSTm,SST,D20)'; endif

'set string 1 tl 4'
if(iframe = 2);'draw string 'lx1' 'ly21' CFSv2'; endif
'set string 2 tl 4'
if(iframe = 2);'draw string 'lx1' 'ly22' MLR(SSTm,SST,D20)'; endif
'set string 3 tl 4'
if(iframe = 2);'draw string 'lx1' 'ly23' ANN(SSTm,SST,D20)'; endif

'set string 1 tl 5'
if(iframe = 1); 'draw string 'tx' 'ty' a) AC'; endif
if(iframe = 2); 'draw string 'tx' 'ty' b) RMS Error'; endif
iframe=iframe+1
endwhile
'print'
'printim skill_vs_tgtss.may_ic.hybrid.png gif x800 y600'
*'c'
 'set vpage off'
*----------
