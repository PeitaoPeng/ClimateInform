t!/bin/sh

set -eaux

#=========================================================
# Hybrid_PLS combined CFSv2_SSTem and obs_sst_d20 for nino3.4 skill for hindcast from each IC_month
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
for mode in 7; do 
#for curmo in 05; do
for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do
#
curyr=2020
model=CFSv2
tool=pls
varn=2V
vn=2
clim=2c
var1=sst
var2=d20
#

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
#
# have input data to ANN package =======================================
#
imon=$curmo
if [ $imon = 01 ]; then icmonw=jan; tmons=feb; oicmonw=dec; fi
if [ $imon = 02 ]; then icmonw=feb; tmons=mar; oicmonw=jan; fi
if [ $imon = 03 ]; then icmonw=mar; tmons=apr; oicmonw=feb; fi
if [ $imon = 04 ]; then icmonw=apr; tmons=may; oicmonw=mar; fi
if [ $imon = 05 ]; then icmonw=may; tmons=jun; oicmonw=apr; fi
if [ $imon = 06 ]; then icmonw=jun; tmons=jul; oicmonw=may; fi
if [ $imon = 07 ]; then icmonw=jul; tmons=aug; oicmonw=jun; fi
if [ $imon = 08 ]; then icmonw=aug; tmons=sep; oicmonw=jul; fi
if [ $imon = 09 ]; then icmonw=sep; tmons=oct; oicmonw=aug; fi
if [ $imon = 10 ]; then icmonw=oct; tmons=nov; oicmonw=sep; fi
if [ $imon = 11 ]; then icmonw=nov; tmons=dec; oicmonw=oct; fi
if [ $imon = 12 ]; then icmonw=dec; tmons=jan; oicmonw=nov; fi
#
#for tp in mon ss; do
for tp in ss; do

if [ $tp = 'mon' ]; then nlead=$nleadmon; fi
if [ $tp = 'ss' ];  then nlead=$nleadss; fi

ld=1
while  [ $ld -le $nlead ]
do

outfile1=pls.ld$ld

#
# calculate input for var1(SSTem)
#
cp $lcdir/pls_hcst.s.f pls.s.f
#
cat > parm.h << eof
       parameter(nt=$nyr)
       parameter(imx=144,jmx=73)
       parameter(is=49,ie=121,js=29,je=45) !120-300 20S-20N
c      parameter(is=49,ie=121,js=29,je=57) !120-300 20S-50N
c      parameter(is=1,ie=121,js=29,je=45) !0-300 20S-20N
c      parameter(is=1,ie=144,js=29,je=45) !0-360 20S-20N
c      parameter(is=1,ie=144,js=29,je=57) !0-360 20S-50N
c
       parameter(im1=ie-is+1)
       parameter(im=${vn}*im1,jm=je-js+1)
       parameter(nld=$nlead)
       parameter(ld=$ld)
       parameter(undef=-9.99E+8)
       parameter(mode=$mode,ID=1)
eof
#
cat > pls.f << EOF
      program input_data
      include "parm.h"
      dimension on34(nt)
      dimension w2d(imx,jmx),w2d2(imx,jmx),w2d3(imx,jmx)
      dimension w3d1(imx,jmx,nt),w3d2(imx,jmx,nt),w3d3(imx,jmx,nt)
      dimension land(imx,jmx)
c
      dimension w3dc(im,jm,nt),wic(im,jm)
C
      real*4 pc(nt-1,mode),pat(im,jm,mode),pat2(im,jm,mode)
      real*4 var(mode),corr(mode),pcprd(nt),pco(mode)
      real*4 w1d(nt-1),w1d2(nt-1),w3d(im,jm,nt-1)
      real*4 vart(nt),avg(nt)
      real*4 pcd(nt,mode)
c
      dimension xlat(jmx),coslat(jmx),cosr(jmx)
      dimension cosl(jm)
C
      open(unit=11,form='unformatted',access='direct',recl=4)
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx)
C
      open(unit=21,
     1file='$outfile1.bi',
     2access='direct',form='unformatted',recl=4)
c*************************************************
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-90+(j-1)*2.5
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))  !for EOF use
      enddo
      k=0
      do j=js,je
        k=k+1
        cosl(k)=coslat(j)
      enddo
C     write(6,*) 'cosl=',cosl
C
C read obs nino34

      ir=ld
      do it=1,nt

        read(11,rec=ir) on34(it)  !obs nino34

        ir=ir+nld
      enddo ! it loop
c
C read obs sst and d20

      iskip=3
c     if($imon.eq.12) iskip=2
      if($imon.eq.1) iskip=2 ! IC-mon is the DEC of last year
      ir=iskip + 1
      do it=1,nt

        read(12,rec=ir) w2d 
        read(13,rec=ir) w2d2

          do i=1,imx
          do j=1,jmx
            w3d1(i,j,it)=w2d(i,j)
            w3d2(i,j,it)=w2d2(i,j)
          enddo
          enddo

        print *, 'ir=',ir
        ir=ir+1
      enddo ! it loop
C
C combine the all data together
      do it=1,nt
      jc=0
      do j=js,je
        jc=jc+1
        ic=0
      do i=is,ie
        ic=ic+1
        w3dc(ic,jc,it)=w3d1(i,j,it)
        w3dc(ic+im1,jc,it)=w3d2(i,j,it)
      enddo  ! i loop
      enddo  ! j loop
      enddo  ! it loop

      write(6,*) 'ic=',ic
      write(6,*) 'jc=',jc
