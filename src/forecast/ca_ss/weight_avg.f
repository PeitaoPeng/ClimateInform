      program wtavg
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C CA prediction for tropical heating
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c range for sst pat cor (ac_1d)
c
      dimension ts1(nseason),ts2(nseason)
      dimension kwt(nseason),kyr(nseason)
      dimension fld(nseason,nmod,nsic,nsst)
C
      open(unit=11,form='unformatted',access='direct',recl=4*nseason) 
      open(unit=12,form='unformatted',access='direct',recl=4*nseason)
      open(unit=13,form='unformatted',access='direct',recl=4*nseason)
      open(unit=14,form='unformatted',access='direct',recl=4*nseason)
      open(unit=15,form='unformatted',access='direct',recl=4*nseason)
      open(unit=16,form='unformatted',access='direct',recl=4*nseason)
      open(unit=17,form='unformatted',access='direct',recl=4*nseason)
      open(unit=18,form='unformatted',access='direct',recl=4*nseason)
      open(unit=19,form='unformatted',access='direct',recl=4*nseason)
      open(unit=20,form='unformatted',access='direct',recl=4*nseason)
      open(unit=21,form='unformatted',access='direct',recl=4*nseason)
      open(unit=22,form='unformatted',access='direct',recl=4*nseason)
      open(unit=23,form='unformatted',access='direct',recl=4*nseason)
      open(unit=24,form='unformatted',access='direct',recl=4*nseason)
      open(unit=25,form='unformatted',access='direct',recl=4*nseason)
      open(unit=26,form='unformatted',access='direct',recl=4*nseason)
      open(unit=27,form='unformatted',access='direct',recl=4*nseason)
      open(unit=28,form='unformatted',access='direct',recl=4*nseason)
      open(unit=29,form='unformatted',access='direct',recl=4*nseason)
      open(unit=30,form='unformatted',access='direct',recl=4*nseason)
      open(unit=31,form='unformatted',access='direct',recl=4*nseason)
      open(unit=32,form='unformatted',access='direct',recl=4*nseason)
      open(unit=33,form='unformatted',access='direct',recl=4*nseason)
      open(unit=34,form='unformatted',access='direct',recl=4*nseason)
c
      open(unit=85,form='unformatted',access='direct',recl=4*nseason)
c************************************************
c
cc read in all weights
c
c     write(6,*) 'read data'
      iu=10
      Do is=1,nsst
      Do ic=1,nsic
      Do im=1,nmod
      iu=iu+1
        read(iu,rec=1) ts1
        do i=1,nseason
        fld(i,im,ic,is)=ts1(i)
        enddo
      Enddo
      Enddo
      Enddo
c
c have year name
      kyr(1)=1949
      Do i=2,nseason
      kyr(i)=kyr(i-1)+1
c     kyr(i+1)=kyr(i)
      Enddo
c
c for weights of ersst
      Do i=1,nseason
      xx=0
      num=0
      Do is=1,1
      Do ic=1,nsic
      Do im=1,nmod
      xx=xx+fld(i,im,ic,is)
      num=num+1
      Enddo
      Enddo
      Enddo
      kwt(i)=100.*xx/float(num)
      Enddo
c
      write(6,555)
      write(6,*)' Ensemble Averaged Weights(%) for ERSST'
      write(6,555)
c
      nrow=nseason/10 + 1
      do i=1,nrow
      ns=(i-1)*10+1
      ne=(i)*10
      if(ne.gt.nseason) then
      ne=nseason
      endif
      write(6,888) (kyr(n),n=ns,ne)
      write(6,888) (kwt(n),n=ns,ne)
      enddo
c
c for weights of hadoi sst
      Do i=1,nseason
      xx=0
      num=0
      Do is=2,2
      Do ic=1,nsic
      Do im=1,nmod
      xx=xx+fld(i,im,ic,is)
      num=num+1
      Enddo
      Enddo
      Enddo
      kwt(i)=100*xx/float(num)
      Enddo
c
      write(6,555)
      write(6,*)' Ensemble Averaged Weights(%) for HADOI-SST'
      write(6,555)
c
      do i=1,nrow
      ns=(i-1)*10+1
      ne=(i)*10
      if(ne.gt.nseason) then
      ne=nseason
      endif
      write(6,888) (kyr(n),n=ns,ne)
      write(6,888) (kwt(n),n=ns,ne)
      enddo
 888  format(10I6)
 555  format(/)
c     write(6,*) 'write out for each run'
      iw=1
      Do ic=1,nsic
      Do im=1,nmod
      Do is=1,nsst
        do i=1,nseason
        ts1(i)=fld(i,im,ic,is)
        enddo
        write(85,rec=iw) ts1
        iw=iw+1
      Enddo
      Enddo
      Enddo
c
      STOP
      END
