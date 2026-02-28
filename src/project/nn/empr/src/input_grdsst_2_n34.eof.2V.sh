set -euax
########################################################
# have grid SST input 
###############################################
#
icmon=may
var1=sst
var2=d20
ltime=42
iskip=0
ngrd=1073
nmod1=11 # modes kept
nmod2=3 # modes kept
nmod=`expr $nmod1 + $nmod2`
nfld=`expr $nmod + 1`
#
lcdir=/cpc/home/wd52pp/project/nn/empr/src
datadir=/cpc/home/wd52pp/data/nn/empr
tmp=/cpc/home/wd52pp/tmp
cd $tmp
cp $lcdir/input_grdsst_2_n34.eof.f test.f
cp $lcdir/reof.s.f reof.s.f
#
# for var1 input
#
cat > parm.h << eof
       parameter(nt=$ltime,iskip=$iskip)
       parameter(imx=144,jmx=73)
       parameter(is=49,ie=121,js=29,je=45) !120 -300
       parameter(ngrd=$ngrd,nfld=$nmod1+1)
       parameter(nmod=$nmod1, id=1)
eof
#
/bin/rm fort.*
#
 gfortran -o test.x reof.s.f test.f
#gfortran -mcmodel=medium -g -o test_data.x reof.s.f test_data.f
#
 ln -s $datadir/obs.$var1.${icmon}.1979-2020.anom.gr fort.10
 ln -s $datadir/nino34.hadoi.dec1979-feb2021.djf.gr fort.20
 ln -s $datadir/input_$var1.${icmon}_ic.1979-2020.djf.gr fort.30
 ln -s $datadir/eof.input_$var1.${icmon}_ic.1979-2020.djf.gr fort.40
#
 test.x 
#
cat>$datadir/eof.input_$var1.${icmon}_ic.1979-2020.djf.ctl<<EOF3
dset ^eof.input_$var1.${icmon}_ic.1979-2020.djf.gr
undef -9.99E+8
title EXP1
XDEF 144 LINEAR 0  2.5
YDEF  73 LINEAR    -90  2.5
zdef 1 linear 1 1
tdef $nmod1 linear jan1981 1yr
vars 2
c 1 99 corr
r 1 99 regr
endvars
#
EOF3
#
/bin/rm $tmp/fort.*
#
# for var2 input
#
cat > parm.h << eof
       parameter(nt=$ltime,iskip=$iskip)
       parameter(imx=144,jmx=73)
       parameter(is=49,ie=121,js=29,je=45) !120 -300
       parameter(ngrd=$ngrd,nfld=$nmod2+1)
       parameter(nmod=$nmod2, id=0)
eof
#
 gfortran -o test.x reof.s.f test.f
#gfortran -mcmodel=medium -g -o test_data.x reof.s.f test_data.f
#
 ln -s $datadir/obs.$var2.${icmon}.1979-2020.anom.gr fort.10
 ln -s $datadir/nino34.hadoi.dec1979-feb2021.djf.gr fort.20
 ln -s $datadir/input_$var2.${icmon}_ic.1979-2020.djf.gr fort.30
 ln -s $datadir/eof.input_$var2.${icmon}_ic.11979-2020.djf.gr fort.40
#
 test.x
#
cat>$datadir/eof.input_$var2.${icmon}_ic.1979-2020.djf.ctl<<EOF3
dset ^eof.input_$var2.${icmon}_ic.1979-2020.djf.gr
undef -9.99E+8
title EXP1
XDEF 144 LINEAR 0  2.5
YDEF  73 LINEAR    -90  2.5
zdef 1 linear 1 1
tdef $nmod2 linear jan1981 1yr
vars 2
c 1 99 corr
r 1 99 regr
endvars
#
EOF3
   
#
/bin/rm $tmp/fort.*
#
#combine the inputs of all vars
#
cat > comb_input.f << eof
      program combing
      parameter(nt=$ltime,id=0)
      parameter(nmod1=$nmod1,nmod2=$nmod2)
      parameter(nfld1=$nmod1+1,nfld2=$nmod2+1)
      parameter(nfld=$nfld)
c
      dimension v1in(nfld1),v2in(nfld2)
      dimension out(nfld)
c
      open(unit=11,form='unformatted',access='direct',recl=4*nfld1)
      open(unit=12,form='unformatted',access='direct',recl=4*nfld2)
      open(unit=20,form='unformatted',access='direct',recl=4*nfld)
c
      do it=1,nt
        read(11,rec=it) v1in
        read(12,rec=it) v2in
        do i=1,nmod1
         out(i)=v1in(i)
        enddo
        do i=1,nfld2
         out(i+nmod1)=v2in(i)
        enddo
        write(20,rec=it) out
      enddo !it loop
c
      stop
      end
eof
 gfortran -o comb.x comb_input.f
 ln -s $datadir/input_$var1.${icmon}_ic.1979-2020.djf.gr fort.11
 ln -s $datadir/input_$var2.${icmon}_ic.1979-2020.djf.gr fort.12
 ln -s $datadir/input.${icmon}_ic.1979-2020.djf.gr       fort.20
 comb.x
#

