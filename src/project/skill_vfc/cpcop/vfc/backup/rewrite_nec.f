      program RWT
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. read nino34 and write out non-EC hss of t&p with >0.5
c  write out cold non-EC hss of t&p with <-0.5ROC and reliability
C===========================================================)
c
      real sst(nss),hst(nss),hsp(nss)
      real hstw(nss),hstn(nss),hstc(nss)
      real hspw(nss),hspn(nss),hspc(nss)

      open(11,form='unformatted',access='direct',recl=4)
      open(12,form='unformatted',access='direct',recl=4)
      open(13,form='unformatted',access='direct',recl=4)
c
      open(60,form='unformatted',access='direct',recl=4)
c
      ir=0
      do it=1,nss

        read(11,rec=it) sst(it)

        hstw(it)=-9999.0
        hstn(it)=-9999.0
        hstc(it)=-9999.0
        hspw(it)=-9999.0
        hspn(it)=-9999.0
        hspc(it)=-9999.0

        do ik=1,9
        ir=ir+1
          read(12,rec=ir) hstemp
          read(13,rec=ir) hsprec
          if(ik.eq.3) hst(it)=hstemp
          if(ik.eq.3) hsp(it)=hsprec
        enddo
      enddo
      
      do it=1,nss
        if(sst(it).gt.0.5) hstw(it)=hst(it)
        if(sst(it).lt.-0.5) hstc(it)=hst(it)
        if(sst(it).lt.0.5.and.sst(it).gt.-0.5) hstn(it)=hst(it)
        if(sst(it).gt.0.5) hspw(it)=hsp(it)
        if(sst(it).lt.-0.5) hspc(it)=hsp(it)
        if(sst(it).lt.0.5.and.sst(it).gt.-0.5) hspn(it)=hsp(it)
      enddo
      write(6,*) 'sst=',sst
      
      iw=0
      do it=1,nss
        iw=iw+1
        write(60,rec=iw) hstw(it)
        iw=iw+1
        write(60,rec=iw) hstn(it)
        iw=iw+1
        write(60,rec=iw) hstc(it)
        iw=iw+1
        write(60,rec=iw) hspw(it)
        iw=iw+1
        write(60,rec=iw) hspn(it)
        iw=iw+1
        write(60,rec=iw) hspc(it)
      enddo

      stop
      END
c


