      program test_data
      include "parm.h"
      dimension rms(nt),ac(nt)

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
           ac(it)=undef
           rms(it)=undef
         enddo

         iunit=icm+10

         ir=6
         do ld=1,nldo
         ir=ir+1
         read(iunit,rec=ir) xac
         ir=ir+1
         read(iunit,rec=ir) xrms
         ac(icm+ld-1)=xac
         rms(icm+ld-1)=xrms
c        write(6,*) "aca=",aca(icm+ld)
         enddo

         do it=1,nt
         iw=iw+1
         write(40,rec=iw) ac(it)
         iw=iw+1
         write(40,rec=iw) rms(it)
         enddo
c        write(6,*) "aca=",aca
      enddo

      stop
      end
