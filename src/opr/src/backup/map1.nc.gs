function modnm (args)
ICin=subwrd(args,1)
ICi=substr(ICin,5,2)
yri=substr(ICin,1,4)
*dir='/gpfs/dell2/cpc/noscrub/cpc.nmme/NMME2/ENSMEAN/prob/'
dir='/cpc/nmme/NMME2/ENSMEAN/prob/'
nn=1
while (nn<6)

  if (nn=1)
    'xdfopen tmp2m.prob.mon.ctl'
    var='t'
    varname='TMP2m'
    r=1
    fignm1='origfigs/prob_ensemble_tmp2m_us_lead'
  endif
  if (nn=2)
    'xdfopen tmp2m.prob.mon.ctl'
    var='t'
    varname='TMP2m'   
    r=2
    fignm1='origfigs/prob_ensemble_tmp2m_lead'
  endif
  if (nn=3)
    'xdfopen tmpsfc.prob.mon.ctl'
    var='s'
    varname='SST'    
    r=2
    fignm1='origfigs/prob_ensemble_tmpsfc_lead'
  endif
  if (nn=4)
    'xdfopen prate.prob.mon.ctl'
    var='p'
    varname='Prate'
    r=1
    fignm1='origfigs/prob_ensemble_prate_us_lead'
  endif
  if (nn=5)
    'xdfopen prate.prob.mon.ctl'
    var='p'
    varname='Prate'   
    r=2
    fignm1='origfigs/prob_ensemble_prate_lead'
  endif  
  

  TT=1
  while (TT<8)
    IC=ICi
    yr=yri
    
    'set t 'TT+1
    'define tcmx=prob_above'
    'define neut=prob_norm'
    'define tcmn=prob_below'

    'set vpage 0.0 11 0 8.5'
    'set parea 0.75 10.25 1.25 7.75'

    lats.1=10
    late.1=72
    lons.1=190
    lone.1=300
    lats.2=-90
    late.2=90
    lons.2=0
    lone.2=360

    targ.1='Jan'
    targ.2='Feb'
    targ.3='Mar'
    targ.4='Apr'
    targ.5='May'
    targ.6='Jun'
    targ.7='Jul'
    targ.8='Aug'
    targ.9='Sep'
    targ.10='Oct'
    targ.11='Nov'
    targ.12='Dec'

    if (var = 't') 
      clevsT=' 0 40 50 60 70 80 90'
      ccolsTa=' 99 99 22 23 24 25 73 74'
      ccolsTb=' 99 99   43 44 45 46 47 48'
      ccolsTc=' 99 99  83  84 85 86 87 88 89'
      ccolsTaa=' 99 69 69'
      ccolsTbb=' 99 59 59'
    endif

    if (var = 's') 
      clevsT=' 0 40 50  70 90'
      ccolsTa=' 99 99 22 23 24 25 26 27'
      ccolsTb=' 99 99  42 43 44 45 46 47'
      ccolsTc=' 99 99  83   84 85 86 88 89'
      ccolsTaa=' 99 26 26'
      ccolsTbb=' 99 59 59'
    endif

    if (var = 'p') 
      clevsT=' 0 40 50 60 70  '
      ccolsTa=' 99 99   32  35 37 39'
      ccolsTb=' 99 99    73  74 75 76 77'
      ccolsTc=' 99 99  83   84 85 86 88 89'
      ccolsTaa=' 99 39 39'
      ccolsTbb=' 99 79 79'
    endif


    lead=TT
    tnum=IC+lead    
    if (tnum>12)
      tnum=tnum-12 
      yr=yr+1  
    endif
    ICname=yri''IC
    targdate=targ.tnum
    figname=fignm1''lead'.png'
    say figname

    'set display color white'
    'c'
    'rgbset2'
  
     if (r=1);'set mpdset mres';endif
    'set grads off'

    if (lead=1)
      'open lsmask.ctl'
      if (r=1); 'define land=(land.2(t=1))'; endif
      if (r=2)
        if (var='s') ; 'define land=(-land.2(t=1))+0.1'; endif
        if (var='t') ; 'define land=(land.2(t=1))'; endif
        if (var='p') ; 'define land=(land.2(t=1))'; endif
      endif
      'close 2'
    endif

    
