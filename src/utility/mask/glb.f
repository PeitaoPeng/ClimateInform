c
      parameter(im1=151,jm1=61)
      parameter(im2=720,jm2=361)

      real*4 a(im1,jm1)
      real*4 b(im2,jm2)

      bad=-9999.00
      do j=1,jm2
      do i=1,im2
       b(i,j)=bad
      enddo
      enddo
    
      open(11,file='LandMaskCONUSdeg0.5pnt.big'
     1 ,form='unformatted',access='direct',recl=im1*jm1*4)
      read(11,rec=1) a

      open(51,file='LandMaskCONUSdeg0.5pnt.big.glb'
     1 ,form='unformatted',access='direct',recl=im2*jm2*4)
c
      do j=1,61
      do i=1,151
       i1=460+i
       j1=220+j
       if(a(i,j).eq.1.0)then 
        b(i1,j1)=a(i,j)
       endif
      enddo
      enddo
c
      write(51,rec=1) b
      stop
      end
