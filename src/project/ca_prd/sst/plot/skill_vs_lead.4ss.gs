'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
nt=15
tool=ann
'open /cpc/consistency/id/ca_hcst/seasonal/skill.cahcst.esm.nino34.tgtss_vs_lead.ctl'
'open /cpc/consistency/nn/cfsv2_ww/skill.mlr.tgtss.3V.SSTem_sst_d20_2_nino34.ld1-7.nmod3_3_3.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print Fig1.meta'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.14 0.14'
'draw string 5.5 7.75 Skill of Nino34 FCST: CA vs CFSv2'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=1.25;  xlen=4.;  xgap=0.5
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
  lx1=xmin+0.2
  lx2=xmin+2.3
  ly11=ymin+1.0
  ly12=ymin+0.8
  ly13=ymin+0.6
  ly14=ymin+0.4
*
  ly21=ymin+0.8
  ly22=ymin+0.6
  ly23=ymin+0.4
  ly24=ymin+0.2
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
'set xlabs  | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 |'
 'set string 1 tc 4'
'draw string 'xlabx' 'xlaby' Lead Time (month)'
if(iframe = 1);'set vrange 0.2 1';endif
if(iframe = 3);'set vrange 0.2 1';endif
if(iframe = 2);'set vrange 0.0 1.2';endif
if(iframe = 4);'set vrange 0.0 1.2';endif
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 0 'nt''

'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
if(iframe = 1); 'd (acm.2(e=1)+acm.2(e=11)+acm.2(e=12))/3.'; endif
if(iframe = 3); 'd ave(acm.2,e=2,e=4)'; endif
'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
if(iframe = 1); 'd ave(acm.2,e=5,e=7)'; endif
if(iframe = 3); 'd ave(acm.2,e=8,e=10)'; endif
'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
if(iframe = 1); 'd (ac(e=1)+ac(e=11)+ac(e=12))/3.'; endif
if(iframe = 3); 'd ave(ac,e=2,e=4)'; endif
'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
if(iframe = 1); 'd ave(ac,e=5,e=7)'; endif
if(iframe = 3); 'd ave(ac,e=8,e=10)'; endif
'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
if(iframe = 2); 'd (rmsm.2(e=1)+rmsm.2(e=11)+rmsm.2(e=12))/3.'; endif
if(iframe = 4); 'd ave(rmsm.2,e=2,e=4)'; endif
'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
if(iframe = 2); 'd ave(rmsm.2,e=5,e=7)'; endif
if(iframe = 4); 'd ave(rmsm.2,e=8,e=10)'; endif
'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
if(iframe = 2); 'd (rms(e=1)+rms(e=11)+rms(e=12))/3.'; endif
if(iframe = 4); 'd ave(rms,e=2,e=4)'; endif
'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
if(iframe = 2); 'd ave(rms,e=5,e=7)'; endif
if(iframe = 4); 'd ave(rms,e=8,e=10)'; endif
*----------
'set string 1 tl 4'
if(iframe = 1);'draw string 'lx1' 'ly11' CFSv2_winter'; endif
'set string 2 tl 4'
if(iframe = 1);'draw string 'lx1' 'ly12' CA_winter'; endif
'set string 4 tl 4'
if(iframe = 1);'draw string 'lx1' 'ly13' CFSv2_summer'; endif
'set string 3 tl 4'
if(iframe = 1);'draw string 'lx1' 'ly14' CA_summer'; endif

'set string 1 tl 4'
if(iframe = 2);'draw string 'lx2' 'ly11' CFSv2_winter'; endif
'set string 2 tl 4'
if(iframe = 2);'draw string 'lx2' 'ly12' CA_winter'; endif
'set string 4 tl 4'
if(iframe = 2);'draw string 'lx2' 'ly13' CFSv2_summer'; endif
'set string 3 tl 4'
if(iframe = 2);'draw string 'lx2' 'ly14' CA_summer'; endif

'set string 1 tl 4'
if(iframe = 3);'draw string 'lx1' 'ly11' CFSv2_spring'; endif
'set string 2 tl 4'
if(iframe = 3);'draw string 'lx1' 'ly12' CA_spring'; endif
'set string 4 tl 4'
if(iframe = 3);'draw string 'lx1' 'ly13' CFSv2_fall'; endif
'set string 3 tl 4'
if(iframe = 3);'draw string 'lx1' 'ly14' CA_fall'; endif

'set string 1 tl 4'
if(iframe = 4);'draw string 'lx2' 'ly21' CFSv2_spring'; endif
'set string 2 tl 4'
if(iframe = 4);'draw string 'lx2' 'ly22' CA_spring'; endif
'set string 4 tl 4'
if(iframe = 4);'draw string 'lx2' 'ly23' CFSv2_fall'; endif
'set string 3 tl 4'
if(iframe = 4);'draw string 'lx2' 'ly24' CA_fall'; endif

'set strsiz 0.13 0.13'
'set string 1 tl 5'
if(iframe = 1); 'draw string 'tx' 'ty' a) AC'; endif
if(iframe = 3); 'draw string 'tx' 'ty' b) AC'; endif
if(iframe = 2); 'draw string 'tx' 'ty' c) RMSE'; endif
if(iframe = 4); 'draw string 'tx' 'ty' d) RMSE'; endif
iframe=iframe+1
endwhile
'print'
'printim skill_vs_lead.4ss.png gif x800 y600'
*'c'
 'set vpage off'
*----------
