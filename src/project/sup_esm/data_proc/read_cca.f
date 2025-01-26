      program read_data 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. read ASCII 102CD data from DU
C. IP=1,3,5 means lead0,2,4 prd
C===========================================================
      PARAMETER (mdvs=102,mrec=5000,ICM=12,LD=1)
      PARAMETER (icsy=1979,iytot=27) !icsy: IC starting year
      real fld(mdvs),prd(mdvs,iytot)
c
      open(unit=10,form='formatted')
      open(unit=60,form='formatted')
      open(unit=61,form='formatted')
C     open(unit=20,form='unformatted',access='direct',recl=4*mdvs)

      DO ir=1,mrec
        read(10,666,end=1000) IY,IM,IP,NP,NSTA
        read(10,777,end=1000) fld

      IF(IY.ge.icsy) then
        IF(IM.eq.ICM) then
          IF(IP.eq.LD) then
            do icd=1,mdvs
              prd(icd,IY-icsy+1)=fld(icd)
            enddo
          ENDIF
        ENDIF
      ENDIF

      ENDDO

 1000 continue

C write out raw data
      do iy=3,iytot   !skip first 2-year data (ic in 1979 & 1980)
        do icd=1,mdvs
          fld(icd)=prd(icd,iy)  
        enddo
        write(60,777) fld
      enddo

C filter out trend represented by OCN
      call flt_trd(prd,mdvs,iytot)

C write out HF data
      do iy=3,iytot
        do icd=1,mdvs
          fld(icd)=prd(icd,iy) 
        enddo
        write(61,777) fld
      enddo

  666 format(5I5)
  777 format(10f6.1)

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

