#!/bin/sh
set -ex
#
# Calculates seasonal skill of realtime CFS forecast for a given target season
# for individual member and sort them according to the skill
#
#cDate=20110318
#tDate=20101201
#gDate=20101101
#iDate=20101001
#imagDir=/gpfs/t2c/cpc/noscrub/wx52cm/CFSfcst/realTime/monthly/seasonAttri


tyy=`echo $tDate | cut -c1-4`
tmm=`echo $tDate | cut -c5-6`

gyy=`echo $gDate | cut -c1-4`
gmm=`echo $gDate | cut -c5-6`

iyy=`echo $iDate | cut -c1-4`
imm=`echo $iDate | cut -c5-6`

if [ ! -d $imagDir/$tyy$tmm ]; then
 mkdir -p $imagDir/$tyy$tmm
fi

cd  $imagDir/$tyy$tmm
varb=z200
varblong='200-hPa Geopotential height [gpm]'
lat1=20
lat2=90
lon1=0
lon2=360
undef=-9999.0
leadTime=0

outfileAnom=CFSsort$varb.$tyy$tmm
outfileSkill=CFSsort$varb.$tyy$tmm.skill
cat <<ctlEOF>$outfileAnom.ctl
DSET ^$outfileAnom.gr
UNDEF  $undef
options big_endian template
TITLE seasonal mean of CFS forecast
*$sorcDir/monthlyUpdateCFSsort.sh
xdef 144 linear 0.000000 2.500000
ydef 73 linear -90.000000 2.5
zdef 42  linear  1 1
*40 members sorted according to the skill 
*z=41 observation
*z=42 ensemble mean
TDEF 1 LINEAR mar2011 1MO
*the middle month of the target season
VARS 1
$varb    42   99   $varblong 
ENDVARS
ctlEOF

cat <<ctlEOF>$outfileSkill.ctl
DSET ^$outfileSkill.gr
UNDEF  $undef
options big_endian template
TITLE seasonal skill of CFS forecast
*$sorcDir/monthlyUpdateCFSsort.sh
xdef 1 linear 0.000000 2.500000
ydef 1 linear -90.000000 2.5
zdef 41  linear  1 1
*40 members sorted according to the skill 
TDEF 1   LINEAR mar2011 1MO
*the middle month of the target season
VARS 1
$varb    41   99   $varblong 
ENDVARS
ctlEOF

###
#calculate and sort the skills for each member 
###
cat <<fEOF> skl.f
C--------------------------------------------------------------
c
      program skl
      parameter (im=144,jm=73,memb=40)
      real*4 work(im,jm),worko(im,jm),workoc(im,jm)
      real*4 workf(im,jm),workfc(im,jm)
      real*4 workssn(im,jm,memb)
      real*4 PHI(jm),DYP(jm)
      real*4 skill(memb)
      real*4 sortskill(memb)
      integer*4 membskill(memb)
      character*58 dirf
      character*27 file1
      character*29 file2
      character*29 file3
      character*29 file4
c
      rlat1=$lat1
      rlat2=$lat2
      rlon1=$lon1
      rlon2=$lon2
      print *,'region ',rlat1,rlat2,rlon1,rlon2
c
      dirf( 1:28)='/gpfs/t2c/cpc/noscrub/wx52ww'
      dirf(29:58)='/CFSfcst/RealtimeHistory/z200/'
      file1(1:27)='cfs03z200????AnmRealtime.gr'
      file2(1:29)='cfs03z200????AnmRealtime02.gr'
      file3(1:29)='cfs03z200????AnmRealtime03.gr'
      file4(1:29)='cfs03z200????AnmRealtime04.gr'
c
      data bado /-99999.00/
      data badf /9.999E+20/
      bad=$undef
c
      DATA DTK,RPD/111.19,0.0174533/
c
      open(51,file='$outfileAnom.gr'
     1 ,access='direct',recl=im*jm*4,form='unformatted')
c
      open(52,file='$outfileSkill.gr'
     1 ,access='direct',recl=4,form='unformatted')
c
      open(53,file='$outfileSkill.txt'
     1 ,access='sequential',form='formatted')
c
      dlat=180./float(jm-1) 
      dlon=360./float(im) 
      print *,'dlat dlon',dlat,dlon
      do J=1,jm
       PHI(J)=-90.+(j-1)*dlat
       DYP(J)=cos(rpd*PHI(j))
      enddo
