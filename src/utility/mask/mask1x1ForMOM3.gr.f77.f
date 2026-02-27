      parameter(im=360,jm=180)
      real*4 wrk(im,jm)
c
      open(10,access='direct',form='unformatted',recl=im*jm*4
     1 ,file='mask1x1ForMOM3.gr')
      open(51,access='direct',form='unformatted',recl=im*jm*4
     1 ,file='mask1x1ForMOM3.dat')
c
      bad=9.999E+20
      read(10,rec=1) wrk
c
      do j=1,jm
      do i=1,im
         if(wrk(i,j).eq.-999.0) wrk(i,j)=bad
      enddo
      enddo
c
      write(51,rec=1) wrk
c
      stop
      end
