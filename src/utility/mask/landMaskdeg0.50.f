      dimension rland(720,360)

      open(10,access='direct',form='unformatted',recl=720*360*4
     1,file='LAND_MASK_LAND-SEA_0.500deg.big')
c
      open(20,access='direct',form='unformatted',recl=720*360*4
     1,file='landMask0.5.gr')
c
      read(10,rec=1) rland
      do j=1,360
      do i=1,720
         if(rland(i,j).gt.0.0) then 
           rland(i,j)=1.0
         else
           rland(i,j)=-999.0
         endif
      end do
      end do
      write(20,rec=1) rland
      stop
      end
cccccccccccccccc


