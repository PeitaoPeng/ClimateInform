      program caprd
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C write out nino34 index of CA SST forecast
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c
      dimension f2d(imx,jmx),f2d2(imx,jmx)
      dimension w4dm(nld,nyr,imx,jmx),w4do(nld,nyr,imx,jmx)
      dimension w6d(2,nld,nyr,nesm,imx,jmx)
C
      do iu=11,90
      open(unit=iu,form='unformatted',access='direct',recl=4*imx*jmx) 
      enddo
c
      open(unit=91,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=92,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=93,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=94,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=95,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=96,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=97,form='unformatted',access='direct',recl=4*imx*jmx)
c************************************************
c
      DO isst=1,2 !1=ersst,2=hadoisst
c
cc read in ersst fcst
      if(isst.eq.1) then !ersst
      ius=11
      iue=50
      else               !hadoisst
      ius=51
      iue=90
      endif
c
      im=0
      do iu=ius,iue
      im=im+1
c
      do iy=1,nyr
      do ld=1,nld
c
c== read fcst
      irec=(iy-1)*2*nld+ld*2
      read(iu,rec=irec) f2d
      do i=1,imx
      do j=1,jmx
        w6d(isst,ld,iy,im,i,j)=f2d(i,j)
      enddo
      enddo
c== read obs
      irec2=irec-1
      read(iu,rec=irec2) f2d2
      do i=1,imx
      do j=1,jmx
        w4do(ld,iy,i,j)=f2d2(i,j)
      enddo
      enddo
c
      enddo  ! ld
      enddo  ! iy
      enddo  ! iu
      ENDDO  ! isst loop
c
C esm for all hcst *sst,eof,mics)
c
      xesm=2.*float(nesm)
      do iy=1,nyr
      do ld=1,nld
      do i=1,imx
      do j=1,jmx
          w4dm(ld,iy,i,j)=0.
          do isst=1,2
          do im=1,nesm
          w4dm(ld,iy,i,j)=w4dm(ld,iy,i,j)+w6d(isst,ld,iy,im,i,j)/xesm
          enddo
          enddo
c
        if(abs(w4do(ld,iy,i,j)).gt.1000) then
          w4do(ld,iy,i,j)=undef
        endif
      enddo ! j
      enddo ! i
      enddo ! ld
      enddo ! iy
C assign undef to land grid
      do iy=1,nyr
      do ld=1,nld
      do i=1,imx
      do j=1,jmx
        if(abs(w4dm(ld,iy,i,j)).gt.1000) then
          w4dm(ld,iy,i,j)=undef
        endif
      enddo ! j
      enddo ! i
      enddo ! ld
      enddo ! iy
C write out CA and OBS
      iw=0
      do iy=1,nyr
      do ld=1,nld
        do i=1,imx
        do j=1,jmx
          f2d(i,j)=w4dm(ld,iy,i,j)
          f2d2(i,j)=w4do(ld,iy,i,j)
        enddo
        enddo
        iw=iw+1
        write(91,rec=iw) f2d2
        iw=iw+1
        write(91,rec=iw) f2d
      enddo
      enddo
c
C esm for differnt sst
c
      iuo=91
      xesm=float(nesm)
      do isst=1,2
      iuo=iuo+1

      do iy=1,nyr
      do ld=1,nld
      do i=1,imx
      do j=1,jmx
          w4dm(ld,iy,i,j)=0.
          do im=1,nesm
          w4dm(ld,iy,i,j)=w4dm(ld,iy,i,j)+w6d(isst,ld,iy,im,i,j)/xesm
          enddo
c
        if(abs(w4do(ld,iy,i,j)).gt.1000) then
          w4do(ld,iy,i,j)=undef
        endif
      enddo ! j
      enddo ! i
      enddo ! ld
      enddo ! iy
C assign undef to land grid
      do iy=1,nyr
      do ld=1,nld
      do i=1,imx
      do j=1,jmx
        if(abs(w4dm(ld,iy,i,j)).gt.1000) then
          w4dm(ld,iy,i,j)=undef
        endif
      enddo ! j
      enddo ! i
      enddo ! ld
      enddo ! iy
C write out CA and OBS
      iw=0
      do iy=1,nyr
      do ld=1,nld
        do i=1,imx
        do j=1,jmx
          f2d(i,j)=w4dm(ld,iy,i,j)
          f2d2(i,j)=w4do(ld,iy,i,j)
        enddo
        enddo
        iw=iw+1
        write(iuo,rec=iw) f2d2
        iw=iw+1
        write(iuo,rec=iw) f2d
      enddo
      enddo
      enddo ! isst loop
c
C esm for differnt ICs
c
      iuo=93
      xesm=2*float(neof)
      do ics=1,4
      iuo=iuo+1

      do iy=1,nyr
      do ld=1,nld
      do i=1,imx
      do j=1,jmx
          w4dm(ld,iy,i,j)=0.
          do isst=1,2
          do im=1,neof
          imm=(ics-1)*10+im
          w4dm(ld,iy,i,j)=w4dm(ld,iy,i,j)+w6d(isst,ld,iy,imm,i,j)/xesm
          enddo
          enddo
c
        if(abs(w4do(ld,iy,i,j)).gt.1000) then
          w4do(ld,iy,i,j)=undef
        endif
      enddo ! j
      enddo ! i
      enddo ! ld
      enddo ! iy
C assign undef to land grid
      do iy=1,nyr
      do ld=1,nld
      do i=1,imx
      do j=1,jmx
        if(abs(w4dm(ld,iy,i,j)).gt.1000) then
          w4dm(ld,iy,i,j)=undef
        endif
      enddo ! j
      enddo ! i
      enddo ! ld
      enddo ! iy
C write out CA and OBS
      iw=0
      do iy=1,nyr
      do ld=1,nld
        do i=1,imx
        do j=1,jmx
          f2d(i,j)=w4dm(ld,iy,i,j)
          f2d2(i,j)=w4do(ld,iy,i,j)
        enddo
        enddo
        iw=iw+1
        write(iuo,rec=iw) f2d2
        iw=iw+1
        write(iuo,rec=iw) f2d
      enddo
      enddo
      enddo ! ics loop
      
      STOP
      END