c
      lead=$leadTime
      imms=$gmm
      iyys=$gyy 
      write(file1(10:13),'(i4.4)') iyys
      write(file2(10:13),'(i4.4)') iyys
      write(file3(10:13),'(i4.4)') iyys
      write(file4(10:13),'(i4.4)') iyys
      print *,'file1: ',file1
      print *,'file2: ',file2
      print *,'file3: ',file3
      print *,'file4: ',file4
      print *,'iyys imms leadTime',iyys,imms,lead 
      do iset=1,4
       if(iset.eq.1)then
        open(11,file=dirf//file1
     1  ,access='direct',recl=im*jm*4,form='unformatted')
       endif
       if(iset.eq.2)then
        open(11,file=dirf//file2
     1  ,access='direct',recl=im*jm*4,form='unformatted')
       endif
       if(iset.eq.3)then
        open(11,file=dirf//file3
     1  ,access='direct',recl=im*jm*4,form='unformatted')
       endif
       if(iset.eq.4)then
        open(11,file=dirf//file4
     1  ,access='direct',recl=im*jm*4,form='unformatted')
       endif
       do n=1,10    !10 latest members in each month
c seasonal mean 
        do j=1,jm
        do i=1,im
         worko(i,j)=0.0
         workoc(i,j)=0.0
         workf(i,j)=0.0
         workfc(i,j)=0.0
        enddo
        enddo
        do m=1,3
         irec=(imms-1)*9*31+30*9+m+lead ! record of obs
         read(11,rec=irec) work
         do j=1,jm
         do i=1,im
          if(work(i,j).ne.bado) then
           worko(i,j)=worko(i,j)+work(i,j)
           workoc(i,j)=workoc(i,j)+1.0
          endif
         enddo
         enddo
         irec=(imms-1)*9*31+(n-1+10)*9+m+lead   !members 11-20 forecast
         read(11,rec=irec) work
         do j=1,jm
         do i=1,im
          if(work(i,j).ne.bad) then
           workf(i,j)=workf(i,j)+work(i,j)
           workfc(i,j)=workfc(i,j)+1.0
          endif
         enddo
         enddo
        enddo
        iz=(iset-1)*10+n
        do j=1,jm
        do i=1,im
         if(workoc(i,j).gt.1.0)then
          worko(i,j)=worko(i,j)/workoc(i,j)
         else
          worko(i,j)=bad
         endif
         if(workfc(i,j).gt.1.0)then
          workf(i,j)=workf(i,j)/workfc(i,j)
         else
          workf(i,j)=bad
         endif
         workssn(i,j,iz)=workf(i,j)
        enddo
        enddo
C calculate skills 
        corl=0.0
        avef=0.0
        aveo=0.0
        varf=0.0
        varo=0.0
        snum=0.0
        do j=1,jm
        do i=1,im
         rlat=-90.+(j-1)*dlat
         rlon=0.0+(i-1)*dlon
         if(rlat.ge.rlat1.and.rlat.le.rlat2.and.
     &      rlon.ge.rlon1.and.rlon.le.rlon2)then  
          if(workf(i,j).ne.bad.and.worko(i,j).ne.bad)then
           snum=snum+DYP(j)
           avef=avef+workf(i,j)*DYP(j)
           aveo=aveo+worko(i,j)*DYP(j)
           varf=varf+workf(i,j)*workf(i,j)*DYP(j)
           varo=varo+worko(i,j)*worko(i,j)*DYP(j)
           corl=corl+workf(i,j)*worko(i,j)*DYP(j)
          endif
         endif
        enddo
        enddo
c
        if(snum.gt.0.0.and.
     &     varf.gt.0.0.and.varo.gt.0.0)then
         corl=corl/sqrt(varf*varo)
        else
         corl=bad
        endif
        skill(iz)=corl
        print *,'done ',iz,iset,n,skill(iz) 
       enddo
      enddo
c sort the skills
      do iz=1,memb
       rmin=99.0
       do kk=1,memb
        if(skill(kk).le.rmin)then
         rmin=skill(kk)
         ll=kk
        endif
       enddo
       membskill(iz)=ll 
       sortskill(iz)=skill(ll)
       skill(ll)=99.0
      enddo
      do iz=1,memb
       print *,iz,membskill(iz),sortskill(iz)
       isort=membskill(iz)
       write(51,rec=iz) ((workssn(i,j,isort),i=1,im),j=1,jm)
       write(52,rec=iz) sortskill(iz)
       write(53,'(2i5,f8.2)') iz,isort,sortskill(iz)
      enddo
      write(51,rec=41) worko
