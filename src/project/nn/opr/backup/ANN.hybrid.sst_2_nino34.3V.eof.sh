t!/bin/sh

set -eaux

#=========================================================
# 3V-hybrid for a particular IC month and ld 
#=========================================================
lcdir=/cpc/home/wd52pp/project/nn/opr
tmp=/cpc/consistency/tmp_ann
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi

datadir1=/cpc/consistency/nn/obs
datadir2=/cpc/consistency/nn/cfsv2_ww
datadir3=/cpc/home/wd52pp/data/nn/empr
#
cd $tmp
# 
curmo=05
ld=07 # tgtss=djf
#
curyr=2020
model=CFSv2
tool=ann
varn=3V
clim=2c
var1=SSTem
var2=sst
var3=d20
nmod1=3
nmod2=3
nmod3=3
#
nmod=`expr $nmod1 + $nmod2 + $nmod3` 
nfld=`expr $nmod + 1` # +1 for putting obs nino34

lastyr=`expr $curyr - 1`
nextyr=`expr $curyr + 1`
nyr=`expr $lastyr - 1981`  # hcst yr #
nyrp1=`expr $nyr + 1`      # hcst_yr + cur_yr
clmperiod=1991-2020

tgtyr=$curyr
if [ $curmo = 12 ]; then tgtyr=$nextyr; fi
#
nleadmon=9
nleadss=7
imx=144
jmx=73
ngrd=1073
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

if [ $tp = 'mon' ]; then nlead=$nleadmon; fi
if [ $tp = 'ss' ];  then nlead=$nleadss; fi

#
# calculate input for var1(SSTem)
#
cp $lcdir/reof.s.f reof.s.f
#
cat > parm.h << eof
       parameter(nt=$nyr)
       parameter(imx=144,jmx=73)
       parameter(is=49,ie=121,js=29,je=45) !120-300 ngrd=1061
       parameter(ngrd=$ngrd)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(undef=-9.99E+8)
       parameter(nmod=$nmod1,id=0)
       parameter(nfld=$nmod1+1)
eof
#
cat > input.f << EOF
      program input_data
      include "parm.h"
      dimension on34(nt)
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
      real rwk(ngrd),rwk2(ngrd,nmod)
      real corr(imx,jmx),regr(imx,jmx)
C
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
C
      open(unit=30,form='unformatted',access='direct',recl=4*nfld)
      open(unit=40,form='unformatted',access='direct',recl=4*imx*jmx)
c*************************************************
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-90+(j-1)*2.5
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))  !for EOF use
      enddo
C
C read land data; land=1,sea=0
      read(11,rec=1) land
c
C read model sst & obs nino34

      ir=ld
      do it=1,nt

        read(10,rec=ir) on34(it)  !obs nino34
        read(20,rec=ir) w2d       !model hcst sst

          do i=1,imx
          do j=1,jmx
              w3d(i,j,it)=w2d(i,j)
          enddo
          enddo

c       print *, 'ir=',ir
        ir=ir+nld
      enddo ! it loop
c
C assign undef
      do it=1,nt
        do i=1,imx
        do j=1,jmx
          if(land(i,j).eq.1.or.abs(w3d(i,j,30)).ge.1000) then
          w3d(i,j,it)=undef
          endif
        enddo
        enddo
      enddo
