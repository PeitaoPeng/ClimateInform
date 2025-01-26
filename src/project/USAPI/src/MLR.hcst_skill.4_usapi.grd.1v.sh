#!/bin/sh

set -eaux

#=========================================================
# ANN down scaling for NMME forecasted USAPI T&P 
#=========================================================
lcdir=/cpc/home/wd52pp/project/USAPI/src
tmp=/cpc/consistency/tmp_ann
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
tool=mlr
varn=1V
varm=prate
varo=prec

lastyr=`expr $curyr - 1`
nextyr=`expr $curyr + 1`
nyr=`expr $lastyr - 1981`  # hcst yr #
nyrp1=`expr $nyr + 1`      # hcst_yr + cur_yr

tgtyr=$curyr
if [ $curmo = 12 ]; then tgtyr=$nextyr; fi
#
ngrd=4
nmod=$ngrd
nfld=`expr $nmod + 1` # +1 for putting obs nino34
nleadmon=7
nleadss=7
imx=360
jmx=181
#
# give lon&lat closest to island
#
if [ $island = "Chuuk" ];     then is=152;ie=153;js=98;je=99;ix=153;jy=98;fi
if [ $island = "Yap" ];       then is=139;ie=140;js=100;je=101;ix=139;jy=100;fi
if [ $island = "Pohnpei" ];   then is=159;ie=160;js=98;je=99;ix=159;jy=98;fi
if [ $island = "Kwajalein" ]; then is=168;ie=169;js=99;je=100;ix=169;jy=100;fi
if [ $island = "Guam" ];      then is=145;ie=146;js=104;je=105;ix=146;jy=104;fi
if [ $island = "Pago_Pago" ]; then is=190;ie=191;js=76; je=77;ix=190;jy=77; fi
#
# have input data to MLR package =======================================
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
cat > parm.h << eof
       parameter(nt=$nyr)
       parameter(imx=$imx,jmx=$jmx)
       parameter(is=$is,ie=$ie,js=$js,je=$je,ix=$ix,jy=$jy)
       parameter(ngrd=$ngrd,nfld=$nfld)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(undef=-9.99E+8)
eof
#
cat > input.f << EOF
      program input_data
      include "parm.h"
      dimension tso(nt)
      dimension out(nfld)
      dimension w2d(imx,jmx),w3d(imx,jmx,nt)
      dimension wk3d(ngrd,nt)
      dimension land(imx,jmx)
C
      dimension ts1(nt),ts2(nt),ts3(nt)
      real corr(imx,jmx),regr(imx,jmx)
C
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
C
      open(unit=30,form='unformatted',access='direct',recl=4*nfld)
c*************************************************
C
C== have coslat
C
C read model sst & obs nino34

      irm=ld
      iro=nld+ld
      do it=1,nt

        read(10,rec=iro) tso(it)   !obs island data
        read(20,rec=irm) w2d       !model hcst sst

        do i=1,imx
        do j=1,jmx
           w3d(i,j,it)=w2d(i,j)
        enddo
        enddo

        print *, 'iro=',iro
        iro=iro+nld
        irm=irm+nld
      enddo ! it loop
c
C select data from some grids
      do it=1,nt
      ig=0
      do i=is,ie
      do j=js,je
        if(abs(w3d(i,j,it)).lt.1000) then
        ig=ig+1
        wk3d(ig,it)=w3d(i,j,it)
        endif
      enddo
      enddo
      print *, 'ngrd=',ig
      enddo
C
C write out grid var and obs var
      do it=1,nt

        do i=1,ngrd
          out(i)=wk3d(i,it)
        enddo
          out(nfld)=tso(it)

        write(30,rec=it) out
        write(6,*) out
      enddo
C
      stop
      end
EOF
#
\rm fort.*
 gfortran -o input.x input.f
 ln -s $datadir1/$island.$varo.$tp.${icmonw}_ic.1981-2018.ld1-$nlead.anom.gr fort.10
 ln -s $datadir2/$model.$varm.$tp.${icmonw}_ic.1982-2020.ld1-$nlead.esm.anom.gr fort.20
 ln -s input.ld$ld.gr                                               fort.30
 input.x
