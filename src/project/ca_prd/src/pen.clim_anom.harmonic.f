      program clim_anom
      PARAMETER (imax=72,jmax=72,npen=73,nyrs=24)
      real fld(imax,jmax),clim(imax,jmax,npen)
      real fld4d(imax,jmax,npen,nyrs)
c
      open(unit=10,form='unformatted',access='direct',recl=imax*jmax)
      open(unit=20,form='unformatted',access='direct',recl=imax*jmax)
      open(unit=30,form='unformatted',access='direct',recl=imax*jmax)
c
      
cc get data
      PI=3.14159
      it=1
      do ny=1,nyrs
      do np=1,npen
      read(10,rec=it) fld
        do i=1,imax
        do j=1,jmax
c         if(fld(i,j).lt.-9000) then
c         call change(i,j,fld,imax,jmax)
c         endif
          fld4d(i,j,np,ny)=fld(i,j)
        enddo
        enddo
      it=it+1
      enddo
      enddo
cc have clim
      do np=1,npen
      do i=1,imax
      do j=1,jmax
        clim(i,j,np)=0.
      enddo
      enddo
      enddo
    
      do np=1,npen
      do i=1,imax
      do j=1,jmax
       do ny=1,nyrs
        clim(i,j,np)=clim(i,j,np)+fld4d(i,j,np,ny)/float(nyrs)
       enddo
      enddo
      enddo
      enddo
cc smooth clim by harmonic
      do i=1,imax
      do j=1,jmax
        do np=1,npen
          a1=clim(i,j,np)*cos(np*2*PI/npen)
          b1=clim(i,j,np)*sin(np*2*PI/npen)
        enddo
      enddo
      enddo
cc write out anom
      do ny=1,nyrs
      do np=1,npen

      do i=1,imax
      do j=1,jmax
        fld(i,j)=fld4d(i,j,np,ny)-clim(i,j,np)
      enddo
      enddo
        write(20) fld
      enddo
      enddo

cc write out anom
      do np=1,npen
      do i=1,imax
      do j=1,jmax
        fld(i,j)=clim(i,j,np)
      enddo
      enddo
        write(30) fld
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

