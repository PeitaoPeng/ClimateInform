#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/wk34/opr
tmpdir=/cpc/home/wd52pp/tmp/opr
if [ ! -d $tmpdir ] ; then
  mkdir -p $tmpdir
fi
bindir=/cpc/home/wd52pp/bin
#
# IC date and week#
YEAR=`date --date='2 day ago' '+%Y'`
MONTH=`date --date='2 day ago' '+%m'`
DAY=`date --date='2 day ago' '+%d'`
idate=$YEAR/$MONTH/$DAY
jday=`date -d $idate +%j`
if [ $jday -le 7 ]; then jday=7; fi
iweek=`expr $jday / 7`
#
#forecast date
fy4=`date --date='today' '+%Y'`
fm2=`date --date='today' '+%m'`
fd2=`date --date='today' '+%d'`
#
if [ $fm2 = 01 ]; then icmon=jan; fi
if [ $fm2 = 02 ]; then icmon=feb; fi
if [ $fm2 = 03 ]; then icmon=mar; fi
if [ $fm2 = 04 ]; then icmon=apr; fi
if [ $fm2 = 05 ]; then icmon=may; fi
if [ $fm2 = 06 ]; then icmon=jun; fi
if [ $fm2 = 07 ]; then icmon=jul; fi
if [ $fm2 = 08 ]; then icmon=aug; fi
if [ $fm2 = 09 ]; then icmon=sep; fi
if [ $fm2 = 10 ]; then icmon=oct; fi
if [ $fm2 = 11 ]; then icmon=nov; fi
if [ $fm2 = 12 ]; then icmon=dec; fi
#
ddmmyy=$fd2$icmon$fy4
cd $tmpdir
#
modemax=35
im=144
jm=73
#
for var in sat prcp z500; do
#
cat >ens_mean<<EOF
run esm.gs
EOF
#
cat >esm.gs<<EOF
'reinit'
'open $tmpdir/ca_${var}_wk34.1ics.35.ctl'
*'open $tmpdir/ca_${var}_wk34.2ics.35.ctl'
*'open $tmpdir/ca_${var}_wk34.3ics.35.ctl'
'open $tmpdir/ca_${var}_wk34.4ics.35.ctl'
'set gxout fwrite'
'set fwrite esmavg.gr'
'set x 1 $im'
'set y 1 $jm'
'd (w34+w34.2)/2'
'd (ocn+ocn.2)/2'
'd (wk2+wk2.2)/2'
'd (wk3+wk3.2)/2'
'd (wk4+wk4.2)/2'
'd (prd+prd.2)/2'
'd (prb+prb.2)/2'
'd (trd+trd.2)/2'
'd (hss+hss.2)/2'
'd (pic+pic.2)/2'
'd (ostd+ostd.2)/2'
'd (pstd+pstd.2)/2'
'c'
EOF

/usr/local/bin/grads -bl <ens_mean

cat>$tmpdir/esmavg.ctl<<EOF
dset ^esmavg.gr
undef -9.99E+8
title prcp unit=0.1mm/day
xdef  $im linear   0 2.5
ydef  $jm linear  -90 2.5
zdef   1 levels 500
tdef   1 linear $ddmmyy 1dy
vars  12
w34   1 99 psi based wk34
ocn   1 99 OCN prd
wk2   1 99 psi-based + trd
wk3   1 99 psi-based + trd
wk4   1 99 psi-based + trd
prd   1 99 wk34 + trd
prb   1 99 prob format of prd
trd   1 99 trend per year
hss   1 99 HSS_2c
pic   1 99 psi ic
ostd 1 99 obs std
pstd 1 99 prd std
endvars
EOF

infile=esmavg
outfile=ca_${var}_wk34
undef=-9.99E+8

cat>probfcst.f<<EOF
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C probabilistic fcst from ensemble mean and stdv
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      parameter(im=$im,jm=$jm)
      parameter(kpdf=100)  ! # of pdf bin
      parameter(undef=$undef)