c ensemble mean skill 
      do j=1,jm
      do i=1,im
       workf(i,j)=0.0
       workfc(i,j)=0.0
      enddo
      enddo
      do iz=1,memb
       do j=1,jm
       do i=1,im
        if(workssn(i,j,iz).ne.bad) then
          workf(i,j)=workf(i,j)+workssn(i,j,iz)
          workfc(i,j)=workfc(i,j)+1.0
        endif
       enddo
       enddo
      enddo  
      do j=1,jm
      do i=1,im
       if(workfc(i,j).gt.1.0)then
        workf(i,j)=workf(i,j)/workfc(i,j)
       else
        workf(i,j)=bad
       endif 
      enddo
      enddo
      write(51,rec=42) workf 
      corl=0.0
      avef=0.0
      aveo=0.0
      varf=0.0
      varo=0.0
      snum=0.0
      do j=1,jm
      do i=1,im
       rlat=-90.+(j-1)*dlat
       rlon=0.0+(i-1)*dlon
       if(rlat.ge.rlat1.and.rlat.le.rlat2.and.
     &    rlon.ge.rlon1.and.rlon.le.rlon2)then  
        if(workf(i,j).ne.bad.and.worko(i,j).ne.bad)then
         snum=snum+DYP(j)
         avef=avef+workf(i,j)*DYP(j)
         aveo=aveo+worko(i,j)*DYP(j)
         varf=varf+workf(i,j)*workf(i,j)*DYP(j)
         varo=varo+worko(i,j)*worko(i,j)*DYP(j)
         corl=corl+workf(i,j)*worko(i,j)*DYP(j)
        endif
       endif
      enddo
      enddo
      if(snum.gt.0.0.and.
     &   varf.gt.0.0.and.varo.gt.0.0)then
       corl=corl/sqrt(varf*varo)
      else
       corl=bad
      endif
      print *,'ensemble skill ',corl
      write(53,'(f8.2)') 'ensemble mean skill ',corl 
      write(52,rec=41) corl
c
      stop
      end
fEOF
xlf_r -o skl.x skl.f
./skl.x
rm skl.f skl.x

###
###draw bargraph for skills of individual member
###
cat >xy.gs<<EOFgs
'reinit'
'enable print fig.meta'
'set display color white'
'c'
'set font 0'

'open $outfileSkill.ctl'
'set t 1'
'set z 1'
'set x 1'
'set y 1'
'define ens=$varb.1(x=1,y=1,z=41)'
'query define'
say 'skill='result
skillens=subwrd(result,2)
skillens=substr(skillens,1,5)
xmin=2.0
xmax=10.0
ymin=2.0
ymax=7.0

  'set grads off'
  'set grid on'
  'set xlopts 1 5 0.15'
  'set ylopts 1 5 0.15'
trgyy=$tyy
trgmm=$tmm
trgSSN= mmyycsea(trgmm,trgyy)
say 'trgSSN='trgSSN

'set strsiz 0.20'
'set string 4 C 6 0'
xstr=(xmin+xmax)/2
ystr=ymax+0.8
'draw string 'xstr' 'ystr' CFS z200 'trgSSN' skill (20N-90N)'
ystr=ymax+0.4
'draw string 'xstr' 'ystr' 0-m-Lead'

x1=xmin
x2=xmax
y2=ymax
y1=ymin

'set parea  'x1' 'x2' 'y1' 'y2
'set t 1'
'set z 1 40'
'set x 1'
'set y 1'
'set xlint 4'
'set gxout bar'
'set bargap 50'
'set barbase 0.0'
'set xyrev on'
'set ccolor 2'
'set vrange -1.0 1.0'
'd $varb'
'set gxout line'
'set ccolor 4'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'define skill=ens'
'd skill'
'define zero=0'
'set ccolor 1'
'set cmark 0'
'set cthick 3'
'set cstyle 1'
'd zero'

'set strsiz 0.20'
'set string 4 c 6 90'
xstr=x1-0.8
ystr=(y1+y2)/2
'draw string 'xstr' 'ystr' correlation'

