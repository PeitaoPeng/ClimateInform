      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C screen data and get rid of odds
C===========================================================
      real w2d(imx,jmx)
      real clm(imx,jmx,12),std(imx,jmx,12),w3d(imx,jmx,ntot)
      real w4d(imx,jmx,12,ny)

      open(10,form='unformatted',access='direct',recl=4*imx*jmx) !in
      open(20,form='unformatted',access='direct',recl=4*imx*jmx) !out

C=== read in all 3-mon avg tpz
      undef=-9.99E+8

      do it=1,ntot 
        read(10,rec=it) w2d
        do i=1,imx
        do j=1,jmx
          w3d(i,j,it)=w2d(i,j)
        enddo
        enddo
      enddo

C=== screan undef
      do i=1,imx
      do j=1,jmx

      IF(w3d(i,j,1).gt.-900.) then

        do it=1,ntot
          if(w3d(i,j,it).lt.-900.) then
            do kt=1,ntot
            w3d(i,j,kt)=undef
            enddo
          endif
        enddo

      ENDIF

      enddo
      enddo

C have w4d
      ir=0
      do iy=1,ny
      do im=1,12

      ir=ir+1

      if(ir.gt.ntot) go to 101

        do i=1,imx
        do j=1,jmx
          w4d(i,j,im,iy)=w3d(i,j,ir)
        enddo
        enddo

      enddo
      enddo
 101  continue

C=== have clm
      do i=1,imx            
      do j=1,jmx

      IF(w3d(i,j,1).gt.-900.) then

      do im=1,12
          avg=0.
        do iy=1,ny-1
          avg=avg+w4d(i,j,im,iy)
        enddo
          clm(i,j,im)=avg/float(ny-1)
      enddo

      ENDIF

      enddo 
      enddo

C=== std
      do i=1,imx            
      do j=1,jmx

      IF(w3d(i,j,1).gt.-900.) then

      do im=1,12
        ww=0.
      do iy=1,ny-1
        ww=ww+(w4d(i,j,im,iy)-clm(i,j,im))**2
      enddo
        std(i,j,im)=sqrt(ww/float(ny-1))
      enddo

      ENDIF

      enddo 
      enddo

C=== screan too-big data
      id=0
      do iy=1,ny
      do im=1,12

      id=id+1
      if(id.gt.ntot) go to 102


      do i=1,imx
      do j=1,jmx

      IF(w3d(i,j,1).gt.-900.) then

        anom=w4d(i,j,im,iy)-clm(i,j,im)
        if(abs(anom).gt.2.5*std(i,j,im)) then 
          if(anom.gt.0.) w4d(i,j,im,iy)=clm(i,j,im)+std(i,j,im)
          if(anom.lt.0.) w4d(i,j,im,iy)=clm(i,j,im)-std(i,j,im)
        endif
      ENDIF

      enddo
      enddo

      enddo
      enddo

 102  continue

C write out
      iw=0
      do iy=1,ny
      do im=1,12

      iw=iw+1

      if(iw.gt.ntot) go to 104

        do i=1,imx
        do j=1,jmx
          w2d(i,j)=w4d(i,j,im,iy)
        enddo
        enddo

      write(20,rec=iw) w2d

      enddo
      enddo

 104  continue

      stop
      end

