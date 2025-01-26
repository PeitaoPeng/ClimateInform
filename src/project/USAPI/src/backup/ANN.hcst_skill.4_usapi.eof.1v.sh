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
tool=ann
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
ngrd=9600
#ngrd=50
nmod=10
nfld=`expr $nmod + 1` # +1 for putting obs nino34
nleadmon=7
nleadss=7
imx=360
jmx=181
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
cat > parm.h << eof
       parameter(nt=$nyr)
       parameter(imx=$imx,jmx=$jmx)
       parameter(is=41,ie=280,js=71,je=110) 
c      parameter(is=146,ie=155,js=96,je=100)
       parameter(ngrd=$ngrd,nmod=$nmod,nfld=$nfld)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(undef=-9.99E+8)
eof
#
cat > input.f << EOF
      program input_data
      include "parm.h"
      dimension ots(nt)
      dimension out(nfld)
      dimension w2d(imx,jmx),w3d(imx,jmx,nt)
      dimension land(imx,jmx)
C
      dimension ts1(nt),ts2(nt),ts3(nt)
      dimension aaa(ngrd,nt),wk(nt,ngrd)
      dimension xlat(jmx),coslat(jmx),cosr(jmx)
      dimension eval(nt),evec(ngrd,nt),coef(nt,nt)
      real weval(nt),wevec(ngrd,nt),wcoef(nt,nt)
      real reval(nmod),revec(ngrd,nmod),rcoef(nmod,nt)
      real tt(nmod,nmod),rwk(ngrd),rwk2(ngrd,nmod)
      real corr(imx,jmx),regr(imx,jmx)

C
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
C
      open(unit=30,form='unformatted',access='direct',recl=4*nfld)
      open(unit=40,form='unformatted',access='direct',recl=4*imx*jmx)
c*************************************************
C
C== have coslat
C
      do j=1,jmx
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

        do i=1,imx
        do j=1,jmx
           w3d(i,j,it)=w2d(i,j)
        enddo
        enddo

        print *, 'iro=',iro
        iro=iro+nld
        irm=irm+nld
      enddo ! it loop
      print *, '1 ots=',ots
c
C assign undef
      do it=1,nt
        do i=1,imx
        do j=1,jmx
          if(abs(w2d(i,j)).ge.1000) then
          w3d(i,j,it)=undef
          endif
        enddo
        enddo
      enddo
c
C select grid data
      do it=1,nt
      ig=0
      do i=is,ie
      do j=js,je
        if(abs(w3d(i,j,it)).lt.1000) then
        ig=ig+1
        aaa(ig,it)=w3d(i,j,it)
        endif
      enddo
      enddo
      print *, 'ngrd=',ig
      enddo
      print *, '2 ots=',ots
C EOF analysis
      call eofs(aaa,ngrd,nt,nt,eval,evec,coef,wk,id)
      call REOFS(aaa,ngrd,nt,nt,wk,id,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
      print *, 'eval=',eval
      print *, '3 ots=',ots
C
C normalize coef and have patterns
      iw=0
      do m=1,nmod
        do it=1,nt
        ts1(it)=coef(m,it)
        ts2(it)=rcoef(m,it)
        enddo
        call normal(ts1,nt)
        call normal(ts2,nt)

        do it=1,nt
        coef(m,it)=ts1(it)
        rcoef(m,it)=ts2(it)
        enddo
c
        do j=1,jmx
        do i=1,imx

        if(abs(w2d(i,j)).lt.1000) then

        do it=1,nt
        ts3(it)=w3d(i,j,it)
        enddo

        call regr_t(ts2,ts3,nt,corr(i,j),regr(i,j))
        else

        corr(i,j)= -9.99E+8
        regr(i,j)= -9.99E+8
        corr(i,j)= -9.99E+8
        regr(i,j)= -9.99E+8

        endif

        enddo
        enddo

        iw=iw+1
        write(40,rec=iw) corr
        iw=iw+1
        write(40,rec=iw) regr
      enddo
      print *, '4 ots=',ots
C
C write out grid data and obs
      do it=1,nt

        do i=1,nmod
          out(i)=rcoef(i,it)
        enddo
          out(nfld)=ots(it)

        write(30,rec=it) out
        print *, out
      enddo

      stop
      end
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
      SUBROUTINE regr_t(f1,f2,ltime,cor,reg)

      real f1(ltime),f2(ltime)

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,ltime
         cor=cor+f1(it)*f2(it)/float(ltime)
         sd1=sd1+f1(it)*f1(it)/float(ltime)
         sd2=sd2+f2(it)*f2(it)/float(ltime)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)

      return
      end