*    'define aa=((maskout(maskout(maskout(exmx,exmx-0.15),tcmx-0.38),-tcmn+0.34)))*100'
*    'define bb=((maskout(maskout(maskout(exmn,exmn-0.15),tcmn-0.38),-tcmx+0.34)))*100'

    'define a=((maskout(maskout(tcmx,tcmx-0.38),-tcmn+0.38)))*100'
    'define b=((maskout(maskout(tcmn,tcmn-0.38),-tcmx+0.38)))*100'
    'define c=(maskout(maskout(maskout(neut,neut-0.38),-tcmx+0.38),-tcmn+0.34))*100'

*    'define aa=((maskout(maskout(maskout(exmx,exmx-0.15),tcmx-0.38),-tcmn+0.34)))*100'
*    'define bb=((maskout(maskout(maskout(exmn,exmn-0.15),tcmn-0.38),-tcmx+0.34)))*100'
*    'define a=((maskout(maskout(tcmx,tcmx-0.38),-tcmn+0.34)))*100'
*    'define b=((maskout(maskout(tcmn,tcmn-0.38),-tcmx+0.34)))*100'
*    'define c=(maskout(maskout(maskout(neut,neut-0.38),-tcmx+0.34),-tcmn+0.34))*100'


    'set lat 'lats.r' 'late.r
    'set lon 'lons.r' 'lone.r
     if (r=1)
       'set xlint 20'
       'set ylint 10'
     endif
     if (r=2)
       'set xlint 60'
       'set ylint 30'
     endif
  
     'set gxout shaded'
     'set clevs 'clevsT
     'set ccols 'ccolsTa
     'set xlopts 1 3 .17'
     'set ylopts 1 3 .17'
     'd (maskout(a,land))'
     'set clevs 'clevsT
     'set gxout contour'
*     'd (maskout(a,land))'
     'query shades'
     ashades=result
     rec2=sublin(ashades,2)

     'test=aave(maskout(b,land),lon='lons.r', lon='lone.r', lat='lats.r', lat='late.r')'
     'd test'
     resB=subwrd(result,4)
     if (resB > -99.0)
       'set gxout shaded'
       'set clevs 'clevsT
       'set ccols 'ccolsTb
       'd (maskout(b,land))'
       'set clevs 'clevsT
       'set ccolor 1'
       'set gxout contour'
*       'd (maskout(b,land))'
     endif
     'query shades'
     bshades=result
  
     'test=aave(maskout(c,land),lon='lons.r', lon='lone.r', lat='lats.r', lat='late.r')'
     'd test'
     resC=subwrd(result,4)
     if (resC > -99.0) 
       'set gxout shaded'
       'set clevs 'clevsT
       'set ccols 'ccolsTc 
       'd (maskout(c,land))'
       'set clevs 'clevsT
       'set ccolor 1'
       'set cthick 5'
       'set gxout contour'
*       'd (maskout(c,land))'
     endif
     'query shades'
     cshades=result


     if (r=10)
       'test=aave(maskout(aa,land),lon='lons.r', lon='lone.r', lat='lats.r', lat='late.r')'
       'd test'
       resAA=subwrd(result,4)
       if (resAA > -99.0)   
         'set gxout shaded'
         'set clevs 15 99'
         'set ccols 'ccolsTaa
         'd (maskout(aa,land))'
       endif
       'query shades'
       aashades=result
  
       'test=aave(maskout(bb,land),lon='lons.r', lon='lone.r', lat='lats.r', lat='late.r')'
       'd test'
       resBB=subwrd(result,4)

       if (resBB > -99.0)          
         'set gxout shaded'
         'set clevs 15 99'
         'set ccols 'ccolsTbb
         'd (maskout(bb,land))'
       endif
       'query shades'
       bbshades=result
       
     endif
    'draw title NMME prob fcst 'varname' IC='ICname' for lead 'lead' 'yr' 'targdate
    if (r=1)
      'set line 1 1 1'
      'draw shp shpfiles/g2008_1'
    endif


*******************************
*DRAWING THE COLORBAR
*******************************
y1=0.6
y2=0.85
ylabel=0.4
anum=sublin(ashades,1)
anum=subwrd(anum,5)
num=1
'set strsiz 0.13 0.14'
while (num<anum)
  rec=sublin(ashades,num+2)
  col=subwrd(rec,1)
  lo=subwrd(rec,2)
  hi=subwrd(rec,3)
  'set line ' col
if (var='t'); x1=(0.5*num) ; else;  x1=(0.5*num)+1.5; endif
  x2=x1+0.5

  'draw recf 'x1' 'y1' 'x2' 'y2
  'set line ' 1
  'draw rec 'x1' 'y1' 'x2' 'y2
  if (num=1) ;   'draw string 'x1' 'ylabel' 'lo'%' ; endif
  if (num<anum-1) ; 'draw string 'x2' 'ylabel' 'hi ; endif
  num=num+1
