      program read_data 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. read ASCII 102CD data from DU ang get 3-month mean
C===========================================================
      PARAMETER (mdvs=102,nmo=12,mrec=8000)
c     PARAMETER (isy=1972,iytot=35) !isy: starting year
c     PARAMETER (mon1=1,mon2=2,mon3=3)  !1-2-3 mean corespond to JFM
      PARAMETER (isy=1951,iytot=51) !isy: starting year
      PARAMETER (mon1=12,mon2=1,mon3=2) !12-1-2 mean corespond to DJF
      real fld(mdvs),obs3d(mdvs,iytot,nmo)
      real obs2d(mdvs,iytot)
c
      open(unit=10,form='formatted')
      open(unit=60,form='formatted')
      open(unit=61,form='formatted')
C     open(unit=20,form='unformatted',access='direct',recl=4*mdvs)

      DO ir=1,mrec
      read(10,666,end=1000) IY,IM,IH,NSTA
      read(10,777,end=1000) fld

      IF(IY.ge.isy) then

      if(IM.eq.1) then
      do icd=1,mdvs
        obs3d(icd,IY-isy+1,1)=fld(icd)
      enddo
      endif

      if(IM.eq.2) then
      do icd=1,mdvs
        obs3d(icd,IY-isy+1,2)=fld(icd)
      enddo
      endif

      if(IM.eq.3) then
      do icd=1,mdvs
        obs3d(icd,IY-isy+1,3)=fld(icd)
      enddo
      endif

      if(IM.eq.4) then
      do icd=1,mdvs
        obs3d(icd,IY-isy+1,4)=fld(icd)
      enddo
      endif

      if(IM.eq.5) then
      do icd=1,mdvs
        obs3d(icd,IY-isy+1,5)=fld(icd)
      enddo
      endif

      if(IM.eq.6) then
      do icd=1,mdvs
        obs3d(icd,IY-isy+1,6)=fld(icd)
      enddo
      endif

      if(IM.eq.7) then
      do icd=1,mdvs
        obs3d(icd,IY-isy+1,7)=fld(icd)
      enddo
      endif

      if(IM.eq.8) then
      do icd=1,mdvs
        obs3d(icd,IY-isy+1,8)=fld(icd)
      enddo
      endif

      if(IM.eq.9) then
      do icd=1,mdvs
        obs3d(icd,IY-isy+1,9)=fld(icd)
      enddo
      endif

      if(IM.eq.10) then
      do icd=1,mdvs
        obs3d(icd,IY-isy+1,10)=fld(icd)
      enddo
      endif

      if(IM.eq.11) then
      do icd=1,mdvs
        obs3d(icd,IY-isy+1,11)=fld(icd)
      enddo
      endif

      if(IM.eq.12) then
      do icd=1,mdvs
        obs3d(icd,IY-isy+1,12)=fld(icd)
      enddo
      endif
c
      ENDIF
c
      END DO
 1000 continue

c     do iy=1,iytot
      do iy=1,iytot-1  !for DJF
      do icd=1,mdvs
        obs2d(icd,iy)=(obs3d(icd,iy,mon1)+            !for DJF
     &  obs3d(icd,iy+1,mon2)+obs3d(icd,iy+1,mon3))/3. !for DJF
c       obs2d(icd,iy)=(obs3d(icd,iy,mon1)+      !for JFM
c    &  obs3d(icd,iy,mon2)+obs3d(icd,iy,mon3))/3.
      enddo
      enddo
c write out raw data
c     do iy=11,iytot
c     do iy=11,iytot-1  !for DJF
      do iy=1,iytot-1  !for DJF
        do icd=1,mdvs
          fld(icd)=obs2d(icd,iy)
        enddo
        write(60,888) fld
      enddo

C filter out trend represented by OCN
      call flt_trd(obs2d,mdvs,iytot)

C write out HF data
c     do iy=11,iytot
c     do iy=11,iytot-1    !for DJF
      do iy=1,iytot-1    !for DJF
        do icd=1,mdvs
          fld(icd)=obs2d(icd,iy)  !skip first 10-year data
        enddo
        write(61,888) fld
      enddo

  666 format(4I4)
  777 format(12f6.1)
  888 format(10f6.1)

      stop
      END


C filter out OCN trend
      SUBROUTINE flt_trd(wk3d,mdvs,ltime)
      dimension wk3d(mdvs,ltime)

      do id=1,mdvs

      clim=0.
      do it=1,ltime
      clim=clim+wk3d(id,it)/float(ltime)
      enddo
      do it=1,ltime
      wk3d(id,it)=wk3d(id,it)-clim
      enddo

      enddo

      do id=1,mdvs
      do it=11,ltime

      runm=0.
      do iit=1,10
      runm=runm+wk3d(id,it-iit)/10.
      enddo
      wk3d(id,it)=wk3d(id,it)-runm

      enddo
      enddo

      return
      end