'set strsiz 0.20'
xstr=(x1+x2)/2
ystr=y1-0.5
'set string 4 c 6 0'
'draw string 'xstr' 'ystr' model members'

'set strsiz .15'
'set line 2 1 5'
xlo=7+0.3
ylo=y1+0.8
xhi=xlo+0.2
yhi=ylo+0.2
'draw recf 'xlo' 'ylo' 'xhi' 'yhi
'set string 2 L 5 0'
'draw string 'xhi+0.1' 'ylo+0.1' individual member'
'set line 4 1 6'
xl1=xlo
xl2=xlo+0.3
yl1=ylo-0.3
yl2=yl1
'draw line 'xl1' 'yl1' 'xl2' 'yl2
'set string 4 L 5 0'
xstr=xl2+0.2
ystr=yl2
'draw string 'xstr' 'ystr' ensemble mean'

'print'

function mmyycsea(mm,yyyy)
  if(mm=1); sea='DJF'; endif
  if(mm=2); sea='JFM'; endif
  if(mm=3); sea='FMA'; endif
  if(mm=4); sea='MAM'; endif
  if(mm=5); sea='AMJ'; endif
  if(mm=6); sea='MJJ'; endif
  if(mm=7); sea='JJA'; endif
  if(mm=8); sea='JAS'; endif
  if(mm=9); sea='ASO'; endif
  if(mm=01); sea='DJF'; endif
  if(mm=02); sea='JFM'; endif
  if(mm=03); sea='FMA'; endif
  if(mm=04); sea='MAM'; endif
  if(mm=05); sea='AMJ'; endif
  if(mm=06); sea='MJJ'; endif
  if(mm=07); sea='JJA'; endif
  if(mm=08); sea='JAS'; endif
  if(mm=09); sea='ASO'; endif
  if(mm=10); sea='SON'; endif
  if(mm=11); sea='OND'; endif
  if(mm=12); sea='NDJ'; endif
  if(mm<12&mm>1); cyyyy=yyyy; endif
  if(mm=1|mm=01)
   yyyy0=yyyy-1
   cyyyy=yyyy0'/'yyyy
  endif
  if(mm=12)
   yyyy2=yyyy+1
   cyyyy=yyyy'/'yyyy2
  endif
return (sea''cyyyy)

EOFgs

/usrx/local/grads/bin/2.0.a3/xgrads -bl <<EOF
run xy.gs
quit
EOF

/u/wx52ww/bin/meta2gifLM fig.meta ${tyy}${tmm}SSNmean.$varb.CFSsortSkill.gif
/bin/rm xy.gs fig.meta

###
###draw spatial map for members with high & low skills
###
cat >xy.gs<<EOFgs
'reinit'
'enable print fig.meta'
'set display color white'
'c'
'set mproj nps'
'set map 1 1 1'
'set frame off'
'set font 0'

'open $outfileAnom.ctl'
'open $outfileSkill.ctl'
clevs="-90 -75 -60 -45 -30 -15 0 15 30 45 60 75 90"
ccols="49 47 46 45 43 42 70 70 22 23 25 26 27 29"

xmin=1.0
xmax=9.6
ymin=0.8
ymax=7.5
xgap=1.0
ygap=1.0
xlen=(xmax-xmin-xgap)/2
ylen=(ymax-ymin-ygap)/2

  'set grads off'
  'set grid on'
  'set xlopts 1 5 0.15'
  'set ylopts 1 5 0.15'
  'set rgb  80  200 200 200'
  'set rgb  70  255 255 255'
  'run rgbset.gs'
trgyy=$tyy
trgmm=$tmm
trgSSN= mmyycsea(trgmm,trgyy)
say 'trgSSN='trgSSN

'set strsiz 0.18'
'set string 1 C 6 0'
xstr=(xmin+xmax)/2
ystr=8.3
'draw string 'xstr' 'ystr' z200 (m) 'trgSSN

'set t 1' 
'set z 1'
'set x 1'
'set y 1'
'define good=($varb.2(x=1,y=1,z=37)+$varb.2(x=1,y=1,z=38)+$varb.2(x=1,y=1,z=39)+$varb.2(x=1,y=1,z=40))/4'
'define bad=($varb.2(x=1,y=1,z=1)+$varb.2(x=1,y=1,z=2)+$varb.2(x=1,y=1,z=3)+$varb.2(x=1,y=1,z=4))/4'
'define ens=$varb.2(x=1,y=1,z=41)'
'query define'
say 'skill='result
skillgood=subwrd(result,2)
skillgood=substr(skillgood,1,5)
skillbad=subwrd(result,4)
skillbad=substr(skillbad,1,5)
skillens=subwrd(result,6)
skillens=substr(skillens,1,5)

