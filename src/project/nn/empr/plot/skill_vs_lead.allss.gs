'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
nt=13
tool=mlr
*'open /cpc/home/wd52pp/data/nn/empr/skill.'tool'.1V.sst_2_nino34.nmod11.neurons25.ctl'
*'open /cpc/home/wd52pp/data/nn/empr/skill.'tool'.1V.d20_2_nino34.nmod3.neurons25.ctl'
*'open /cpc/home/wd52pp/data/nn/empr/skill.'tool'.2V.sst_d20_2_nino34.nmod3_3.neurons25.ctl'
*'open /cpc/consistency/nn/cfsv2_ww/skill.'tool'.tgtss.1V.SSTem_2_nino34.ld1-7.nmod11.ctl'
'open /cpc/home/wd52pp/data/nn/empr/skill.'tool'.1V.sst_2_nino34.nmod11.ctl'
'open /cpc/home/wd52pp/data/nn/empr/skill.'tool'.1V.d20_2_nino34.nmod3.ctl'
'open /cpc/home/wd52pp/data/nn/empr/skill.'tool'.2V.sst_d20_2_nino34.nmod3_3.ctl'
*'open /cpc/home/wd52pp/data/nn/empr/skill.'tool'.2V.sst_d20_2_nino34.nmod7.eeof.ctl'
'open /cpc/consistency/nn/cfsv2_ww/skill.'tool'.tgtss.1V.SSTem_2_nino34.ld1-7.nmod11.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print Fig1.meta'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
'draw string 5.5 7.75 Skill of NINO3.4 FCST for All Seasons over 1983-2020'
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
  ly22=ymin+0.9
  ly23=ymin+2.05
  ly24=ymin+2.7
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
if(iframe = 1);'set vrange 0.2 1';endif
if(iframe = 2);'set vrange 0.2 1';endif
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 0 'nt''
'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
if(iframe = 1); 'd ave(ac,e=1,e=12)'; endif
if(iframe = 2); 'd ave(rms,e=1,e=12)'; endif
'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
if(iframe = 1); 'd ave(ac.2,e=1,e=12)'; endif
if(iframe = 2); 'd ave(rms.2,e=1,e=12)'; endif
'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
if(iframe = 1); 'd ave(ac.3,e=1,e=12)'; endif
if(iframe = 2); 'd ave(rms.3,e=1,e=12)'; endif
'set cmark 3'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
if(iframe = 1); 'd ave(acm.4,e=1,e=12)'; endif
if(iframe = 2); 'd ave(rmsm.4,e=1,e=12)'; endif
*----------
'set strsiz 0.11 0.11'
'set string 1 tl 5'
if(iframe = 1);'draw string 'lx1' 'ly11' CFSv2'; endif
'set string 3 tl 5'
if(iframe = 1);'draw string 'lx1' 'ly12' MLR(SST)'; endif
'set string 4 tl 5'
if(iframe = 1);'draw string 'lx1' 'ly13' MLR(D20)'; endif
'set string 2 tl 5'
if(iframe = 1);'draw string 'lx1' 'ly14' MLR(SST,D20)'; endif

'set string 1 tl 5'
if(iframe = 2);'draw string 'lx2' 'ly11' CFSv2'; endif
'set string 3 tl 5'
if(iframe = 2);'draw string 'lx2' 'ly12' MLR(SST)'; endif
'set string 4 tl 5'
if(iframe = 2);'draw string 'lx2' 'ly13' MLR(D20)'; endif
'set string 2 tl 5'
if(iframe = 2);'draw string 'lx2' 'ly14' MLR(SST,D20)'; endif
'set string 1 tl 5'
if(iframe = 1); 'draw string 'tx' 'ty' a) AC'; endif
if(iframe = 2); 'draw string 'tx' 'ty' b) RMS Error'; endif
iframe=iframe+1
endwhile
'print'
'printim skill_vs_lead.allss.'tool'.png gif x800 y600'
*'c'
 'set vpage off'
*----------
