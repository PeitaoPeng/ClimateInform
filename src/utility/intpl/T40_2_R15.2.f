C******************************************************************
C  have djf avg for Z500 of NMCGCM b9x run
C******************************************************************
      PARAMETER(imax=128,jmax=64)
      PARAMETER(nlon=64,nlat=40)
      real wkin(imax,jmax),wkout(nlon,nlat)
      open(10,file='cac/ccm3/z500ndj_warm_composite.i3e',
     &     access='direct',recl=imax*jmax)
      open(20,file='/export/sgi57/wd52pp/data/data_g15.i3e',
     &     access='direct',recl=nlon*nlat)
      iw=1
      ir=1
      call XSTGRD
      do it=1,1
c     do irun=1,13
      read(10,rec=ir) wkin
      call T40R15(wkin,wkout)
      write(20,rec=iw) wkout
      ir=ir+1
      iw=iw+1
c     end do
      write(6,*) 'it= ',it
      end do

      stop 
      end
      
      

