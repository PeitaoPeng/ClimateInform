      parameter(im=180,jm=139)
      real*4 wrk(im,jm)
c
      open(10,access='direct',form='unformatted'
     1 ,file='mask2x1FullMOM3.gr',recl=im*jm*4)
      open(51,access='direct',form='unformatted',recl=im*jm*4
     1 ,file='mask2x1Full.gr')
c
      bad=-999.00
      read(10,rec=1) wrk
c
      do j=1,jm
      do i=1,im
         if(wrk(i,j).gt.999.0) then
          wrk(i,j)=bad
         else
          wrk(i,j)=1.0
         endif
      enddo
      enddo
c
      write(51,rec=1) wrk
c
      stop
      end
