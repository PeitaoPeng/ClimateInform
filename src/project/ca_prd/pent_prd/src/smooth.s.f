      subroutine smooth(fld1,fld2,imax,jmax)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      real fld1(imax,jmax),fld2(imax,jmax)
C
      do i=2,imax-1
      do j=2,jmax-1
      fld2(i,j)=0.5*fld1(i,j)+0.125*(fld1(i-1,j+1)+fld1(i-1,j)+
     &fld1(i-1,j-1)+fld1(i,j+1)+fld1(i,j-1)+fld1(i+1,j+1)+
     &fld1(i+1,j)+fld1(i+1,j-1))
      enddo
      enddo

      i=1
      do j=2,jmax-1
      fld2(i,j)=0.5*fld1(i,j)+0.125*(fld1(imax,j+1)+fld1(imax,j)+
     &fld1(imax,j-1)+fld1(i,j+1)+fld1(i,j-1)+fld1(i+1,j+1)+
     &fld1(i+1,j)+fld1(i+1,j-1))
      enddo

      i=imax
      do j=2,jmax-1
      fld2(i,j)=0.5*fld1(i,j)+0.125*(fld1(1,j+1)+fld1(1,j)+
     &fld1(1,j-1)+fld1(i,j+1)+fld1(i,j-1)+fld1(i-1,j+1)+
     &fld1(i-1,j)+fld1(i-1,j-1))
      enddo

      return
      END

