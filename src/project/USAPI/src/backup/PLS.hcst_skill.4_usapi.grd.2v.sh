#!/bin/sh

set -eaux

#=========================================================
# ANN down scaling for NMME forecasted USAPI T&P 
#=========================================================
lcdir=/cpc/home/wd52pp/project/USAPI/src
tmp=/cpc/consistency/tmp2
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi

datadir1=/cpc/consistency/USAPI/obs
datadir2=/cpc/consistency/NA_prd/nmme
datadir3=/cpc/consistency/USAPI/skill
#
cd $tmp
# 
 for island in Chuuk Guam Kwajalein PagoPago Pohnpei Yap; do
#for island in Chuuk; do

#for curmo in 11; do
for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
#
curyr=2019
model=NMME
tool=pls
varn=2V
varm=tmpsfc
#varm=prate
varo=prec

mode=7  # mode # for sst
#mode=13  # mode # for prate

lastyr=`expr $curyr - 1`
nextyr=`expr $curyr + 1`
nyr=`expr $lastyr - 1981`  # hcst yr #
nyrp1=`expr $nyr + 1`      # hcst_yr + cur_yr

tgtyr=$curyr
if [ $curmo = 12 ]; then tgtyr=$nextyr; fi
#
nleadmon=7
nleadss=7
imx=360
jmx=181
undef=-9.99E+8
#
# have input data to ANN package =======================================
#
imon=$curmo
if [ $imon = 01 ]; then icmonw=jan; tmons=feb; fi
if [ $imon = 02 ]; then icmonw=feb; tmons=mar; fi
if [ $imon = 03 ]; then icmonw=mar; tmons=apr; fi
if [ $imon = 04 ]; then icmonw=apr; tmons=may; fi
if [ $imon = 05 ]; then icmonw=may; tmons=jun; fi
if [ $imon = 06 ]; then icmonw=jun; tmons=jul; fi
if [ $imon = 07 ]; then icmonw=jul; tmons=aug; fi
if [ $imon = 08 ]; then icmonw=aug; tmons=sep; fi
if [ $imon = 09 ]; then icmonw=sep; tmons=oct; fi
if [ $imon = 10 ]; then icmonw=oct; tmons=nov; fi
if [ $imon = 11 ]; then icmonw=nov; tmons=dec; fi
if [ $imon = 12 ]; then icmonw=dec; tmons=jan; fi
#
#for tp in mon ss; do
 for tp in ss; do
#for tp in mon; do

if [ $tp = 'mon' ]; then nlead=$nleadmon; fi
if [ $tp = 'ss' ];  then nlead=$nleadss; fi

tlongobs=`expr $nyrp1 \* $nlead`  # 

ld=1
while  [ $ld -le $nlead ]
do
#
# calculate input data
#
cp $lcdir/pls_diag.s.f pls_diag.s.f
#
cat > parm.h << eof
       parameter(nt=$nyr)
       parameter(im=$imx,jm=$jmx)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(undef=$undef)
eof
#
cat > input.f << EOF
      program input_data
      include "parm.h"
      dimension ots(nt)
      dimension w2d(im,jm),w3d(im,jm,nt)
      dimension land(im,jm)
C
      dimension xlat(jm),coslat(jm),cosr(jm)
C
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=20,form='unformatted',access='direct',recl=4*im*jm)
C
      open(unit=30,form='unformatted',access='direct',recl=4)
      open(unit=40,form='unformatted',access='direct',recl=4*im*jm)
c*************************************************
C
C== have coslat
C
      do j=1,jm
        xlat(j)=-90+(j-1)*1.
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))  !for EOF use
      enddo
C
C read model sst & obs nino34

      irm=ld
      iro=nld+ld
      do it=1,nt

        read(10,rec=iro) ots(it)   !obs island data
        read(20,rec=irm) w2d       !model hcst sst

        do i=1,im
        do j=1,jm
           w3d(i,j,it)=w2d(i,j)
        enddo
        enddo
c     print *, ' w3d(180,90,it)=',w3d(180,90,it)

        print *, 'iro=',iro
        iro=iro+nld
        irm=irm+nld
      enddo ! it loop
      print *, ' ots=',ots
c
C assign undef
      do it=1,nt
        do i=1,im
        do j=1,jm
          if(abs(w3d(i,j,1)).ge.1000) then
          w3d(i,j,it)=undef
          endif
        enddo
        enddo
c     print *, ' w3d(180,90,it)=',w3d(180,90,it)
      enddo
