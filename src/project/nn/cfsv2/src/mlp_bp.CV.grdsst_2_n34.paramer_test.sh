#!/bin/sh

set -eaux

##=====================================
## us field data to correct nino34 hcst (CV)
##=====================================
lcdir=/cpc/home/wd52pp/project/nn/cfsv2/src
datadir=/cpc/home/wd52pp/data/nn/cfsv2
tmp=/cpc/home/wd52pp/tmp

if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
cd $tmp
#
tgtss=djf
clim=2c # clim type
area=whole
nflds=146 # inputs + outputs
#nflds=50 # inputs + outputs
#nflds=23 # inputs + outputs

#neurons=35 # hidden neuron number
neurons=150 # hidden neuron number
#neurons=10 # for NWTP, hidden neuron number
#
#for icmon in may jun jul aug sep oct nov; do
#for icmon in nov dec jan feb mar apr may; do
#for icmon in nov; do
for icmon in may; do
#
nt_tot=38 # N(year)
ntrain=37 # N-1 for CV test
ntest=1   # data length for test
nvalid=0   # data length for validation
epochs=200 # iterations
#lrate=0.225 # learning rate (>0 to 2)
#lrate=0.01 # learning rate (>0 to 2)
display_rate=5 # display rate for errors
#
cp $lcdir/mlp_bp.CV.f90 mlp.f90
#
lrate=0.05
while [ $lrate -le 0.5 ]
do

cat > parm.h << eof
      parameter(iFILEROWS=$nt_tot, iDATAFIELDS=$nflds)
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
/bin/rm $tmp/fort.*
#fi

ln -s $datadir/input_sst.${icmon}_ic.1982-2020.$tgtss.$clim.gr fort.10
ln -s $datadir/prd_train.bi   fort.20
ln -s $datadir/mlp.$tgtss.grdsst_2_n34.${icmon}_ic.$area.$clim.bi  fort.30
ln -s $datadir/prd_val.bi     fort.40

#excute program
mlp.x > $datadir/out
cat > skill.f<< eoff
      program test_data
      parameter (nt=$ltime,nld=$nlead)
      dimension on34(nt),w1(nt),w2(nt),w3(nt)
      dimension f2dm(nt,nld),f2dn(nt,nld),f2dr(nt,nld)
      dimension acm(nld),rmsm(nld),acn(nld),rmsn(nld)
      dimension acr(nld),rmsr(nld)
      open(unit=10,form='unformatted',access='direct',recl=4)

      open(unit=11,form='unformatted',access='direct',recl=4)
      open(unit=12,form='unformatted',access='direct',recl=4)
#
lrate=$((lrate+0.05))
pen(unit=33,form='unformatted',access='direct',recl=4)
      open(unit=34,form='unformatted',access='direct',recl=4)
      open(unit=35,form='unformatted',access='direct',recl=4)
      open(unit=36,form='unformatted',access='direct',recl=4)
      open(unit=37,form='unformatted',access='direct',recl=4)

      open(unit=40,form='unformatted',access='direct',recl=4)
c*************************************************
C read nmme nino indices
      do it=1,nt
        read(10,rec=it) on34(it)
      enddo

      icm=18
      icn=28
      icr=38
      do ld=1,nld
        icm=icm-1
        icn=icn-1
        icr=icr-1

        do it=1,nt
        read(icm,rec=it) f2dm(it,ld)
        read(icn,rec=it) f2dn(it,ld)
        ir=it*2
        read(icr,rec=ir) f2dr(it,ld)
        enddo
      enddo
C have ac and rms
      iw=0
      do ld=1,nld
        do it=1,nt
          w1(it)=f2dm(it,ld)
          w2(it)=f2dn(it,ld)
          w3(it)=f2dr(it,ld)
        enddo
        call ac_rms(on34,w1,nt,acm(ld),rmsm(ld))
        call ac_rms(on34,w2,nt,acn(ld),rmsn(ld))
        call ac_rms(on34,w3,nt,acr(ld),rmsr(ld))
        iw=iw+1
        write(40,rec=iw) acm(ld)
        iw=iw+1
        write(40,rec=iw) acn(ld)
        iw=iw+1
        write(40,rec=iw) acr(ld)
        iw=iw+1
        write(40,rec=iw) rmsm(ld)
        iw=iw+1
        write(40,rec=iw) rmsn(ld)
        iw=iw+1
        write(40,rec=iw) rmsr(ld)
      enddo
C
      write(6,*) 'acm=',acm
      write(6,*) 'acn=',acn
      write(6,*) 'acr=',acr
      write(6,*) 'rmsm=',rmsm
      write(6,*) 'rmsn=',rmsn
      write(6,*) 'rmsr=',rmsr

C avg skill
      avacm=0
      avacn=0
      avacr=0
      avrmsm=0
      avrmsn=0
      avrmsr=0
      do i=1,nld
      avacm=avacm+acm(i)/float(nld)
      avacn=avacn+acn(i)/float(nld)
      avacr=avacr+acr(i)/float(nld)
      avrmsm=avrmsm+rmsm(i)/float(nld)
      avrmsn=avrmsn+rmsn(i)/float(nld)
      avrmsr=avrmsr+rmsr(i)/float(nld)
      enddo
      stop
      end
eoff
\rm fort.*
 gfortran -o skill.x skill.f
 ln -s $datadir2/nino34.oi.1982-2020.djf.gr fort.10

 ln -s $datadir/CFSv2.nino34.may_ic.1982-2020.djf.$clim.gr fort.11
 ln -s $datadir/CFSv2.nino34.jun_ic.1982-2020.djf.$clim.gr fort.12
 ln -s $datadir/CFSv2.nino34.jul_ic.1982-2020.djf.$clim.gr fort.13
 ln -s $datadir/CFSv2.nino34.aug_ic.1982-2020.djf.$clim.gr fort.14
 ln -s $datadir/CFSv2.nino34.sep_ic.1982-2020.djf.$clim.gr fort.15
 ln -s $datadir/CFSv2.nino34.oct_ic.1982-2020.djf.$clim.gr fort.16
 ln -s $datadir/CFSv2.nino34.nov_ic.1982-2020.djf.$clim.gr fort.17

 ln -s $datadir/mlp.djf.grdsst_2_n34.may_ic.whole.$clim.bi fort.21
 ln -s $datadir/skill.vs.lead.nino34.djf.$clim.gr fort.40
 skill.x
#


lrate=$((lrate+0.05))
done
#

done
