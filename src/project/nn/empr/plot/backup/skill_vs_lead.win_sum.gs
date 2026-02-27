'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
nt=13
tool=ann
'open /cpc/home/wd52pp/data/nn/empr/skill.ann.2V.sst_d20_2_nino34.nmod3_3.neurons25.ctl'
'open /cpc/home/wd52pp/data/nn/empr/skill.mlr.2V.sst_d20_2_nino34.nmod3_3.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print Fig1.meta'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
'draw string 5.5 7.75 Nino34 Skill of Empr_FCST with SST_D20'
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
  ly21=ymin+1.0
  ly22=ymin+0.8
  ly23=ymin+0.6
  ly24=ymin+0.4
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
'set xlabs  | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12|'
 'set string 1 tc 4'
'draw string 'xlabx' 'xlaby' Lead Time (month)'
if(iframe = 1);'set vrange 0.0 1';endif
if(iframe = 2);'set vrange 0.0 1.2';endif
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 0 'nt''

'set cmark 2'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
if(iframe = 1); 'd (ac(e=1)+ac(e=11)+ac(e=12))/3.'; endif
if(iframe = 2); 'd (rms(e=1)+rms(e=11)+rms(e=12))/3.'; endif
'set cmark 2'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
if(iframe = 1); 'd ave(ac,e=5,e=7)'; endif
if(iframe = 2); 'd ave(rms,e=5,e=7)'; endif
'set cmark 2'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
if(iframe = 1); 'd (ac.2(e=1)+ac.2(e=11)+ac.2(e=12))/3.'; endif
if(iframe = 2); 'd (rms.2(e=1)+rms.2(e=11)+rms.2(e=12))/3.'; endif
'set cmark 2'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
if(iframe = 1); 'd ave(ac.2,e=5,e=7)'; endif
if(iframe = 2); 'd ave(rms.2,e=5,e=7)'; endif
*----------
'set string 1 tl 4'
if(iframe = 1);'draw string 'lx1' 'ly11' ANN_winter'; endif
'set string 2 tl 4'
if(iframe = 1);'draw string 'lx1' 'ly12' ANN_summer'; endif
'set string 3 tl 4'
if(iframe = 1);'draw string 'lx1' 'ly13' MLR_winter'; endif
'set string 4 tl 4'
if(iframe = 1);'draw string 'lx1' 'ly14' MLR_summer'; endif

'set string 1 tl 4'
if(iframe = 2);'draw string 'lx2' 'ly21' ANN_winter'; endif
'set string 2 tl 4'
if(iframe = 2);'draw string 'lx2' 'ly22' ANN_summer'; endif
'set string 3 tl 4'
if(iframe = 2);'draw string 'lx2' 'ly23' MLR_winter'; endif
'set string 4 tl 4'
if(iframe = 2);'draw string 'lx2' 'ly24' MLR_summer'; endif
'set string 1 tl 5'
if(iframe = 1); 'draw string 'tx' 'ty' a) AC'; endif
if(iframe = 2); 'draw string 'tx' 'ty' b) RMS Error'; endif
iframe=iframe+1
endwhile
'print'
'printim skill_vs_lead.ann.win_sum.png gif x800 y600'
*'c'
 'set vpage off'
*----------