c
C write out grid data and obs
      do it=1,nt
        do i=1,im
        do j=1,jm
          w2d(i,j)=w3d(i,j,it)
        enddo
        enddo
        write(30,rec=it) ots(it)
        write(40,rec=it) w2d
c     print *, ' w2d(181,91)=',w2d(181,91)
      enddo
c
      stop
      end
EOF
#
\rm fort.*
 gfortran -o input.x input.f
 ln -s $datadir1/$island.$varo.$tp.${icmonw}_ic.1981-2018.ld1-$nlead.anom.gr fort.10
 ln -s $datadir2/$model.$varm.$tp.${icmonw}_ic.1982-2020.ld1-$nlead.esm.anom.gr fort.20
 ln -s ots.ld$ld.gr              fort.30
 ln -s $varm.ld$ld.gr            fort.40
 input.x
#
#
cat>ots.ld$ld.ctl<<EOF
dset ^ots.ld$ld.gr
undef $undef
title EXP1
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars  1
o  0 99 model and obs
endvars
#
EOF
#
cat>$varm.ld$ld.ctl<<EOF
dset ^$varm.ld$ld.gr
undef $undef
title EXP1
XDEF 360 LINEAR    0. 1.
YDEF 181 LINEAR  -90. 1.
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars  1
f  0 99 model and obs
endvars
#
EOF
#
##=====================================
## use field data to down scale USAPI hindcast
##=====================================
#
#\rm fort.*
cp $lcdir/pls_hcst.s.f pls_hcst.s.f
cp $lcdir/pls_diag.s.f pls_diag.s.f
#
infile1=ots.ld$ld.gr
infile2=$varm.ld$ld.gr

outfile1=$island.${varo}_$varm.${icmonw}_ic.ld$ld.ts
outfile2=$island.${varo}_$varm.${icmonw}_ic.ld$ld.pat
outfile3=pls.ld$ld
outfile4=$island.${varo}_$varm.${icmonw}_ic.ld$ld.diag.ts
outfile5=$island.${varo}_$varm.${icmonw}_ic.ld$ld.diag.pat
#
cat > parm.h2 << eof
      parameter(nyr=$nyr)
      parameter(im=$imx,jm=$jmx)
      parameter(is=41,ie=280,js=71,je=110) 
c     parameter(is=41,ie=220,js=71,je=110)
      parameter(undef=-9.99E+8)
      parameter(mode=$mode)
      parameter(ID=1) !ID=1 -> standardize
eof
#
cat>pls.f<<EOF
      include "parm.h2"
c
      real*4 ots(nyr),f1(nyr),f2(nyr)
      real*4 w2d(im,jm),w2d2(im,jm)
      real*4 w3din(im,jm,nyr),wic(im,jm)
      real*4 xlat(jm),cosl(jm)
      real*4 pc(nyr-1,mode),pat(im,jm,mode),pat2(im,jm,mode)
      real*4 var(mode),corr(mode),pcprd(nyr),pco(mode)
      real*4 w1d(nyr-1),w1d2(nyr-1),w3d(im,jm,nyr-1)
      real*4 vart(nyr),avg(nyr)
      real*4 pcd(nyr,mode)
c
c sst data
      open(11,
     1file='$infile1',
     2access='direct',form='unformatted',recl=4)
      open(12,
     1file='$infile2',
     2access='direct',form='unformatted',recl=im*jm*4)
c
      open(21,
     1file='$outfile1.gr',
     2access='direct',form='unformatted',recl=4)
      open(22,
     1file='$outfile2.gr',
     2access='direct',form='unformatted',recl=im*jm*4)
      open(23,
     1file='$outfile3.bi',
     2access='direct',form='unformatted',recl=4)
      open(24,
     1file='$outfile4.gr',
     2access='direct',form='unformatted',recl=4)
      open(25,
     1file='$outfile5.gr',
     2access='direct',form='unformatted',recl=im*jm*4)
 
      PI=4.*atan(1.)
      CONV=PI/180.
      do j=1,jm
        xlat(j)=-90+(j-1)*1.
      enddo

      do j=1,jm
        cosl(j)=COS(xlat(j)*CONV)
      enddo
c
c read in data
      write(6,*) 'read in data'
c
      do iy=1,nyr
        read(11,rec=iy) ots(iy)
        read(12,rec=iy) w2d
        do i=1,im
        do j=1,jm
          w3din(i,j,iy)=w2d(i,j)
        enddo
        enddo