c
      dimension wk34(im,jm),wk2(im,jm),wk3(im,jm),wk4(im,jm)
      dimension prd(im,jm),prb(im,jm),trd(im,jm),hss(im,jm)
      dimension wk(im,jm),ocn(im,jm),pic(im,jm)
      dimension ostd(im,jm),pstd(im,jm)
      dimension prbprd(im,jm),esmprd(im,jm)
      dimension xbin(kpdf),ypdf(kpdf),esmprb(im,jm)
      open(10,
     &file='$infile.gr',
     &access='direct',form='unformatted',recl=im*jm*4)
      open(20,
     &file='$outfile.bin3',
     &access='direct',form='unformatted',recl=im*jm*4)
c read infile
      read(10,rec=1) wk34
      read(10,rec=2) ocn
      read(10,rec=3) wk2
      read(10,rec=4) wk3
      read(10,rec=5) wk4
      read(10,rec=6) prd
      read(10,rec=7) prb
      read(10,rec=8) trd
      read(10,rec=9) hss
      read(10,rec=10) pic
      read(10,rec=11) ostd
      read(10,rec=12) pstd

      do i=1,im
      do j=1,jm
        wk(i,j)=prd(i,j)/ostd(i,j)
      enddo
      enddo
c have prob forecast
      xdel=10./float(kpdf)
      call pdf_tab(xbin,ypdf,xdel,kpdf)
c
      do i=1,im
      do j=1,jm
        if(abs(ostd(i,j)).lt.100) then
        call prob(wk(i,j),kpdf,xbin,xdel,ypdf,pp,pn)
        if(wk(i,j).gt.0) then
        esmprb(i,j)=pp
        else
        esmprb(i,j)=-pn
        endif
        else
        esmprb(i,j)=undef
        endif
      enddo
      enddo
c
      write(20,rec=1) wk34
      write(20,rec=2) ocn
      write(20,rec=3) wk2
      write(20,rec=4) wk3
      write(20,rec=5) wk4
      write(20,rec=6) prd
      write(20,rec=7) esmprb
      write(20,rec=8) trd
      write(20,rec=9) hss
      write(20,rec=10) pic
      write(20,rec=11) ostd
      write(20,rec=12) pstd
c
      stop
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  calculate normal distribution PDF from -5 to 5 (unit=std)
C  have it as a table for later integration
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine pdf_tab(xx,yy,xde,n)
      real xx(n),yy(n)
      pi=3.14159
      coef=1./sqrt(2*pi)
      xde=0.1
      xx(1)=-5+xde/2
      do i=2,n
      xx(i)= xx(i-1)+xde
      enddo
      do i=1,n
      yy(i)=coef*exp(-xx(i)*xx(i)/2)
      enddo
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  Have prob by integratinge PDF
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine prob(x1,n,xx,xde,yy,pp,pn)
      real xx(n),yy(n)
      if(x1.gt.0) then
      x2=0-x1
      else
      x2=abs(x1)
      endif
      pn=0
      do i=1,n
      if(xx(i).gt.x2) go to 111
      pn=pn+xde*yy(i)
      enddo
  111 continue
      pp=1-pn
      return
      end
EOF
gfortran -o probfcst.x probfcst.f
echo "done compiling"
#./probfcst.x > $lcdir/out
./probfcst.x 

cat>$tmpdir/$outfile.ctl3<<EOF
dset ^$outfile.bin3
undef $undef
title prcp unit=0.1mm/day
xdef  $im linear   0 2.5
ydef  $jm linear  -90 2.5
zdef   1 levels 500
tdef   1 linear $ddmmyy 1dy
vars  12
w34   1 99 psi based wk34
ocn   1 99 OCN prd
wk2   1 99 psi-based + trd
wk3   1 99 psi-based + trd
wk4   1 99 psi-based + trd
prd   1 99 wk34 + trd
prb   1 99 prob format of prd
trd   1 99 trend per year
hss   1 99 HSS_2c
pic   1 99 psi ic
ostd 1 99 obs std
pstd 1 99 prd std
endvars
EOF

cp $tmpdir/$outfile.ctl3 /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4/$fm2/$fd2
cp $tmpdir/$outfile.bin3 /cpc/home/wd52pp/data/wk34_fcst/ca/$fy4/$fm2/$fd2

done
