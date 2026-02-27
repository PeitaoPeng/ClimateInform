      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C write out nino34 index of CA SST forecast
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c
      dimension wic(imx,jmx)
      dimension w2d(imx,jmx)
      dimension w3d(imx,jmx,nld)
      dimension w4d(imx,jmx,nld,nesm)
      dimension clim(imx,jmx,19)
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
      open(unit=31,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=32,form='unformatted',access='direct',recl=4*imx*jmx)
c
      open(unit=61,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=62,form='unformatted',access='direct',recl=4*imx*jmx)
c
c************************************************
c
cc read in fcst
      undef=-9.99E+08
      ius=11
      iue=22
c
      im=1
      do iu=ius,iue
      do ld=1,nld
c
      read(iu,rec=ld) w2d
      do i=1,imx
      do j=1,jmx
        w4d(i,j,ld,im)=w2d(i,j)
      enddo
      enddo
c
      enddo
      im=im+1
      enddo
c
c* read in clim
      do ic=1,19
      read(31,rec=ic) w2d
      do i=1,imx
      do j=1,jmx
        clim(i,j,ic)=w2d(i,j)
      enddo
      enddo
      enddo
c
c* read in ic
      read(32,rec=1) wic
c
cc ensemble avg
c     
      do ld=1,nld
      do i=1,imx
      do j=1,jmx
c
      w3d(i,j,ld)=0.
      do im=1,nesm
      w3d(i,j,ld)=w3d(i,j,ld)+w4d(i,j,ld,im)
      enddo
      w3d(i,j,ld)=w3d(i,j,ld)/float(nesm)
      enddo
      enddo
      enddo
c
c write out ic
      iw=1
      write(61,rec=iw) wic
      do i=1,imx
      do j=1,jmx
      if(clim(i,j,1).gt.-1000) then
        w2d(i,j)=wic(i,j)+clim(i,j,1)
      else
        w2d(i,j)=undef
      endif
      enddo
      enddo
      write(62,rec=iw) w2d
c
c write out forecast
      do ld=2,nld-2
      iw=iw+1

      do i=1,imx
      do j=1,jmx
      if(clim(i,j,1).gt.-1000) then
        w2d(i,j)=w3d(i,j,ld)
      else
        w2d(i,j)=undef
      endif
      enddo
      enddo
      write(61,rec=iw) w2d
c
      do i=1,imx
      do j=1,jmx
      if(clim(i,j,1).gt.-1000) then
        w2d(i,j)=clim(i,j,ld)+w3d(i,j,ld)
      else
        w2d(i,j)=undef
      endif
      enddo
      enddo
      write(62,rec=iw) w2d

      enddo !ld loop
c
      STOP
      END