c     print *, ' ots(iy)=',ots(iy)
c     print *, ' w2d(181,91)=',w2d(181,91)
      enddo
c
c hcst start
      DO ity=1,nyr

        it=0
        do iy=1,nyr

        if(iy.eq.ity) go to 100
        it=it+1
          w1d(it)=ots(iy)
        do i=1,im
        do j=1,jm
          w3d(i,j,it)=w3din(i,j,iy)
        enddo
        enddo

100     continue
        enddo !iy loop

        do i=1,im
        do j=1,jm
          wic(i,j)=w3din(i,j,ity)
        enddo
        enddo

      call anom(w1d,nyr-1,av)
      avg(ity)=av
c
c anom input data w3d
      do i=1,im
      do j=1,jm
        if(abs(w3d(i,j,1)).lt.999) then

        do iy=1,nyr-1
          w1d2(iy)=w3d(i,j,iy)
        enddo

        call anom(w1d2,nyr-1,av)
        do iy=1,nyr-1
          w3d(i,j,iy)=w1d2(iy)
        enddo

        wic(i,j)=wic(i,j)-av

        endif
      enddo
      enddo

      call pls_hcst(nyr-1,im,jm,is,ie,js,je,mode,
     &w1d,w3d,wic,pc,pco,pat,pat2,var,cosl,undef,ID)
c
      print *, ' var(m)=',var
c
c compose pcprd for targetyr
      pcprd(ity)=0.
      vart(ity)=0.
      do m=1,mode
        pcprd(ity)=pcprd(ity)+pco(m)
        vart(ity)=vart(ity)+var(m)
      enddo
c
      ENDDO !ity loop
c
      print *, ' vart=',vart
c
c cor and explained variance
        call cor_reg(nyr,pcprd,ots,cort,reg)
c
      vartot=cort*cort
      write(6,*) 'vartot=',vartot
      write(6,*) 'cor=',cort
c write out
      iw=0
      do it=1,nyr
        iw=iw+1
        write(21,rec=iw) ots(it)
        iw=iw+1
        write(21,rec=iw) pcprd(it)
c
        write(23,rec=it) pcprd(it)
      enddo
c
c diagnostic PLS for having ts and patterns
c
      call anom(ots,nyr,av)
 
c anom input data w3d
      do i=1,im
      do j=1,jm

        if(abs(w3din(i,j,1)).lt.999) then

        do it=1,nyr
          f1(it)=w3din(i,j,it)
        enddo

        call anom(f1,nyr,av)

        do it=1,nyr
          w3d(i,j,it)=f1(it)
        enddo
        endif
      enddo
      enddo

      call pls_diag(nyr,im,jm,is,ie,js,je,mode,
     &ots,w3d,pcd,pat,pat2,var,cosl,undef,ID)
c
      print *, ' diag var(m)=',var
c
c compose pcprd for targetyr
      do iy=1,nyr
      pcprd(iy)=0.
      vart(iy)=0.
      do m=1,mode
        pcprd(iy)=pcprd(iy)+pcd(iy,m)
        vart(iy)=vart(iy)+var(m)
      enddo
      enddo !iy loop
c
c cor and explained variance
        call cor_reg(nyr,pcprd,ots,cort,reg)
c
      vartot=cort*cort
      write(6,*) 'diag vartot=',vartot
      write(6,*) 'diag cor=',cort
c
c write out diag ts
      iw=0
      do it=1,nyr
        iw=iw+1
        write(24,rec=iw) ots(it)

        do m=1,mode
        iw=iw+1
        write(24,rec=iw) pcd(it,m)
        enddo

        iw=iw+1
        write(24,rec=iw) pcprd(it)
      enddo
c write out diag patterns
      do m=1,mode
        do i=1,im
        do j=1,jm
          w2d(i,j)=pat2(i,j,m)
        enddo
        enddo
        write(25,rec=m) w2d
      enddo
c
      stop
      end
c
c========================
      subroutine anom(ts,nt,avg)
      dimension ts(nt)
        av=0
        do i=1,nt
          av=av+ts(i)
        end do
        avg=av/float(nt)
        do i=1,nt
          ts(i)=ts(i)-avg
        end do
      return
      end
ccccccccccccccccccccccc
EOF
#
 gfortran -o pls.x pls_diag.s.f pls_hcst.s.f pls.f
#
 pls.x
