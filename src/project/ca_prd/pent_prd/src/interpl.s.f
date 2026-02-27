      subroutine interpl(fld,wk,kndef,imx,jmx)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c fill undef grid with data in surounding grids
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      real fld(imx,jmx)
      real wk(imx+2,jmx+2)
c
c expand fld to wk
c
      do i=1,imx
      do j=1,jmx
        wk(i+1,j+1)=fld(i,j)
      enddo
      enddo
      do j=1,jmx
        wk(1,j)=fld(imx,j)
        wk(imx+2,j)=fld(1,j)
      enddo
      do i=1,imx
        wk(i,1)=fld(i,2)
        wk(i,jmx+2)=fld(i,jmx-1)
      enddo
c
c interpolation
c
      do i=1,imx
      do j=1,jmx

      if(fld(i,j).eq.kundef) then

      fld(i,j)=0.
      ngrd=0
      do iw=i,i+2
      do jw=j,j+2

      ii=i+1
      jj=j+1
      if(iw.eq.ii.and.jw.eq.jj) go to 777 
      if(wk(iw,jw).ne.kundef) then
        ngrd=ngrd+1
        fld(i,j)=fld(i,j)+wk(iw,jw)
      endif

  777 continue
      enddo
      enddo
      fld(i,j)=fld(i,j)/float(ngrd)

      endif

      enddo
      enddo

      RETURN
      END