c
c hcst start
      DO ity=1,nt

        it=0
        do iy=1,nt

        if(iy.eq.ity) go to 100
        it=it+1
          w1d(it)=on34(iy)
        do i=1,im
        do j=1,jm
          w3d(i,j,it)=w3dc(i,j,iy)
        enddo
        enddo

100     continue
        enddo !iy loop

        do i=1,im
        do j=1,jm
          wic(i,j)=w3dc(i,j,ity)
        enddo
        enddo

      call anom(w1d,nt-1,av)
      avg(ity)=av
c
c anom input data w3d
      do i=1,im
      do j=1,jm
        if(abs(w3d(i,j,1)).lt.999) then

        do iy=1,nt-1
          w1d2(iy)=w3d(i,j,iy)
        enddo

        call anom(w1d2,nt-1,av)
        do iy=1,nt-1
          w3d(i,j,iy)=w1d2(iy)
        enddo

        wic(i,j)=wic(i,j)-av

        endif
      enddo
      enddo
c     print *, ' wic=',wic
c     print *, ' w3d=',w3d

      call pls_hcst(nt-1,im,jm,1,im,1,jm,mode,
     &w1d,w3d,wic,pc,pco,pat,pat2,var,cosl,undef,ID)
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
c     print *, ' vart=',vart
c
c cor and explained variance
        call cor_reg(nt,pcprd,on34,cort,reg)
c
      vartot=cort*cort
c     write(6,*) 'vartot=',vartot
      write(6,*) 'hcst cor=',cort
c
c adjust std of pcprd to that of obs
      call stdv(on34,nt,ostd)
      do it=1,nt
        pcprd(it)=ostd*pcprd(it)
      enddo
      print *, ' ostd=',ostd

c write out
      iw=0
      do it=1,nt
        iw=iw+1
        write(21,rec=iw) on34(it)
        iw=iw+1
        write(21,rec=iw) pcprd(it)
      enddo
c     write(6,*) 'obs34=',on34
c     write(6,*) 'pcprd=',pcprd
c
      stop
      end

c========================
      subroutine stdv(ts,nt,std)
      dimension ts(nt)
        av=0
        do i=1,nt
          av=av+ts(i)
        end do
        avg=av/float(nt)
        std=0
        do i=1,nt
          std=std+(ts(i)-avg)**2
        end do
        std=sqrt(std/float(nt))
      return
      end
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
 gfortran -o pls.x pls.s.f pls.f
 ln -s $datadir1/obs.nino34.$tp.${icmonw}_ic.1982-cur.ld1-$nlead.gr fort.11
 ln -s $datadir3/obs.$var1.$oicmonw.1979-2020.anom.gr           fort.12
 ln -s $datadir3/obs.$var2.$oicmonw.1979-2020.anom.gr           fort.13
#
#pls.x > $lcdir/out.$ld
pls.x
#
cat>$outfile1.ctl<<EOF
dset ^$outfile1.bi
undef -9.99E+8
title EXP1
XDEF  1 LINEAR    0  1.0
YDEF  1 LINEAR  -90  1.0
zdef  1 linear 1 1
tdef  $nyr linear jan1982 1yr
vars  2
o  0 99 prd
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
undef -9.99e+8
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
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
undef -9.99e+8
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nyr linear jan1982 1yr
vars 1
o 1 99 model fcst
ENDVARS
EOF
#
# calculate skill
#
cat >have_skill<<EOF
run skill.gs
EOF
cat >skill.gs<<EOF
'reinit'
'open obs.n34.ld$ld.ctl'
'open model.n34.ld$ld.ctl'
'open $outfile1.ctl'
'set gxout fwrite'
'set fwrite skill.$ld'
'define oo=sqrt(ave(o*o,t=1,t=$nyr))'
'define mm=sqrt(ave(f.2*f.2,t=1,t=$nyr))'
'define pp=sqrt(ave(p.3*p.3,t=1,t=$nyr))'
'define om=ave(o*f.2,t=1,t=$nyr)/(oo*mm)'
'define op=ave(o*p.3,t=1,t=$nyr)/(oo*pp)'
'define rmsom=sqrt(ave((o-f.2)*(o-f.2),t=1,t=$nyr))'
'define rmsop=sqrt(ave((o-p.3*oo/pp)*(o-p.3*oo/pp),t=1,t=$nyr))'
'd om'
'd rmsom'
'd op'
'd rmsop'
EOF
#
/usr/local/bin/grads -bl <have_skill
#
ld=$(( ld+1 ))
done  # for ld

#cat skill together

mv skill.1 acrms.1
ld=2
while  [ $ld -le $nlead ]
do
ldm=$((ld-1))

cat acrms.$ldm  skill.$ld > acrms.$ld

\rm acrms.$ldm

ld=$(( ld+1 ))
done  # for ld
#

mv acrms.$nlead $datadir2/skill.$tool.$varn.${var1}_${var2}_2_nino34.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.mode$mode.gr

cat>$datadir2/skill.$tool.$varn.${var1}_${var2}_2_nino34.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.mode$mode.ctl<<EOF
dset ^skill.$tool.$varn.${var1}_${var2}_2_nino34.$tp.${icmonw}_ic.1982-$lastyr.ld1-$nlead.mode$mode.gr
undef -9.99e+8
*
TITLE model
*
XDEF 1 LINEAR    0.  2.5
YDEF 1 LINEAR  -90.  2.5
zdef 1 linear 1 1
tdef $nlead linear ${tmons}1982 1mon
vars 4
acm  1 99 ac of model
rmsm 1 99 rms of model
aca  1 99 ac of ann
rmsa 1 99 rms of ann
ENDVARS
EOF

done  # for tp
#
done  # for curmo
done  # for mode