endwhile
xs=((x2-1.5)/2)+1.25
'set strsiz 0.2 0.2'
'draw string 'xs' 0.125 Above'
'set strsiz 0.13 0.14'

x1=x1+0.1

if (r=10)
  if (resAA>-99.0)
    test=sublin(aashades,1)
    if (test != 'None') 
      rec=sublin(aashades,3)
      col=subwrd(rec,1)
      hi=subwrd(rec,3)
      'set line ' col
      x1a=0.5+x1
      x2a=x1a+0.5
      'draw recf 'x1a' 'y1' 'x2a' 'y2
      'set line ' 1
      'draw rec 'x1a' 'y1' 'x2a' 'y2  
      'draw string 'x1a' 'ylabel' >15%'
      'draw string 'x1a' 0.125 +Extr.'
      x1a=x1a+0.35
    else
      x1a=x1+0.35      
    endif
  else
    x1a=x1+0.35    
  endif
else
  x1a=x1+0.35
endif

if (resB>-99.0)
  test=sublin(bshades,1)
  if (test!= 'None')

  bnum=sublin(bshades,1)
  bnum=subwrd(bnum,5)
  num=1
  while (num<bnum)
    rec=sublin(bshades,num+2)
    col=subwrd(rec,1)
    lo=subwrd(rec,2)    
    hi=subwrd(rec,3)
    'set line ' col
    x3=(0.5*num)+x1a
    x4=x3+0.5
    'draw recf 'x3' 'y1' 'x4' 'y2
    'set line '1
    'draw rec 'x3' 'y1' 'x4' 'y2
    if (num=1) ;   'draw string 'x3' 'ylabel' 'lo'%' ; endif
    if (num<anum-1) ; 'draw string 'x4' 'ylabel' 'hi ; endif
    num=num+1
  endwhile
  xs=(((x4-x1a)/2)+x1a)
  'set strsiz 0.2 0.2'
  'draw string 'xs' 0.125 Below'
  'set strsiz 0.13 0.14'
  x3=x3+0.1
else
  x3=x1a+0.35
endif
endif

*if (r=10)
*  if (resBB>-99.0)
*    test=sublin(bbshades,1)
*    if (test != 'None')
*      rec=sublin(bbshades,3)
*      col=subwrd(rec,1)
*      hi=subwrd(rec,3)
*      'set line ' col
*      x3a=0.5+x3
*      x4a=x3a+0.5
*      'draw recf 'x3a' 'y1' 'x4a' 'y2  
*      'set line '1
*      'draw rec 'x3a' 'y1' 'x4a' 'y2
*      'draw string 'x3a' 'ylabel' >15%' 
*      'draw string 'x3a' 0.125 -Extr.'  
*      x3a=x3a+0.35
*    else
*      x3a=x3+0.35
*    endif
*  else
*    x3a=x3+0.35
*  endif
*else
*  x3a=x3+0.35
*endif

  x3a=x1a+0.35+0.35+0.4*anum       
if (resC>-99.0)
  test=sublin(cshades,1)
  if (test!= 'None')

  cnum=sublin(cshades,1)
  cnum=subwrd(cnum,5)
  num=1
  while (num<anum)
    rec=sublin(cshades,num+2)
    col=subwrd(rec,1)
    lo=subwrd(rec,2)
    hi=subwrd(rec,3)
    'set line ' col
    x5=(0.5*num)+x3a
*    x5=(0.5*num)+x1a+0.35+0.35
    x6=x5+0.5
    'draw recf 'x5' 'y1' 'x6' 'y2
    'set line '1
    'draw rec 'x5' 'y1' 'x6' 'y2
    if (num=1) ;   'draw string 'x5' 'ylabel' 'lo'%' ; endif
    if (num<anum-1) ; 'draw string 'x6' 'ylabel' 'hi ; endif  
    num=num+1
  endwhile
  xs=(((x6-x3a)/2)+x3a)-0.35

  'set strsiz 0.2 0.2'
  'draw string 'xs' 0.125 Neutral'
endif
endif

*if (TT=6); exit; endif

*************************************************
* END COLORBAR
*************************************************


    'printim 'figname

    TT=TT+1
  endwhile

  'close 1'
  nn=nn+1
endwhile

quit
