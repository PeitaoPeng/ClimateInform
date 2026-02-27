      program skill
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
      PARAMETER (ncd=102,imax=36,jmax=19,nt=49)
      real fmod(imax,jmax)
      real obs(imax,jmax)
      real xlat(jmax),mask(imax,jmax)
      real coslat(jmax)
      real rms1(maxt),rms2(maxt),rms3(maxt)
      real acc1(maxt),acc2(maxt),acc3(maxt)
c
      open(unit=10,form='unformated',access='direct',recl=imax*jmax)
      open(unit=20,form='unformated',access='direct',recl=imax*jmax)
      open(unit=30,form='unformated',access='direct',recl=maxt)
c
c  have coslat
c
      do j=1,jmax
         xlat(j)=2.5*(j-1)-90
      end do
c
      do j=1,jmax
        coslat(j)=cos(xlat(j)*3.14159/180)
      enddo
c
c...input data is from Sounth to North
      latnh1=37
      latnh2=73

      latpna1=45
      latpna2=73
      lonpna1=61
      lonpna2=121
c
ccc have 1-D acc for TROP NH SH area
c
      totalacc1=0
      totalrms1=0
      totalacc2=0
      totalrms2=0
      totalacc3=0
      totalrms3=0
      do 2000 ir=1,maxt

      read(20,rec=ir) obs
      read(10,rec=ir) fmod   !esm avg

C global
      call acc(fmod,obs,coslat,jmax,imax,
     '1,jmax,1,imax,acc1(ir))

      call rms(fmod,obs,coslat,jmax,imax,
     '1,jmax,1,imax,rms1(ir))

C NH
      call acc(fmod,obs,coslat,jmax,imax,
     '37,jmax,1,imax,acc2(ir))

      call rms(fmod,obs,coslat,jmax,imax,
     '37,jmax,1,imax,rms2(ir))

C PNA
      call acc(fmod,obs,coslat,jmax,imax,
     'latpna1,latpna2,lonpna1,lonpna2,acc3(ir))

      call rms(fmod,obs,coslat,jmax,imax,
     'latpna1,latpna2,lonpna1,lonpna2,rms3(ir))

      totalacc1=totalacc1+acc1(ir)/float(maxt)
      totalrms1=totalrms1+rms1(ir)/float(maxt)
      totalacc2=totalacc2+acc2(ir)/float(maxt)
      totalrms2=totalrms2+rms2(ir)/float(maxt)
      totalacc3=totalacc3+acc3(ir)/float(maxt)
      totalrms3=totalrms3+rms3(ir)/float(maxt)

 2000 continue
      write(6,*)"totalacc for global=",totalacc1
      write(6,*)"totalrms for global=",totalrms1
      write(6,*)"totalacc for NH=",totalacc2
      write(6,*)"totalrms for NH=",totalrms2
      write(6,*)"totalacc for PNA=",totalacc3
      write(6,*)"totalrms for PNA=",totalrms3
      write(30) acc1
      write(30) rms1
      write(30) acc2
      write(30) rms2
      write(30) acc3
      write(30) rms3

      stop
      END


      SUBROUTINE setzero(fld,n,m)
      DIMENSION fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end

      SUBROUTINE acc(fld1,fld2,coslat,jmax,imax,
     'lat1,lat2,lon1,lon2,cor)

      real fld1(imax,jmax),fld2(imax,jmax),coslat(jmax)

      area=0
      do j=lat1,lat2
      do i=lon1,lon2
        area=area+coslat(j)
      enddo
      enddo


      cor=0.
      sd1=0.
      sd2=0.

      do j=lat1,lat2
      do i=lon1,lon2
         cor=cor+fld1(i,j)*fld2(i,j)*coslat(j)/area
         sd1=sd1+fld1(i,j)*fld1(i,j)*coslat(j)/area
         sd2=sd2+fld2(i,j)*fld2(i,j)*coslat(j)/area
      enddo
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      cor=100*cor/(sd1*sd2)

      return
      end

      SUBROUTINE rms(fld1,fld2,coslat,jmax,imax,
     'lat1,lat2,lon1,lon2,cor)

      real fld1(imax,jmax),fld2(imax,jmax),coslat(jmax)

      area=0
      do j=lat1,lat2
      do i=lon1,lon2
        area=area+coslat(j)
      enddo
      enddo


      cor=0.

      do j=lat1,lat2
      do i=lon1,lon2
         cor=cor+((fld1(i,j)-fld2(i,j))**2)*coslat(j)/area
      enddo
      enddo

      cor=cor**0.5

      return
      end



      SUBROUTINE accavg(acc,sd1,sd2,coslat,jmax,imax,
     '                  lat1,lat2,lon1,lon2,cor)

      real acc(imax,jmax),coslat(jmax)
      real sd1(imax,jmax),sd2(imax,jmax)

      area=0
      do j=lat1,lat2
      do i=lon1,lon2
        area=area+coslat(j)
      enddo
      enddo

      cor=0.
      do j=lat1,lat2
      do i=lon1,lon2

        if(acc(i,j).lt.0..and.(sd1(i,j)/sd2(i,j)).lt.1) then
c       acc(i,j)=acc(i,j)*(sd1(i,j)/sd2(i,j))
        endif

        cor=cor+acc(i,j)*coslat(j)/area

      enddo
      enddo

      return
      end

      SUBROUTINE norsou(fldin,fldot,lon,lat)
      dimension fldin(lon,lat),fldot(lon,lat)
      do 100 j=1,lat
      do 100 i=1,lon
         fldot(i,j)=fldin(i,lat+1-j)
  100 continue
      return
      end

      SUBROUTINE wtout(fld,lon,lat,lat1,lat2,lon1,lon2)
      dimension fld(lon,lat)
      do 100 j=lat1,lat2
      do 100 i=lon1,lon2
         write(6,*) 'i,j= ',i,j,fld(i,j)
  100 continue
      return
      end

      SUBROUTINE accmaskavg(acc,mask,sd1,sd2,coslat,jmax,imax,
     '                  lat1,lat2,lon1,lon2,cor)

      real acc(imax,jmax),coslat(jmax),mask(imax,jmax)
      real sd1(imax,jmax),sd2(imax,jmax)

      area=0
      do j=lat1,lat2
      do i=lon1,lon2
        if(mask(i,j).lt.0) then
        area=area+coslat(j)
        endif
      enddo
      enddo

      cor=0.
      do j=lat1,lat2
      do i=lon1,lon2

        if(mask(i,j).lt.0) then

        if(acc(i,j).lt.0..and.(sd1(i,j)/sd2(i,j)).lt.1) then
c       acc(i,j)=acc(i,j)*(sd1(i,j)/sd2(i,j))
        endif

        cor=cor+acc(i,j)*coslat(j)/area

        end if

      enddo
      enddo

      return
      end


      SUBROUTINE maskout(fld,mask,lon,lat)
      dimension fld(lon,lat),mask(lon,lat)
      do  j=1,lat
      do  i=1,lon
        if(mask(i,j).gt.0) then
          fld(i,j)=-999.0
        endif
      end do
      end do
      return
      end


