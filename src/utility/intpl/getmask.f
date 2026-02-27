      program REG2GAU
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  (1,0) means (use,void)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      PARAMETER (imax=180,jmax=89)
      real grd(imax,jmax),mask(imax,jmax)
C
      open(unit=11,form='unformated',access='direct',recl=imax*jmax)
      open(unit=21,form='unformated',access='direct',recl=imax*jmax)
C
      read(11) grd
      do i=1,imax
      do j=1,jmax
        if(abs(grd(i,j)).gt.90) then
        mask(i,j)=0
        else
        mask(i,j)=1
        end if
      end do
      end do
      write(21) mask
      write(6,*) mask

      stop
      END