EOF
#
cp $lcdir/reof.s.f reof.s.f
#
\rm fort.*
 gfortran -o input.x reof.s.f input.f
 ln -s $datadir1/$island.$varo.$tp.${icmonw}_ic.1981-2018.ld1-$nlead.anom.gr fort.10
 ln -s $datadir2/$model.$varm.$tp.${icmonw}_ic.1982-2020.ld1-$nlead.esm.anom.gr fort.20
 ln -s input.ld$ld.gr                                         fort.30
 ln -s eof.gr                                                 fort.40
 input.x
#
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
nt_tot=$nyr  #1982->last year
ntrain=`expr $nyr - 1`  #CV-1
ntest=1      # data length for prd
nvalid=0   # data length for validation
epochs=200 #iterations
neurons=20 #35 for ngrd=145
lrate=0.1 # learning rate (>0 to 2)
display_rate=5 # display rate for errors
#
cp $lcdir/mlp_bp.CV.f90 mlp.f90
#
cat > parm.h << eof
      parameter(iFILEROWS=$nt_tot, iDATAFIELDS=$nfld)
      parameter(iTRAINPATS=$ntrain,iTESTPATS=$ntest)
      parameter(iVALIDPATS=$nvalid)
      parameter(iEPOCHS=$epochs,iHIDDDEN=$neurons)
      parameter(ra=$lrate)
      parameter(iREDISPLAY=$display_rate)
eof
#
gfortran -g -fbacktrace -o mlp.x mlp.f90
echo "done compiling"

#if [ -d fort.10 ] ; then
\rm fort.*
#fi

ln -s input.ld$ld.gr fort.10
ln -s prd_train.bi   fort.20
ln -s mlp.ld$ld.bi   fort.30
ln -s prd_val.bi     fort.40

#excute program
mlp.x > $tmp/out
#
cat>mlp.ld$ld.ctl<<EOF
dset ^mlp.ld$ld.bi
undef -9.99E+33
title EXP1
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars  1
p  1 99 prd
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
# calculate HSS skill
#
#=======================================
# hss calculation for 2012-last_year
#=======================================
infile1=obs.ld$ld
infile2=mlp.ld$ld
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
./hss.x > $tmp/hssout.ann.eof.$ld
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
mv hss.$nlead $datadir3/skill.$tool.eof.$varn.NMME_${varm}_2_${island}_$varo.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.gr

cat>$datadir3/skill.$tool.eof.$varn.NMME_${varm}_2_${island}_$varo.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.ctl<<EOF
dset ^skill.$tool.eof.$varn.NMME_${varm}_2_${island}_$varo.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nlead linear ${tmons}1982 1mon
vars 3
hssp  1 99 hss of ann
accp  1 99 acc of ann
rmsp  1 99 rms of ann
ENDVARS
EOF

done  # for tp
done  # for curmo
#
cat sk.12 sk.01 sk.02 sk.03 sk.04 sk.05 sk.06 sk.07 sk.08 sk.09 sk.10 sk.11 > sk.tot
mv sk.tot $datadir3/skill.$tool.eof.$varn.NMME_${varm}_2_${island}_$varo.$tp.1982-$lastyr.ld-1.gr
\rm sk.*
#
cat>$datadir3/skill.$tool.eof.$varn.NMME_${varm}_2_${island}_$varo.$tp.1982-$lastyr.ld-1.ctl<<EOF
dset ^skill.$tool.eof.$varn.NMME_${varm}_2_${island}_$varo.$tp.1982-$lastyr.ld-1.gr
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
