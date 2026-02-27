* include U10m correlation for rev2

'reinit'
'set font 0'
'set mproj scaled'
'run /u/wx52ww/grads/scripts/white.gs'

'enable print Fig02_correlations_rev3.meta'

xmin0=1.75
ymin0=10.5
xlen=5
ylen=-2.0
xgap=0.5
ygap=-0.5

xlopts=0.10
ylopts=0.10

'set rgb  80  180 180 180'
'set rgb  70  255 255 255'
'run rgbset.gs'

clevscor="-0.40 -0.30 -0.20 -0.10 0.10 0.20 0.30 0.40"
ccolscor="49 46 44 42 70 22 24 26 29"

'open /cpc/noscrub/wx52ww/data/CFSfcst/ISOENSO/ninoSSTsU10mWPac/cornino34_xU10m_200502201001.ctl'
'open /cpc/noscrub/wx52ww/data/CFSfcst/ISOENSO/ninoSSTsU10mWPacMC/cornino34xU10mMC200502201001.ctl'

ifm=0
while(ifm<1)
 ifm=ifm+1
 'set string 1 bl 1 0'
 'set grads off'
 'set grid on '
 'set lon 110 280'
 'set xlopts 1 4 'xlopts
 'set ylopts 1 4 'ylopts

 if(ifm=1);ic=1;jc=1;endif
 if(ifm=2);ic=1;jc=2;endif
 if(ifm=3);ic=1;jc=3;endif
 xpos=xmin0+(ic-1)*(xlen+xgap)
 xpos1=xpos+xlen
 ypos=ymin0+(jc-1)*(ylen+ygap)
 ypos1=ypos+ylen
 xpos1=xpos+xlen
 xposw=xpos
 yposw=ypos+0.05
 'set yflip off'
* 'set yflip on'
 'set ylint 30'
 'set parea  'xpos' 'xpos1' 'ypos1' 'ypos

 'set gxout shaded'
 'set clevs 'clevscor
 'set ccols 'ccolscor
 'd corwr10h70'
 'hatch1.gs confabs.2 -min 99.0 -max 101 -angle 45 -density 0.01 -int 0.07'
 'hatch1.gs confabs.2 -min 99.0 -max 101 -angle 135 -density 0.01 -int 0.07'

 if(ifm=1);label='(a) Initial U10m and forecast Nino3.4 SST';endif
 if(ifm=2);label='(b) Initial WPac U10m and forecast SSH';endif
 if(ifm=3);label='(c) Initial WPac U10m and forecast SST';endif
 'set strsiz 0.11'
 'set string 1 bl 4 0'
 'draw string 'xposw' 'yposw' 'label

 'set strsiz 0.10'
 'set string 1 c 4 90'
 'draw string 'xpos-0.45' 'ypos+ylen*0.5' Forecast lead (day)'

* draw vertical line at 120E and 160E
x120e=xlen/170.*10.+xmin0
x160e=xlen/170.*50.+xmin0
'set line 1 1 4';'draw line 'x120e' 'ypos' 'x120e' 'ypos1
'set line 1 1 4';'draw line 'x160e' 'ypos' 'x160e' 'ypos1
endwhile
'close 2'
'close 1'

'open /cpc/noscrub/wx52ww/data/CFSfcst/ISOENSO/ninoSSTsU10mWPac/cor_xSSHsm_WPac200502200903.ctl'
'open /cpc/noscrub/wx52ww/data/CFSfcst/ISOENSO/ninoSSTsU10mWPacMC/corxSSHsmWPacMC200502200903.ctl'

ifm=1
while(ifm<2)
 ifm=ifm+1
 'set string 1 bl 1 0'
 'set grads off'
 'set grid on '
 'set lon 120 280'
 'set xlopts 1 4 'xlopts
 'set ylopts 1 4 'ylopts
 'set yflip off'
 'set ylint 30'

 if(ifm=1);ic=1;jc=1;endif
 if(ifm=2);ic=1;jc=2;endif
 if(ifm=3);ic=1;jc=3;endif
 xpos=xmin0+(ic-1)*(xlen+xgap)
 xpos1=xpos+xlen
 ypos=ymin0+(jc-1)*(ylen+ygap)
 ypos1=ypos+ylen
 xpos1=xpos+xlen
 xposw=xpos
 yposw=ypos+0.05
 'set parea  'xpos' 'xpos1' 'ypos1' 'ypos

 'set gxout shaded'
 'set clevs 'clevscor
 'set ccols 'ccolscor
 'd corwr10h70'
 'hatch1.gs confabs.2 -min 99.0 -max 101 -angle 45 -density 0.01 -int 0.07'
 'hatch1.gs confabs.2 -min 99.0 -max 101 -angle 135 -density 0.01 -int 0.07'

 if(ifm=1);label='(a) Initial U10m and forecast Nino3.4 SST';endif
 if(ifm=2);label='(b) Initial WPac U10m and forecast SSH';endif
 if(ifm=3);label='(c) Initial WPac U10m and forecast SST';endif
 'set strsiz 0.11'
 'set string 1 bl 4 0'
 'draw string 'xposw' 'yposw' 'label

 'set strsiz 0.10'
 'set string 1 c 4 90'
 'draw string 'xpos-0.45' 'ypos+ylen*0.5' Forecast lead (day)'

