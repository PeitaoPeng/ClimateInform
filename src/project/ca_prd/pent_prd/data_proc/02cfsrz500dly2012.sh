#!/bin/ksh
set -aex

#
# regrid 720x361 to 360x181
#

varbcfs=HGTprs
copygb=/nwprod/util/exec/copygb
wgrib=/usrx/local/grads/bin/wgrib
cnvgrib=/nwprod/util/exec/cnvgrib

workdir=/ptmpp1/wx52cm/cfsrdly 
savedir=/cpc/noscrub/wx52cm/OBS/cfsrZ500dly
if [ ! -d $workdir ] ; then
  mkdir -p $workdir
fi
if [ -s $workdir/* ]; then
/bin/rm -rf $workdir/*
fi
if [ ! -d $savedir ] ; then
  mkdir -p $savedir
fi

cd $workdir

undef=-9999.0
yy=2012
mday=366
xdim=360
ydim=181 
outfileyr=/cpc/noscrub/wx52cm/OBS/cfsrZ500dly/cfsrZ500$yy.gr

cat>dlymean.f<<fEOF
      parameter(im=$xdim,jm=$ydim)
      parameter(undef=$undef)
      real*4 work(im,jm)
c
      open(51,
     &file='$outfileyr',
     &form='unformatted',access='direct',recl=im*jm*4) 
c
      julian=$mday
      do j=1,jm
      do i=1,im
       work(i,j)=undef
      enddo
      enddo
c
      do id=1,julian
       write(51,rec=id) work
      enddo
      print *,'done initiation'
      stop
      end
ccccccccccccccccccccccc  
fEOF
f77 dlymean.f
./a.out
rm dlymean.f a.out

immb=1
imme=11
imm=$immb 
until [ $imm -gt $imme ]; do
mm=$imm
if [ $imm -lt 10 ]; then
mm='0'$imm
fi
dayinmon=`/u/wx52cm/utl/daysInMonth $yy $mm`

cfsrdir=/com/cfs/prod/monthly/cdas.$yy$mm/time
cfsrfile=z500.gdas.$yy$mm

outfilebin=$cfsrfile.360.gr 
if [ -f $cfsrdir/$cfsrfile ]; then
 cp $cfsrdir/$cfsrfile $cfsrfile
 $copygb -x -g3 $cfsrfile $cfsrfile.360
 /u/wx52cm/bin/grib2ctl.pl $cfsrfile.360 > $cfsrfile.360.ctl
 /u/wx52cm/grads/gribmap -0 -i $cfsrfile.360.ctl

cat >grads.gs<<gsEOF
'open $cfsrfile.360.ctl'
'set x 1 $xdim'
'set y 1 $ydim'
'set gxout fwrite'
'set fwrite $outfilebin'
'set t 1'
'set z 1'
nt=1
while(nt<=$dayinmon)
nt1=(nt-1)*4+1
nt2=(nt-1)*4+4
'define z500=ave($varbcfs,t='nt1',t='nt2')'
'd const(z500,$undef,-u)'
nt=nt+1
endwhile
gsEOF
cat >in.dat<< inEOF
reinit
run grads.gs
quit
inEOF
/usrx/local/grads/bin/grads -pb <in.dat
rm grads.gs in.dat

cat>dlymean.f<<fEOF
      parameter(im=$xdim,jm=$ydim)
      parameter(undef=$undef)
      real*4 work(im,jm)
      real*4 workm(im,jm),workc(im,jm) 
      integer*4 mnday(12)
c
      data mnday/31,28,31,30,31,30,31,31,30,31,30,31/
c
      open(11,
     &file='$outfilebin',
     &access='direct',form='unformatted',recl=im*jm*4)
c
      open(51,
     &file='$outfileyr',
     &form='unformatted',access='direct',recl=im*jm*4) 
c
      imm=$mm
      iyy=$yy
      idaymon=$dayinmon

      m004=mod(iyy,4)
      m100=mod(iyy,100)
      m400=mod(iyy,400)
      kleap=0
      if(m004.eq.0) then
       kleap=1
       if(m100.eq.0) then
        kleap=0
        if(m400.eq.0) then
         kleap=1
        end if
       end if
      end if
      maxdd=mnday(imm)
      if(imm.eq.2) maxdd=mnday(imm)+kleap
      if(imm.eq.1) then
       jul0=0
      else
       jul0=0
       do jl=1,imm-1
        mday=mnday(jl)
        if(jl.eq.2) mday=mnday(jl)+kleap
        jul0=jul0+mday
       enddo
      endif
c
      do idd=1,idaymon
       read(11,rec=idd) work
       jul=jul0+idd
       write(51,rec=jul) work
       print *,'done day=',idd,imm,iyy,jul
      enddo
       
      stop
      end
ccccccccccccccccccccccc  
fEOF
f77 dlymean.f
./a.out
rm dlymean.f a.out

fi

imm=`expr $imm + 1`
done
