      parameter(im=360,jm=180)
      real*4 wrk(im,jm)
c
      open(10,access='sequential',form='unformatted'
     1 ,file='mask1X1')
      open(51,access='direct',form='unformatted',recl=im*jm*4
     1 ,file='mask1X1.dat')
c
      bad=-99999.00
      read(10) ((wrk(i,j),i=1,im),j=1,jm)
c
      do j=1,jm
      do i=1,im
         if(wrk(i,j).eq.-1.0) wrk(i,j)=bad
      enddo
      enddo
c
      write(51,rec=1) wrk
c
      stop
      end