#
cat>pls.ld$ld.ctl<<EOF
dset ^pls.ld$ld.bi
undef -9.99E+33
title EXP1
XDEF  1 LINEAR    0  1.0
YDEF  1 LINEAR  -90  1.0
zdef  1 linear 1 1
tdef  $nyr linear jan1982 1yr
vars  1
p  0 99 prd
endvars
#
EOF
cat>$outfile1.ctl<<EOF
dset ^$outfile1.gr
undef $undef
*
TITLE pls time series
*
xdef  1 linear   0  1.
ydef  1 linear -90  1.0
zdef  1 linear 1 1
tdef $nyr linear jan1982 1yr
vars 2
o  1 99 ts of obs
p  1 99 ts of pls
ENDVARS
EOF
#
cat>$outfile4.ctl<<EOF
dset ^$outfile4.gr
undef $undef
*
TITLE pls time series
*
xdef  1 linear   0  1.
ydef  1 linear -90  1.0
zdef  1 linear 1 1
tdef $nyr linear jan1982 1yr
vars 9
o   1 99 ts of obs
f1  1 99 ts of pls
f2  1 99 ts of pls
f3  1 99 ts of pls
f4  1 99 ts of pls
f5  1 99 ts of pls
f6  1 99 ts of pls
f7  1 99 ts of pls
ft  1 99 ts of sum1-6
ENDVARS
EOF
#
cat>$outfile5.ctl<<EOF
dset ^$outfile5.gr
undef $undef
title EXP1
XDEF 360 LINEAR    0. 1.
YDEF 181 LINEAR  -90. 1.
zdef 1 linear 1 1
tdef $mode linear jan1982 1yr
vars  1
p  0 99 cor pat of pls
endvars
EOF
#
# have obs of 1982-2019
#
cat >obsindex<<EOF
run verification.gs
EOF
cat >verification.gs<<EOF
'reinit'
'open $datadir1/$island.$varo.$tp.${icmonw}_ic.1981-2018.ld1-$nlead.anom.ctl'
'set gxout fwrite'
'set fwrite obs.ld$ld.gr'
'set x 1'
'set y 1'
it=$nlead+$ld
while ( it <= $tlongobs)
'set t 'it''
'd o'
it=it+$nlead
endwhile
EOF
#
/usr/local/bin/grads -bl < obsindex
#
cat>obs.ld$ld.ctl<<EOF
dset ^obs.ld$ld.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars 1
o 1 99 obs
ENDVARS
EOF
#
# calculate HSS skill
#
#=======================================
# hss calculation for 2012-last_year
#=======================================
infile1=obs.ld$ld
infile2=pls.ld$ld
outfile=skill.$ld
cat >have.hss.f<<EOF
      parameter(nvy=$nyr)
c
      real*4 obs(nvy),fcst(nvy,2),f1d(nvy)
      real*4 obs2(nvy),f1d2(nvy)
      real*4 rdo(nvy),rdm(nvy)
      dimension mo(nvy),mf(nvy)
c
      open(11,
     &file='$infile1.gr',
     &access='direct',form='unformatted',recl=4)
      open(12,
     &file='$infile2.bi',
     &access='direct',form='unformatted',recl=4)
C
      open(20,
     &file='$outfile',
     &access='direct',form='unformatted',recl=4)

c read in f&o data

      do iy=1,nvy
      read(11,rec=iy) obs(iy)
      read(12,rec=iy) f1d(iy)
      enddo
      call acrms_t(f1d,obs,acc,rms,nvy)

c normalization

      call normal(obs,nvy)
      call normal(f1d,nvy)

      bl=-0.43
      bh= 0.43
c
c convert to categorical numbe -1 0 -1

      do iy=1,nvy

       if (f1d(iy).lt.bl) mf(iy)=-1
       if (f1d(iy).gt.bh) mf(iy)= 1
       if (f1d(iy).le.bh.and.f1d(iy).ge.bl)
     & mf(iy)=0

       if (obs(iy).lt.bl) mo(iy)=-1
       if (obs(iy).gt.bh) mo(iy)= 1
       if (obs(iy).le.bh.and.obs(iy).ge.bl)
     & mo(iy)=0

      enddo

c have hss
      call hss_t(mf,mo,hss,nvy)

      iw=1
      write(20,rec=iw) hss
      iw=iw+1
      write(20,rec=iw) acc
      iw=iw+1
      write(20,rec=iw) rms

      print *,"acc=",acc
      print *,"hss=",hss

      STOP
      END
