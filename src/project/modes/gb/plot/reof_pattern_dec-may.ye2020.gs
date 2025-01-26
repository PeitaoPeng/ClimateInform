'reinit'
'open /cpc/consistency/telecon/gb/reof.positive_phase.z500.1950-2020.ctl'
*Plot the loading patterns used in the codes to calcualte the teleconnection indices
*file is rotated_original_loadingpatterns_dec-may.gs
*
'run /cpc/home/wd52pp/bin/rgbset.gs'
'set dfile 1'
'set lat 0 90'
'set lon -240 120'
*
#
iloop=1
ilpend=10
while(iloop <= ilpend);
if(iloop = 1);tele=nao;name="North Atlantic Oscillation";endif 
if(iloop = 2);tele=ea;name="East Atlantic Pattern";endif 
if(iloop = 3);tele=wp;name="West Pacific Pattern";endif 
if(iloop = 4);tele=epnp;name="East Pacific - North Pacific Pattern";endif 
if(iloop = 5);tele=pna;name="Pacific/ North American Pattern";endif 
if(iloop = 6);tele=eawr;name="East Atlantic/ Western Russia Pattern";endif 
if(iloop = 7);tele=scand;name="Scandinavia Pattern";endif 
if(iloop = 8);tele=tnh;name="Tropical/ Northern Hemisphere Pattern";endif 
if(iloop = 9);tele=poleur;name="Polar Eurasian Pattern";endif 
if(iloop = 10);tele=pt;name="Pacific Transition Pattern";endif 
*'enable print 'tele'.loading_dec-may.gmf'
plotfil=tele"_pattern_dec-may_ye2020"
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
'set t 12'
month="December"
if(iloop != 10)
     'set parea 'xl0' 'xr0' 'yb0' 'yt0
     'set gxout shaded'
     'set grads off'
     'set ccols 48 46 45 44 43 42 0 22 23 24 25 26 28'
     'set clevs -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
     'd 1*'tele
xpos=(xl0+xr0)/2
ypos=yt0+0.25
'set strsiz 0.17'
'set string 1 tc 6'
'draw string 'xpos' 'ypos' 'month
endif
'draw string 5.5 8.3 'name' (Positive Phase Shown)'
'draw string 5.5 8.05 1950-2020 Covariance Based Varimax REOF for Calculating Indices'
*
'set t 1'
month="January"
xl=xr0+xinc
xr=2*xr0+xinc
yb=yb0
yt=yt0
if(iloop != 9 & iloop != 10)
    'set parea 'xl' 'xr' 'yb' 'yt
    'set gxout shaded'
    'set grads off'
     'set ccols 48 46 45 44 43 42 0 22 23 24 25 26 28'
     'set clevs -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
    'd 1*'tele
'set strsiz 0.17'
'set string 1 tc 6'
xpos=(xl+xr)/2
ypos=yt+0.25
'draw string 'xpos' 'ypos' 'month
endif
*
'set t 2'
month="February"
xl=xr+xinc
xr=xr+xr0+xinc
yb=yb0
yt=yt0
if(iloop != 10)
    'set parea 'xl' 'xr' 'yb' 'yt
    'set gxout shaded'
    'set grads off'
     'set ccols 48 46 45 44 43 42 0 22 23 24 25 26 28'
     'set clevs -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
    'd 1*'tele
    'set strsiz 0.17'
    'set string 1 tc 6'
xpos=(xl+xr)/2
ypos=yt+0.25
'draw string 'xpos' 'ypos' 'month
endif
*
'set t 3'
month="March"
yb=yb0-yinc
yt=yt0-yinc
if(iloop != 10)
    'set parea 'xl0' 'xr0' 'yb' 'yt
    'set gxout shaded'
    'set grads off'
     'set ccols 48 46 45 44 43 42 0 22 23 24 25 26 28'
     'set clevs -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
    'd 1*'tele
'set strsiz 0.17'
'set string 1 tc 6'
xpos=(xl0+xr0)/2
ypos=yt+0.25
'draw string 'xpos' 'ypos' 'month
endif
*
'set t 4'
month="April"
xl=xr0+xinc
xr=2*xr0+xinc
yb=yb0-yinc
yt=yt0-yinc
if(iloop != 8 & iloop != 10)
    'set parea 'xl' 'xr' 'yb' 'yt
    'set gxout shaded'
    'set grads off'
     'set ccols 48 46 45 44 43 42 0 22 23 24 25 26 28'
     'set clevs -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
    'd 1*'tele
'set strsiz 0.17'
'set string 1 tc 6'
xpos=(xl+xr)/2
ypos=yt+0.25
'draw string 'xpos' 'ypos' 'month
endif
*
'set t 5'
month="May"
xl=xr+xinc
xr=xr+xr0+xinc
yb=yb0-yinc
yt=yt0-yinc
if(iloop != 8 & iloop != 10)
     'set parea 'xl' 'xr' 'yb' 'yt
     'set gxout shaded'
     'set grads off'
     'set ccols 48 46 45 44 43 42 0 22 23 24 25 26 28'
     'set clevs -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
    'd 1*'tele
'set strsiz 0.17'
'set string 1 tc 6'
xpos=(xl+xr)/2
ypos=yt+0.25
'draw string 'xpos' 'ypos' 'month
endif
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 0.5'
*
   xp=xr-2
if(iloop = 8);yp=yb0-0.63;endif
if(iloop != 8);yp=yb-0.63;endif   
*   'draw string 'xp' 'yp' (x 10`a-2`n)'

*'gxprint 'plotfil'.png white'
'printim 'plotfil'.png white gif x800 y600'
if(iloop < ilpend);'clear';endif
iloop=iloop+1
endwhile
'quit'
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
