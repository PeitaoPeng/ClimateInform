      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C write out nino34 index of CA SST forecast
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c
      dimension f2d(imx,jmx),f2d2(imx,jmx)
      dimension c1d(nld)
      dimension w3d(nld,nyr,nesm),w3d2(nld,nyr,nesm)
      dimension out0(nld),out1(nld),out2(nld)
C
      do i=1,80
      iu=10+i
      open(unit=iu,form='unformatted',access='direct',recl=4*imx*jmx) 
      enddo

      open(unit=91,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=92,form='unformatted',access='direct',recl=4*imx*jmx)
c
      open(unit=93,form='unformatted',access='direct',recl=4*nld)
      open(unit=94,form='unformatted',access='direct',recl=4*nld)
c************************************************
c area of nino34
      is=190
      ie=240
      js=86
      je=95
c
      DO isst=1,2 !1=ersst,2=hadoisst
c
cc read in ersst fcst
      if(isst.eq.1) then
      ius=11
      iue=50
      iuc=91
      iuo=93
      else
      ius=51
      iue=90
      iuc=92
      iuo=94
      endif
c
      im=0
      do iu=ius,iue
      im=im+1
c
      do iy=1,nyr
c
      do ld=1,nld
c
c== read fcst
      irec=(iy-1)*2*nld+ld*2
      read(iu,rec=irec) f2d
c== read obs
      irec2=irec-1
      read(iu,rec=irec2) f2d2
c
      xx=0.
      xx2=0.
      ng=0
      do i=is,ie
      do j=js,je
        xx=xx+f2d(i,j)
        xx2=xx2+f2d2(i,j)
        ng=ng+1
      enddo
      enddo
      w3d(ld,iy,im)=xx/float(ng)
      w3d2(ld,iy,im)=xx2/float(ng)
c
      enddo  ! ld
      enddo  ! iy
      enddo  ! iu
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
c
c write out
c
      iw=0
      do im=1,nesm
c
      do iy=1,nyr
        do ld=1,nld
        out1(ld)=w3d(ld,iy,im)
        out2(ld)=w3d(ld,iy,im)+c1d(ld)
        out0(ld)=w3d2(ld,iy,im)
        enddo
      iw=iw+1
        write(iuo,rec=iw) out0
      iw=iw+1
        write(iuo,rec=iw) out1
      iw=iw+1
        write(iuo,rec=iw) out2
      enddo ! iy loop
      enddo ! im loop
c
      ENDDO ! isst loop
c
      STOP
      END