c
C select grid SST
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
C EOF analysis
      call eofs(aaa,ngrd,nt,nt,eval,evec,coef,wk,id)
      call REOFS(aaa,ngrd,nt,nt,wk,id,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
      print *, 'eval=',eval
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

        endif

        enddo
        enddo

        iw=iw+1
        write(40,rec=iw) corr
        iw=iw+1
        write(40,rec=iw) regr
      enddo
C
C write out grid SST and obs nino34
      do it=1,nt

        do i=1,nmod
          out(i)=rcoef(i,it)
        enddo
          out(nfld)=on34(it)

        write(30,rec=it) out
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
\rm fort.*
 gfortran -o input.x reof.s.f input.f
 ln -s $datadir1/obs.nino34.$tp.${icmonw}_ic.1982-cur.ld1-$nlead.gr fort.10
 ln -s /cpc/home/wd52pp/project/nn/nmme/data_proc/land.2.5x2.5.gr   fort.11
 ln -s $datadir2/$model.$var1.$tp.${icmonw}_ic.1982-2020.ld1-$nlead.esm.anom.$clim.gr fort.20
 ln -s input1.gr                                               fort.30
 ln -s eof.gr                                                 fort.40
 input.x

##===============================
## have eof-pc input for var2
##===============================
#
cp $lcdir/grd_2_eof_4_ic.f input.f
cp $lcdir/reof.s.f reof.s.f
#
iskip=3
if [ ${icmonw} = 'dec' ];  then iskip=2; fi
#
cat > parm.h << eof
       parameter(nt=$nyr,iskip=$iskip)
       parameter(imx=$imx,jmx=$jmx)
       parameter(is=49,ie=121,js=29,je=45) !120E-300E; 20S-20N
       parameter(ngrd=$ngrd)
       parameter(nmod=$nmod2,id=0)
eof
#
/bin/rm fort.*
#
 gfortran -o input.x reof.s.f input.f
#gfortran -mcmodel=medium -g -o test_data.x reof.s.f test_data.f
#
 ln -s $datadir3/obs.$var2.$icmonw.1979-2020.anom.gr fort.10
 ln -s input2.gr   fort.30
 ln -s eof.gr fort.40
#
 input.x
#
##===============================
## have eof-pc input for var3
##===============================
#
cat > parm.h << eof
       parameter(nt=$nyr,iskip=$iskip)
       parameter(imx=$imx,jmx=$jmx)
       parameter(is=49,ie=121,js=29,je=45) !120E-300E; 20S-20N
       parameter(ngrd=$ngrd)
       parameter(nmod=$nmod3, id=0)
eof
#
/bin/rm fort.*
#
 gfortran -o input.x reof.s.f input.f
#gfortran -mcmodel=medium -g -o test_data.x reof.s.f test_data.f
#
 ln -s $datadir3/obs.$var3.$icmonw.1979-2020.anom.gr fort.10
 ln -s input3.gr   fort.30
 ln -s eof.gr fort.40
#
 input.x
##===================================
##combine the inputs of all vars
##===================================
#
cat > comb_input.f << eof
      program combing
      parameter(nt=$nyr)
      parameter(nmod1=$nmod1,nmod2=$nmod2,nmod3=$nmod3)
      parameter(nfld1=nmod1+1)
      parameter(nfld=$nfld)
c
      dimension v1in(nfld1),v2in(nmod2),v3in(nmod3)
      dimension out(nfld)
c
      open(unit=11,form='unformatted',access='direct',recl=4*nfld1)
      open(unit=12,form='unformatted',access='direct',recl=4*nmod2)
      open(unit=13,form='unformatted',access='direct',recl=4*nmod3)
      open(unit=20,form='unformatted',access='direct',recl=4*nfld)
c
      do it=1,nt
        read(11,rec=it) v1in
        read(12,rec=it) v2in
        read(13,rec=it) v3in
        do i=1,nmod1
         out(i)=v1in(i)
        enddo
        do i=1,nmod2
         out(i+nmod1)=v2in(i)
        enddo
        do i=1,nmod3
         out(i+nmod1+nmod2)=v3in(i)
        enddo
         out(nfld)=v1in(nfld1)
        write(20,rec=it) out
      enddo !it loop
c
      stop
      end
eof
#
/bin/rm fort.*
#
 gfortran -o comb.x comb_input.f
 ln -s input1.gr   fort.11
 ln -s input2.gr   fort.12
 ln -s input3.gr   fort.13
 ln -s input.gr    fort.20
 comb.x
#
##=====================================
## use field data to correct nino34 hcst
##=====================================
#
nt_tot=$nyr  #1982->last year
ntrain=`expr $nyr - 1`  #CV-1
ntest=1      # data length for prd
nvalid=0   # data length for validation
epochs=200 # iterations
neurons=25 #35 for ngrd=145
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

ln -s input.gr  fort.10
ln -s prd_train.bi   fort.20
ln -s mlp.ld$ld.bi   fort.30
ln -s prd_val.bi     fort.40
#
#excute program
mlp.x > $tmp/out
#
cat>mlp.ld$ld.ctl<<EOF
dset ^mlp.ld$ld.bi
undef -9.99E+33
title EXP1
XDEF  $ntest LINEAR    0  1.0
YDEF  1 LINEAR  -90  1.0
zdef  1 linear 1 1
tdef  ${nt_tot} linear jan1983 1yr
vars  1
p  0 99 prd
endvars
#
EOF
#
# calculate nino34 of model fcst
#
cat >n34index<<EOF
run nino34.gs
EOF
cat >nino34.gs<<EOF
'reinit'
'open $datadir2/$model.SSTem.$tp.${icmonw}_ic.1982-2020.ld1-$nlead.esm.anom.$clim.ctl'
'set gxout fwrite'
'set fwrite model.n34.ld$ld.gr'
'set x 72'
'set y 37'
it=1
while ( it <= $nyr)
'set t 'it''
'set z '$ld''
'd aave(f,lon=190,lon=240,lat=-5,lat=5))'
it=it+1
endwhile
EOF
#
/usr/local/bin/grads -bl <n34index
#
cat>model.n34.ld$ld.ctl<<EOF
dset ^model.n34.ld$ld.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1983 1yr
vars 1
f 1 99 model fcst
ENDVARS
EOF
#
# calculate nino34 of OBS
#
cat >n34index<<EOF
run nino34.gs
EOF
cat >nino34.gs<<EOF
'reinit'
'open $datadir1/obs.sst.$tp.${icmonw}_ic.1982-cur.ld1-$nlead.anom.ctl'
'set gxout fwrite'
'set fwrite obs.n34.ld$ld.gr'
'set x 72'
'set y 37'
it=1
while ( it <= $nyr)
'set t 'it''
'set z '$ld''
'd aave(o,lon=190,lon=240,lat=-5,lat=5))'
it=it+1
endwhile
EOF
#
/usr/local/bin/grads -bl <n34index
#
cat>obs.n34.ld$ld.ctl<<EOF
dset ^obs.n34.ld$ld.gr
undef -9.99e+33
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1983 1yr
vars 1
o 1 99 model fcst
ENDVARS
EOF
#
# calculate nino34 of OBS
#
cat >have_skill<<EOF
run skill.gs
EOF
cat >skill.gs<<EOF
'reinit'
'open obs.n34.ld$ld.ctl'
'open model.n34.ld$ld.ctl'
'open mlp.ld$ld.ctl'
*'set gxout fwrite'
*'set fwrite skill.$ld'
'define oo=sqrt(ave(o*o,t=1,t=$nyr))'
'define mm=sqrt(ave(f.2*f.2,t=1,t=$nyr))'
'define pp=sqrt(ave(p.3*p.3,t=1,t=$nyr))'
'define om=ave(o*f.2,t=1,t=$nyr)/(oo*mm)'
'define op=ave(o*p.3,t=1,t=$nyr)/(oo*pp)'
'define rmsom=sqrt(ave((o-f.2)*(o-f.2),t=1,t=$nyr))'
'define rmsop=sqrt(ave((o-p.3)*(o-p.3),t=1,t=$nyr))'
'd om'
'd rmsom'
'd op'
'd rmsop'
EOF
#
/usr/local/bin/grads -bl <have_skill
#
done  # for tp
