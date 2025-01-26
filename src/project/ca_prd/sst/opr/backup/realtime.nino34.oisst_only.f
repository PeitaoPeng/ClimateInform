      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C write out nino34 index of CA SST forecast
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c
      dimension f2d(imx,jmx)
      dimension c1d(nld)
      dimension tot(nld,nesm+1)
      dimension w2d(nld,nesm+1)
      dimension mld(nld)
C
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx) 
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=14,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=15,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=16,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=17,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=18,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=19,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=21,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=22,form='unformatted',access='direct',recl=4*imx*jmx)
c
      open(unit=61,form='unformatted',access='direct',recl=4*imx*jmx)
c
      open(unit=71,form='unformatted',access='direct',recl=4)
c************************************************
c area of nino34
      is=190
      ie=240
      js=86
      je=95
      do i=1,nld
      mld(i)=i-4
      enddo
c
cc read in sst fcst
      ius=11
      iue=22

      iuc=61
      iuo=71
c
      im=1
      do iu=ius,iue
      do ld=1,nld
c
      irec=5*(ld-1)+1
      read(iu,rec=irec) f2d
      xx=0.
      ng=0
      do i=is,ie
      do j=js,je
        xx=xx+f2d(i,j)
        ng=ng+1
      enddo
      enddo
      w2d(ld,im)=xx/float(ng)
c
      enddo
      im=im+1
      enddo
c
cc ensemble avg
c     
      do ld=1,nld
      xx=0
      do im=1,12
      xx=xx+w2d(ld,im)
      enddo
      w2d(ld,13)=xx/12.
      enddo
c nino34 for clim
      do ld=1,nld
      read(iuc,rec=ld) f2d
      xx=0.
      ng=0
      do i=is,ie
      do j=js,je
        xx=xx+f2d(i,j)
        ng=ng+1
      enddo
      enddo
      c1d(ld)=xx/float(ng)
      enddo
c write out
      iw=0
      nm=nesm+1
      do im=1,nm
      do ld=1,nld
      iw=iw+1
        write(iuo,rec=iw) w2d(ld,im)
      iw=iw+1
        tot(ld,im)=w2d(ld,im)+c1d(ld)
        write(iuo,rec=iw) tot(ld,im)
      enddo
      enddo
c
      write(6,*) 'CA NINO34 based on HAD-OISST'
      write(6,666) (mld(ld),ld=1,nld),'lead(mon)'
      do im=1,nesm
        write(6,888) (tot(ld,im),ld=1,17),im
        write(6,888) (w2d(ld,im),ld=1,17),im
      enddo
      write(6,*) 'ensemble average'
        write(6,888) (tot(ld,nm),ld=1,17)
        write(6,888) (w2d(ld,nm),ld=1,17)
        write(6,*) 'climatology'
        write(6,888) (c1d(ld),ld=1,17)
        write(6,555)
 555  format(/)
 666  format(17I7,A12)
 888  format(17f7.2,I4)
c
      STOP
      END