'set dfile 1'
'set z 1'
'set lat 20 90'
'set lon -270 90' 

ic=0
while(ic<2)
ic=ic+1
jc=0
while(jc<2)
jc=jc+1
if(ic=1&jc=1)
'define a=$varb.1(z=41)'
ctitle='Observation'
endif
if(ic=1&jc=2)
'define a=($varb.1(z=1)+$varb.1(z=2)+$varb.1(z=3)+$varb.1(z=4))/4'
ctitle='0-m-Lead lowest(4) skill'
endif
if(ic=2&jc=1)
'define a=$varb.1(z=42)'
ctitle='0-m-Lead ensemble(40)'
endif
if(ic=2&jc=2)
'define a=($varb.1(z=37)+$varb.1(z=38)+$varb.1(z=39)+$varb.1(z=40))/4'
ctitle='0-m-Lead highest(4) skill'
endif

x1=xmin+(ic-1)*(xlen+xgap)
x2=x1+xlen
y2=ymax-(jc-1)*(ylen+ygap)
y1=y2-ylen
'set parea  'x1' 'x2' 'y1' 'y2
'set gxout shaded'
'set clevs 'clevs
'set ccols 'ccols
'd a'

if(ic=2&jc=2)
xmid=5.5
ymid=y1-0.5
'run cbarn.gs.mc 0.6 0 'xmid' 'ymid
endif

'set strsiz 0.15'
'set string 4 c 6 0'
xstr=(x1+x2)/2
ystr=y2+0.2
'draw string 'xstr' 'ystr' 'ctitle
ystr=ystr+0.3
if(ic=1&jc=2);'draw string 'xstr' 'ystr' CFS';endif
if(ic=2);'draw string 'xstr' 'ystr' CFS';endif

'set strsiz 0.15'
xstr=x2-1.0
ystr=y2-0.4
'set string 4 L 5 0'

if(ic=1&jc=2);
cskill=skillbad
'draw string 'xstr' 'ystr+0.2' corl='cskill
endif
if(ic=2&jc=1);
cskill=skillens
'draw string 'xstr' 'ystr+0.2' corl='cskill
endif
if(ic=2&jc=2);
cskill=skillgood
'draw string 'xstr' 'ystr+0.2' corl='cskill
endif

endwhile
endwhile
'print'

function mmyycsea(mm,yyyy)
  if(mm=1); sea='DJF'; endif
  if(mm=2); sea='JFM'; endif
  if(mm=3); sea='FMA'; endif
  if(mm=4); sea='MAM'; endif
  if(mm=5); sea='AMJ'; endif
  if(mm=6); sea='MJJ'; endif
  if(mm=7); sea='JJA'; endif
  if(mm=8); sea='JAS'; endif
  if(mm=9); sea='ASO'; endif
  if(mm=01); sea='DJF'; endif
  if(mm=02); sea='JFM'; endif
  if(mm=03); sea='FMA'; endif
  if(mm=04); sea='MAM'; endif
  if(mm=05); sea='AMJ'; endif
  if(mm=06); sea='MJJ'; endif
  if(mm=07); sea='JJA'; endif
  if(mm=08); sea='JAS'; endif
  if(mm=09); sea='ASO'; endif
  if(mm=10); sea='SON'; endif
  if(mm=11); sea='OND'; endif
  if(mm=12); sea='NDJ'; endif
  if(mm<12&mm>1); cyyyy=yyyy; endif
  if(mm=1|mm=01)
   yyyy0=yyyy-1
   cyyyy=yyyy0'/'yyyy
  endif
  if(mm=12)
   yyyy2=yyyy+1
   cyyyy=yyyy'/'yyyy2
  endif
return (sea''cyyyy)

EOFgs

/usrx/local/grads/bin/2.0.a3/xgrads -bl <<EOF
run xy.gs
quit
EOF

/u/wx52ww/bin/meta2gifLM fig.meta ${tyy}${tmm}SSNmean.$varb.CFSsort.gif
/bin/rm xy.gs fig.meta

