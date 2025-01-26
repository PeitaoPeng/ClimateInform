      program clim_anom
      PARAMETER (imax=72,jmax=37,npen=73,nyrs=24)
      real fld(imax,jmax)
      real fld2(imax,jmax)
c
      open(unit=10,form='unformatted',access='direct',recl=imax*jmax)
      open(unit=20,form='unformatted',access='direct',recl=imax*jmax)
c
      
cc get data
      it=1
      do ny=1,nyrs
      do np=1,npen
      read(10,rec=it) fld
        do i=2,imax-1
        do j=2,jmax-1
        fld2(i,j)=0.5*fld(i,j)+0.0625*(fld(i-1,j)+fld(i+1,j)+
     &fld(i+1,j-1)+fld(i+1,j+1)+fld(i-1,j-1)+fld(i-1,j+1)+
     &fld(i,j+1)+fld(i,j-1))
        enddo
        enddo
        do i=1,1
        do j=2,jmax-1
        fld2(i,j)=0.5*fld(i,j)+0.0625*(fld(imax,j)+fld(i+1,j)+
     &fld(i+1,j-1)+fld(i+1,j+1)+fld(imax,j-1)+fld(imax,j+1)+
     &fld(i,j+1)+fld(i,j-1))
        enddo
        enddo
        do i=imax,imax
        do j=2,jmax-1
        fld2(i,j)=0.5*fld(i,j)+0.0625*(fld(i-1,j)+fld(1,j)+
     &fld(1,j-1)+fld(1,j+1)+fld(i-1,j-1)+fld(i-1,j+1)+
     &fld(i,j+1)+fld(i,j-1))
        enddo
        enddo
      it=it+1
        write(20) fld2
      enddo
      enddo
      
      stop
      END

      subroutine change(i,j,fld,imax,jmax)
      dimension fld(imax,jmax)
        a=fld(i+1,j)
        b=fld(i-1,j)
        c=fld(i,j+1)
        d=fld(i,j-1)
        fld(i,j)=AMAX1(a,b,c,d)
      return
      end

