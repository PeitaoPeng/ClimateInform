      program text_table
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C write out nino34 index of CA SST forecast
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c
      dimension fld1(nld),fld2(nld)
      dimension w5d(nld,nvar,nyr,nss,2*nesm)
      dimension outa(nld-4),outt(nld-4)
C
      open(unit=11,form='unformatted',access='direct',recl=4*17) 
      open(unit=12,form='unformatted',access='direct',recl=4*17)
      open(unit=13,form='unformatted',access='direct',recl=4*17)
      open(unit=14,form='unformatted',access='direct',recl=4*17)
      open(unit=15,form='unformatted',access='direct',recl=4*17)
      open(unit=16,form='unformatted',access='direct',recl=4*17)
      open(unit=17,form='unformatted',access='direct',recl=4*17)
      open(unit=18,form='unformatted',access='direct',recl=4*17)
      open(unit=19,form='unformatted',access='direct',recl=4*17)
      open(unit=20,form='unformatted',access='direct',recl=4*17)
      open(unit=21,form='unformatted',access='direct',recl=4*17)
      open(unit=22,form='unformatted',access='direct',recl=4*17)
      open(unit=23,form='unformatted',access='direct',recl=4*17)
      open(unit=24,form='unformatted',access='direct',recl=4*17)
      open(unit=25,form='unformatted',access='direct',recl=4*17)
      open(unit=26,form='unformatted',access='direct',recl=4*17)
      open(unit=27,form='unformatted',access='direct',recl=4*17)
      open(unit=28,form='unformatted',access='direct',recl=4*17)
      open(unit=29,form='unformatted',access='direct',recl=4*17)
      open(unit=30,form='unformatted',access='direct',recl=4*17)
      open(unit=31,form='unformatted',access='direct',recl=4*17)
      open(unit=32,form='unformatted',access='direct',recl=4*17)
      open(unit=33,form='unformatted',access='direct',recl=4*17)
      open(unit=34,form='unformatted',access='direct',recl=4*17)
c
      open(unit=71,form='formatted')
      open(unit=72,form='formatted')
c************************************************
c
c read in
c
      Do is=1,nss !ICs from jfm to djf

      ifile1=10+2*(is-1)+1
      ifile2=ifile1+1

      iw=0
      do im=1,nesm ! member 1-12
       do iy=1,nyr
        do iv=1,nvar

         iw=iw+1
          read(ifile1,rec=iw) fld1
          do ld=1,nld
          w5d(ld,iv,iy,is,im)=fld1(ld)
          enddo

          read(ifile2,rec=iw) fld2
          do ld=1,nld
          w5d(ld,iv,iy,is,im+nesm)=fld2(ld)
          enddo

        enddo ! iv loop
      enddo ! iy loop
      enddo ! im loop
      enddo ! is loop
c
c write tables
c
 777  format(I4,x,I2,x,I2,x,13f6.2)
c
c for the uncomplete first year
c
      iyyyy=1981
      do iy=1,nyr
c      iyyyy=iyyyy+1
       iss=2
      do is=1,nss
       if(is.le.10) iss=iss+1
       if(is.eq.11) then
       iyyyy=iyyyy+1
       iss=1
       endif
       if(is.eq.12) iss=2
      do im=1,2*nesm
        do ld=5,nld
         outa(ld-4)=w5d(ld,2,iy,is,im)
         outt(ld-4)=w5d(ld,3,iy,is,im)
        enddo
      write(71,777) iyyyy, iss, im, (outa(i),i=1,13)  
      write(72,777) iyyyy, iss, im, (outt(i),i=1,13)  
      enddo !im loop
      enddo !is loop
      enddo !iy loop
c
      STOP
      END
