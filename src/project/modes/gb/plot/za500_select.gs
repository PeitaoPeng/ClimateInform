'reinit'
'open /cpc/consistency/telecon/gb/monthly_tele_pattern_1949-2021.ctl'
*Plot the loading patterns used in the codes to calcualte the teleconnection indices
*file is rotated_original_loadingpatterns_dec-may.gs
*
'run /cpc/home/wd52pp/bin/rgbset.gs'
'set dfile 1'
'set lat 0 90'
'set lon -240 120'
'define z1=z(time=jun2010)'
'define z2=z(time=mar2018)'
'define z3=z(time=sep2020)'
'define z4=z(time=sep2021)'
'define z5=z(time=may2018)'
'define z6=z(time=jun2021)'
*
#
plotfil=za500_select
time1=Jun2010
time2=Mar2018
time3=Sep2020
time4=Sep2021
time5=May2018
time6=Jun2021
*
'set vpage 0 11 0 8.5'
'set lat 20 90'
'set lon -270 90'
'set mproj nps'
'set mpdset mres'
xl0=0.5
xr0=3.5
yb0=4.5
yt0=7.5
xinc=0.1
yinc=3.5
'set t 1'
     'set parea 'xl0' 'xr0' 'yb0' 'yt0
     'set gxout shaded'
     'set grads off'
     'set ccols 48 46 45 44 43 42 0 22 23 24 25 26 28'
     'set clevs -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
     'd z1'
xpos=(xl0+xr0)/2
ypos=yt0+0.25
'set strsiz 0.17'
'set string 1 tc 6'
'draw string 'xpos' 'ypos' 'time1
'draw string 5.5 8.3 Select Standardized Z500 Anom'
*
xl=xr0+xinc
xr=2*xr0+xinc
yb=yb0
yt=yt0
    'set parea 'xl' 'xr' 'yb' 'yt
    'set gxout shaded'
    'set grads off'
     'set ccols 48 46 45 44 43 42 0 22 23 24 25 26 28'
     'set clevs -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
    'd z2'
'set strsiz 0.17'
'set string 1 tc 6'
xpos=(xl+xr)/2
ypos=yt+0.25
'draw string 'xpos' 'ypos' 'time2
*
xl=xr+xinc
xr=xr+xr0+xinc
yb=yb0
yt=yt0
    'set parea 'xl' 'xr' 'yb' 'yt
    'set gxout shaded'
    'set grads off'
     'set ccols 48 46 45 44 43 42 0 22 23 24 25 26 28'
     'set clevs -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
    'd z3'
    'set strsiz 0.17'
    'set string 1 tc 6'
xpos=(xl+xr)/2
ypos=yt+0.25
'draw string 'xpos' 'ypos' 'time3
*
yb=yb0-yinc
yt=yt0-yinc
    'set parea 'xl0' 'xr0' 'yb' 'yt
    'set gxout shaded'
    'set grads off'
     'set ccols 48 46 45 44 43 42 0 22 23 24 25 26 28'
     'set clevs -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
    'd z4'
'set strsiz 0.17'
'set string 1 tc 6'
xpos=(xl0+xr0)/2
ypos=yt+0.25
'draw string 'xpos' 'ypos' 'time4
*
'set t 5'
xl=xr0+xinc
xr=2*xr0+xinc
yb=yb0-yinc
yt=yt0-yinc
    'set parea 'xl' 'xr' 'yb' 'yt
    'set gxout shaded'
    'set grads off'
     'set ccols 48 46 45 44 43 42 0 22 23 24 25 26 28'
     'set clevs -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
    'd z5'
'set strsiz 0.17'
'set string 1 tc 6'
xpos=(xl+xr)/2
ypos=yt+0.25
'draw string 'xpos' 'ypos' 'time5
*
'set t 5'
xl=xr+xinc
xr=xr+xr0+xinc
yb=yb0-yinc
yt=yt0-yinc
     'set parea 'xl' 'xr' 'yb' 'yt
     'set gxout shaded'
     'set grads off'
     'set ccols 48 46 45 44 43 42 0 22 23 24 25 26 28'
     'set clevs -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
    'd z6'
'set strsiz 0.17'
'set string 1 tc 6'
xpos=(xl+xr)/2
ypos=yt+0.25
'draw string 'xpos' 'ypos' 'time6
*
'printim 'plotfil'.png white gif x800 y600'
*
*
function mydate
'query time'
sres = subwrd(result,3)
i=1
while (substr(sres,i,1)!='Z')
i=i+1
endwhile
hour = substr(sres,1,i)
isav = i
i = i + 1
while (substr(sres,i,1)>='0' & substr(sres,i,1)<='9')
i = i + 1
endwhile
day = substr(sres,isav+1,i-isav-1)
month = substr(sres,i,3)
year = substr(sres,i+3,4)
return (day' 'month' 'year)
