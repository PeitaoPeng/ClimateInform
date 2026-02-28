      program test_data
      include "parm.h"
      dimension acm(nt),aca(nt)

      open(unit=11,form='unformatted',access='direct',recl=4)
      open(unit=12,form='unformatted',access='direct',recl=4)
      open(unit=13,form='unformatted',access='direct',recl=4)
      open(unit=14,form='unformatted',access='direct',recl=4)
      open(unit=15,form='unformatted',access='direct',recl=4)
      open(unit=16,form='unformatted',access='direct',recl=4)
      open(unit=17,form='unformatted',access='direct',recl=4)
      open(unit=18,form='unformatted',access='direct',recl=4)
      open(unit=19,form='unformatted',access='direct',recl=4)
      open(unit=20,form='unformatted',access='direct',recl=4)
      open(unit=21,form='unformatted',access='direct',recl=4)
      open(unit=22,form='unformatted',access='direct',recl=4)
C
      open(unit=40,form='unformatted',access='direct',recl=4)
c*************************************************
C read skill

      undef=-9.99e+8

      iw=0
      do icm=1,12

         do it=1,nt
           acm(it)=undef
           aca(it)=undef
         enddo

         iunit=icm+10

         ir=0
         do ld=1,nld
         ir=ir+1
         read(iunit,rec=ir) xacm
         ir=ir+1
         read(iunit,rec=ir) rmsm
         ir=ir+1
         read(iunit,rec=ir) xaca
         ir=ir+1
         read(iunit,rec=ir) rmsa
         acm(icm+ld-1)=xacm
         aca(icm+ld-1)=xaca
c        write(6,*) "aca=",aca(icm+ld)
         enddo

         do it=1,nt
         iw=iw+1
         write(40,rec=iw) acm(it)
         iw=iw+1
         write(40,rec=iw) aca(it)
         enddo
c        write(6,*) "aca=",aca
      enddo

      stop
      end