#
cat>input.ld$ld.ctl<<EOF
dset ^input.ld$ld.gr
undef -9.99E+33
title EXP1
XDEF $nfld LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars  1
f  0 99 model and obs
endvars
#
EOF
##=====================================
## use field data to down scale USAPI hindcast
##=====================================
#
#
ridge=0.05
del_ridge=0.05
#
cp $lcdir/mlr.CV.f mlr.f
#
cat > parm.h << eof
       parameter(nt=$nyr)
       parameter(ngrd=$nmod,nfld=$nfld)
       parameter(ridge=$ridge,del=$del_ridge)
eof
#
\rm fort.*
#
 gfortran -o mlr.x mlr.f
#
#
 ln -s input.ld$ld.gr    fort.10
 ln -s mlr.ld$ld.bi  fort.20
 mlr.x
#
cat>mlr.ld$ld.ctl<<EOF
dset ^mlr.ld$ld.bi
undef -9.99E+33
title EXP1
XDEF  1 LINEAR    0  2.5
YDEF  1 LINEAR  -90  2.5
zdef  1 linear 1 1
tdef  $nyr linear jan1982 1yr
vars  1
p  0 99 prd
endvars
#
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
# have NMME model fcst surounding the island
#
cat >nmmefcst<<EOF
run nmme.gs
EOF
cat >nmme.gs<<EOF
'reinit'
'open input.ld$ld.ctl'
'set gxout fwrite'
'set fwrite nmme.ld$ld.gr'
'set x 1'
'set y 1'
it=1
while ( it <= $nyr)
'set t 'it''
'd ave(f,x=1,x=$ngrd)'
it=it+1
endwhile
EOF
#
/usr/local/bin/grads -bl < nmmefcst
#
cat>nmme.ld$ld.ctl<<EOF
dset ^nmme.ld$ld.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars 1
m 1 99 obs
ENDVARS
EOF
#
# calculate HSS skill
#
#=======================================
# hss calculation for 2012-last_year
#=======================================
infile1=obs.ld$ld
infile2=mlr.ld$ld
infile3=nmme.ld$ld
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
      open(13,
     &file='$infile3.gr',
     &access='direct',form='unformatted',recl=4)
C
      open(20,
     &file='$outfile',
     &access='direct',form='unformatted',recl=4)

c read in f&o data

      do iy=1,nvy
      read(11,rec=iy) obs(iy)
      read(12,rec=iy) fcst(iy,1)
      read(13,rec=iy) fcst(iy,2)
      enddo

      iw=0
      do iv=1,2

        do iy=1,nvy
        f1d(iy)=fcst(iy,iv)
        enddo

      call acrms_t(f1d,obs,acc,rms,nvy)

      call normal(obs,nvy)
      call normal(f1d,nvy)

      bl=-0.43
      bh= 0.43

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

      iw=iw+1
      write(20,rec=iw) hss
      iw=iw+1
      write(20,rec=iw) acc
      iw=iw+1
      write(20,rec=iw) rms

      print *,"iv=",iv
      print *,"acc=",acc
      print *,"rms=",rms
      print *,"hss=",hss

      enddo ! iv loop
c     print *,"obs=",obs

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
c
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
./hss.x > $tmp/hssout.mlr.grd.$ld
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
vars 6
hssp  1 99 hss of ann
accp  1 99 acc of ann
rmsp  1 99 rms of ann
hssm  1 99 hss of nmme
accm  1 99 acc of nmme
rmsm  1 99 rms of nmme
ENDVARS
EOF

done  # for tp
done  # for curmo
#
cat sk.12 sk.01 sk.02 sk.03 sk.04 sk.05 sk.06 sk.07 sk.08 sk.09 sk.10 sk.11 > sk.tot
mv sk.tot $datadir3/skill.$tool.grd.$varn.NMME_${varm}_2_${island}_$varo.$tp.1982-$lastyr.ld-1.gr
\rm sk.*
#
cat>$datadir3/skill.$tool.grd.$varn.NMME_${varm}_2_${island}_$varo.$tp.1982-$lastyr.ld-1.ctl<<EOF
dset ^skill.$tool.grd.$varn.NMME_${varm}_2_${island}_$varo.$tp.1982-$lastyr.ld-1.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef 12 linear jan1982 1mon
vars 6
hssp  1 99 hss of ann
accp  1 99 acc of ann
rmsp  1 99 rms of ann
hssm  1 99 hss of nmme
accm  1 99 acc of nmme
rmsm  1 99 rms of nmme
ENDVARS
EOF
#
done  # for island
