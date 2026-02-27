
function prate(args)
yearini=subwrd(args,1)
monthini=subwrd(args,2)
model=subwrd(args,3)
*
say "yearini="yearini
say "monthini="monthini
say "model="model

'reinit'
'run /global/save/wx23ss/gscripts/rgbset.gs'
'run /cpc/save/wx52qz/grads/lib/white.gs'
*'run /cpc/save/wx52qz/grads/rgbset2.gs'
'c'
'set mproj scaled'
'set mpdset mres'
*
'open /cpc/save/wx52qz/NMME/plots/template_ac_t2m.ctl'
'open /cpc/save/wx52qz/NMME/plots/lsmask.ctl'
*
*'/climate/save/wx20mp/grads/rgbset2.gs'
'set gxout shaded'

'set dfile 1'
'set lon 190 300'
'set lat 10 72'
'set z 1 1'
fm=monthini
fyear=yearini

m=1
while(m<=7)
ml=m+1
'enable print figure.gx'
fm=fm+1
if(fm>12)
fm=fm-12
fyear=fyear+1
endif
fmon=getfcstmon(fm)
say "fcstmon="fmon
say"fcstyear="fyear

xmin0=0.5
ymin0=8.0
xlen=10.0
ylen=-7.0
'set map 1 1 5'
'set xlopts 1 1 0.1'
'set ylopts 1 1 0.1'
xgap=0.3
ygap=-0.2
clopts=0.10 
lat1=-1.0
lat2=1.0
'set xlint 20'
'set ylint 10'
'set xlopts 1 5 0.15'
'set ylopts 1 5 0.15'
'set t 'm
ic=1;jc=1
xpos=xmin0+(ic-1)*(xlen+xgap)
xpos1=xpos+xlen
ypos=ymin0+(jc-1)*(ylen+ygap)
ypos1=ypos+ylen
xpos1=xpos+xlen
xposw=xpos+xlen/2
yposw=ypos+0.10
'set parea  'xpos' 'xpos1' 'ypos1' 'ypos
'set grads off'
'set gxout shaded'
'set clevs 10 20 30 40 50 60 70 80 90'
'set ccols  0 91 92 31 33 35 37 81 82 85'
'd 100*'model'.1(t='ml')'
'set strsiz 0.15 0.20'
'set string 1 bc 5'
'draw string 'xposw' 'yposw' MMMM Forecast of TMP2m Skill (AC) IC='yearini''monthini' for Lead 'm' 'fyear''fmon
ybar=ypos1-0.6
'run /cpc/save/wx52qz/grads/scripts/cbarn.gs 1.0 0 5.5 'ybar' 1'

'print'
'printim skill_MMMM_ensemble_tmp2m_us_lead'm'.png'
*pull dumm
'c'
'disable print'
m=m+1
endwhile
'c'
'quit'
function getfcstmon(fm)
if(fm=1);fmon='Jan';endif;
if(fm=2);fmon='Feb';endif;
if(fm=3);fmon='Mar';endif;
if(fm=4);fmon='Apr';endif;
if(fm=5);fmon='May';endif;
if(fm=6);fmon='Jun';endif;
if(fm=7);fmon='Jul';endif;
if(fm=8);fmon='Aug';endif;
if(fm=9);fmon='Sep';endif;
if(fm=10);fmon='Oct';endif;
if(fm=11);fmon='Nov';endif;
if(fm=12);fmon='Dec';endif;
return fmon