endwhile
'close 2'
'close 1'

'open /cpc/noscrub/wx52ww/data/CFSfcst/ISOENSO/ninoSSTsU10mWPac/cor_xSSTsm_WPac200502201001.ctl'
'open /cpc/noscrub/wx52ww/data/CFSfcst/ISOENSO/ninoSSTsU10mWPacMC/corxSSTsmWPacMC200502201001.ctl'

ifm=2
while(ifm<3)
 ifm=ifm+1
 'set string 1 bl 1 0'
 'set grads off'
 'set grid on '
 'set lon 120 280'
 'set xlopts 1 4 'xlopts
 'set ylopts 1 4 'ylopts
 'set yflip off'
 'set ylint 30'

 if(ifm=1);ic=1;jc=1;endif
 if(ifm=2);ic=1;jc=2;endif
 if(ifm=3);ic=1;jc=3;endif
 xpos=xmin0+(ic-1)*(xlen+xgap)
 xpos1=xpos+xlen
 ypos=ymin0+(jc-1)*(ylen+ygap)
 ypos1=ypos+ylen
 xpos1=xpos+xlen
 xposw=xpos
 yposw=ypos+0.05
 'set parea  'xpos' 'xpos1' 'ypos1' 'ypos

 'set gxout shaded'
 'set clevs 'clevscor
 'set ccols 'ccolscor
 'd corwr10h70'
 'hatch1.gs confabs.2 -min 99.0 -max 101 -angle 45 -density 0.01 -int 0.07'
 'hatch1.gs confabs.2 -min 99.0 -max 101 -angle 135 -density 0.01 -int 0.07'

 if(ifm=1);label='(a) Initial U10m and forecast Nino3.4 SST';endif
 if(ifm=2);label='(b) Initial WPac U10m and forecast SSH';endif
 if(ifm=3);label='(c) Initial WPac U10m and forecast SST';endif
 'set strsiz 0.11'
 'set string 1 bl 4 0'
 'draw string 'xposw' 'yposw' 'label
 'set strsiz 0.10'
 'set string 1 c 4 90'
 'draw string 'xpos-0.45' 'ypos+ylen*0.5' Forecast lead (day)'

endwhile
'close 2'
'close 1'

'open /cpc/noscrub/wx52ww/data/CFSfcst/ISOENSO/ninoSSTsU10mWPac/cor_xU10sm_WPac200502201001.ctl'
'open /cpc/noscrub/wx52ww/data/CFSfcst/ISOENSO/ninoSSTsU10mWPacMC/corxU10smWPacMC200502201001.ctl'

ifm=3
while(ifm<4)
 ifm=ifm+1
 'set string 1 bl 1 0'
 'set grads off'
 'set grid on '
 'set lon 120 280'
 'set xlopts 1 4 'xlopts
 'set ylopts 1 4 'ylopts
 'set yflip off'
 'set ylint 30'

 if(ifm=1);ic=1;jc=1;endif
 if(ifm=2);ic=1;jc=2;endif
 if(ifm=3);ic=1;jc=3;endif
 if(ifm=4);ic=1;jc=4;endif
 xpos=xmin0+(ic-1)*(xlen+xgap)
 xpos1=xpos+xlen
 ypos=ymin0+(jc-1)*(ylen+ygap)
 ypos1=ypos+ylen
 xpos1=xpos+xlen
 xposw=xpos
 yposw=ypos+0.05
 'set parea  'xpos' 'xpos1' 'ypos1' 'ypos

 'set gxout shaded'
 'set clevs 'clevscor
 'set ccols 'ccolscor
 'd corwr10h70'
 'hatch1.gs confabs.2 -min 99.0 -max 101 -angle 45 -density 0.01 -int 0.07'
 'hatch1.gs confabs.2 -min 99.0 -max 101 -angle 135 -density 0.01 -int 0.07'

 if(ifm=1);label='(a) Initial U10m and forecast Nino3.4 SST';endif
 if(ifm=2);label='(b) Initial WPac U10m and forecast SSH';endif
 if(ifm=3);label='(c) Initial WPac U10m and forecast SST';endif
 if(ifm=4);label='(d) Initial WPac U10m and forecast U10m';endif
 'set strsiz 0.11'
 'set string 1 bl 4 0'
 'draw string 'xposw' 'yposw' 'label
 'set strsiz 0.10'
 'set string 1 c 4 90'
 'draw string 'xpos-0.45' 'ypos+ylen*0.5' Forecast lead (day)'

endwhile


'run cbarn.gs 0.5 0 'xpos+0.5*xlen' 'ypos1-0.4' 1'

'print'
'disable print Fig02_correlations_rev3.meta'
