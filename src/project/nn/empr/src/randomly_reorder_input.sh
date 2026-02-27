set -euax
########################################################
# have grid SST input 
###############################################
#
ltime=42
icmon=may
nmod=22 # tot modes kept
nfld=`expr $nmod + 1`
#
lcdir=/cpc/home/wd52pp/project/nn/empr/src
datadir=/cpc/home/wd52pp/data/nn/empr
tmp=/cpc/home/wd52pp/tmp
cd $tmp
#
cp $lcdir/reorder.s.f $tmp/.
#
cat > re_order.f << eof
      program reorder
      parameter(nt=$ltime,id=0)
      parameter(nfld=$nfld)
c
      dimension rin(nfld)
      dimension w2din(nfld,nt),w2d(nfld,nt)
      dimension idx(nt),on34(nt),onout(nt)
c
      open(unit=10,form='unformatted',access='direct',recl=4*nfld)
      open(unit=11,form='unformatted',access='direct',recl=4)
      open(unit=20,form='unformatted',access='direct',recl=4*nfld)
      open(unit=21,form='unformatted',access='direct',recl=4)
c
      do it=1,nt
        read(10,rec=it) rin
        read(11,rec=it) xn
        do i=1,nfld
         w2din(i,it)=rin(i)
        enddo
        on34(it)=xn
      enddo
c
c randomly order
      call re_order(nt,idx)
      do it=1,nt
          do i=1,nfld
            w2d(i,it)=w2din(i,idx(it))
          enddo
          onout(it)=on34(idx(it))
      print *, 'idx=',idx(it)
      enddo
c write out
      do it=1,nt
        do i=1,nfld
        rin(i)=w2d(i,it)
        enddo
        write(20,rec=it) rin
        write(21,rec=it) onout(it)
      enddo

      stop
      end
eof
#
/bin/rm  fort.*
#
 gfortran -o reorder.x reorder.s.f re_order.f
#gfortran -mcmodel=medium -g -o test_data.x reof.s.f test_data.f
#
 ln -s $datadir/input.${icmon}_ic.1979-2020.djf.gr fort.10
 ln -s $datadir/nino34.hadoi.dec1979-feb2021.djf.gr fort.11
 ln -s $datadir/input_reordered.${icmon}_ic.1979-2020.djf.gr fort.20
 ln -s $datadir/nino34.hadoi.dec1979-feb2021.djf.random.gr fort.21
#
 reorder.x 
#
   

