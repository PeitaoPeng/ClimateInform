      parameter(im=360,jm=181)
      real*4 wrk(im,jm)
c
      open(10,access='direct',form='unformatted'
     1 ,file='CFSv2HCST_ocn1x1mask.gr',recl=im*jm*4)
c
      open(51,access='direct',form='unformatted',recl=im*jm*4
     1 ,file='CFSv2HCST_land1x1mask.gr')
c
      read(10,rec=1) wrk
c
      do j=1,jm
      do i=1,im
         if(wrk(i,j).eq.-9999.0) then
          wrk(i,j)=1.0
         else
          wrk(i,j)=0.0
         endif
      enddo
      enddo
c
      write(51,rec=1) wrk
c
      stop
      end