c
      subroutine normal(x,n)
      dimension x(n)
      avg=0
      do i=1,n
        avg=avg+x(i)/float(n)
      enddo
      var=0
      do i=1,n
        var=var+(x(i)-avg)*(x(i)-avg)/float(n)
      enddo
      std=sqrt(var)
      do i=1,n
        x(i)=(x(i)-avg)/std
      enddo
      return
      end
C
      subroutine hss_t(mw1,mw2,hs,n)
      dimension mw1(n),mw2(n)

      h=0.
      do i=1,n
        if (mw1(i).eq.mw2(i)) h=h+1
      enddo
      tot=float(n)
      hs=100.*(h-tot/3.)/(tot-tot/3.)
      return
      end
c
      subroutine acrms_t(f,o,ac,rms,n)
      dimension f(n),o(n)

      rms=0
      oo=0.
      ff=0.
      fo=0.
      do i=1,n
        oo=oo+o(i)*o(i)
        ff=ff+f(i)*f(i)
        fo=fo+f(i)*o(i)
        rms=rms+(f(i)-o(i))*(f(i)-o(i))
      enddo
      tot=float(n)
      stdo=sqrt(oo)
      stdf=sqrt(ff)
      ac=fo/(stdo*stdf)
      rms=sqrt(rms/tot)
c
      return
      end
c
      SUBROUTINE hpsort(n,n2,ra,rb)
      INTEGER n,n2
      REAL ra(n),rb(n)
      INTEGER i,ir,j,l
      REAL rra
      if (n2.lt.2) return
      l=n2/2+1
      ir=n2
10    continue
        if(l.gt.1)then
          l=l-1
          rra=ra(l)
          rrb=rb(l)
        else
          rra=ra(ir)
          rrb=rb(ir)
          ra(ir)=ra(1)
          rb(ir)=rb(1)
          ir=ir-1
          if(ir.eq.1)then
            ra(1)=rra
            rb(1)=rrb
            return
          endif
        endif
        i=l
        j=l+l
20      if(j.le.ir)then
          if(j.lt.ir)then
            if(ra(j).lt.ra(j+1))j=j+1
          endif
          if(rra.lt.ra(j))then
            ra(i)=ra(j)
            rb(i)=rb(j)
            i=j
            j=j+j
          else
            j=ir+1
          endif
        goto 20
        endif
        ra(i)=rra
        rb(i)=rrb
      goto 10
      END
EOF
#
gfortran -o hss.x have.hss.f
echo "done compiling"
./hss.x > $tmp/hssout.pls.$ld
#./hss.x 
#
ld=$(( ld+1 ))
done  # for ld

#cat skill together

cp skill.1 sk.$curmo # ld-1 for later cat
cp skill.1 hss.1
ld=2
while  [ $ld -le $nlead ]
do
ldm=$((ld-1))

cat hss.$ldm  skill.$ld > hss.$ld

\rm hss.$ldm
\rm skill.$ldm

ld=$(( ld+1 ))
done  # for ld
\rm skill.$nlead
#
mv hss.$nlead $datadir3/skill.$tool.$varn.NMME_${varm}_2_${island}_$varo.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.gr

cat>$datadir3/skill.$tool.$varn.NMME_${varm}_2_${island}_$varo.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.ctl<<EOF
dset ^skill.$tool.$varn.NMME_${varm}_2_${island}_$varo.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nlead linear ${tmons}1982 1mon
vars 3
hssp  1 99 hss of pls
accp  1 99 acc of pls
rmsp  1 99 rms of pls
ENDVARS
EOF

done  # for tp
done  # for curmo
cat sk.12 sk.01 sk.02 sk.03 sk.04 sk.05 sk.06 sk.07 sk.08 sk.09 sk.10 sk.11 > sk.tot
mv sk.tot $datadir3/skill.$tool.$varn.NMME_${varm}_2_${island}_$varo.$tp.1982-$lastyr.ld-1.gr
\rm sk.*
#
cat>$datadir3/skill.$tool.$varn.NMME_${varm}_2_${island}_$varo.$tp.1982-$lastyr.ld-1.ctl<<EOF
dset ^skill.$tool.$varn.NMME_${varm}_2_${island}_$varo.$tp.1982-$lastyr.ld-1.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef 12 linear jan1982 1mon
vars 3
hss  1 99 hss of nmme
acc  1 99 acc of nmme
rms  1 99 rms of nmme
ENDVARS
EOF
#
done  # for island
