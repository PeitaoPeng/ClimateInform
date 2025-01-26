      program clim_anom
      PARAMETER (imax=144,jmax=73,ltime=1789)
      real fld(imax,jmax)
c
      open(unit=10,form='unformatted',access='direct',recl=imax*jmax)
      open(unit=20,form='unformatted',access='direct',recl=imax*jmax)
c
      
cc get data
      do it=1,ltime
       read(10,rec=it) fld
        do i=1,imax
        do j=1,jmax
          if(fld(i,j).lt.-9000) then
          call change(i,j,fld,imax,jmax)
          endif
        enddo
        enddo
        write(20,rec=it) fld
      enddo
      
      stop
      END

      subroutine change(i,j,fld,imax,jmax)
      dimension fld(imax,jmax)
        a=fld(i+1,j)
        b=fld(i+1,j+1)
        c=fld(i+1,j-1)
        d=fld(i-1,j)
        e=fld(i-1,j+1)
        f=fld(i-1,j-1)
        g=fld(i,j+1)
        h=fld(i,j-1)
        fld(i,j)=AMAX1(a,b,c,d,e,f,g,h)
c       fld(i,j)=0.
      return
      end

