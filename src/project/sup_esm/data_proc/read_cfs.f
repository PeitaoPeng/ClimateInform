CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      program read_data 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  read ASCII 102CD data from DU
C  For DJF data, IM=11,9,7 & LD=1,3,5 mean 1, 3, 5 month lead
C  For JJA data, IM=5,3,1 & LD=1,3,5 mean 1, 3, 5 month lead
C===========================================================
      PARAMETER (mdvs=102,myr=25,mrec=50000,mens=15)
      PARAMETER (LD=1)
      real fld(mdvs),prd(mdvs,myr,mens)
      real ensm(mdvs,myr)
c
      open(unit=10,form='formatted')
      open(unit=60,form='formatted')
      open(unit=61,form='formatted')
      open(unit=62,form='formatted')

      DO ir=1,mrec

      read(10,666,end=1000) IY,IM,IE,NP,NSTA,NE

      IF(IM.eq.12) then  !pick up needed lead data

        write(60,666) IY,IM,IE,NP,NSTA,NE
        write(6,666) IY,IM,IE,NP,NSTA,NE
        do il=1,6
        read(10,777,end=1000) fld
        write(60,777) fld  !write out lead=1-6 individual runs
          if(il.eq.LD) then
          do id=1,mdvs
            prd(id,IY-1980,1)=fld(id) !keep the first member of lead=1 runs
          enddo
          endif
        enddo

      do je=1,mens-1  !have other 14 members
        read(10,666,end=1000) IY,IM,IE,NP,NSTA,NE
        write(60,666) IY,IM,IE,NP,NSTA,NE
        write(6,666) IY,IM,IE,NP,NSTA,NE
        do il=1,6
        read(10,777,end=1000) fld
        write(60,777) fld
          if(il.eq.LD) then
          do id=1,mdvs
            prd(id,IY-1980,je+1)=fld(id)
          enddo
          endif
        enddo
      enddo

      ELSE 

      do il=1,6
        read(10,777,end=1000) fld
      enddo

      do je=1,mens-1
      read(10,666,end=1000) IY,IM,IE,NP,NSTA,NE
      do il=1,6
        read(10,777,end=1000) fld
      enddo
      enddo

      ENDIF
      
      ENDDO

 1000 continue

C have ensemble mean
      do it=1,myr
      do id=1,mdvs
        ensm(id,it)=0.
        do je=1,mens
          ensm(id,it)=ensm(id,it)+prd(id,it,je)/float(mens)
        enddo
      enddo
      enddo
        
C write out ensm
      do it=1,myr
        do id=1,mdvs
          fld(id)=ensm(id,it)
        enddo
        write(61,777) fld
      enddo
C remove bias caused by the jump around 1990
      call rm_jump(ensm,mdvs,myr)
C remove trend
c     call flt_trd(ensm,mdvs,myr)

C write out adjusted data
      do it=1,myr
        do id=1,mdvs
          fld(id)=ensm(id,it)
        enddo
        write(62,777) fld
      enddo
c
  666 format(6I5)
  777 format(10f6.1)
C 777 format(12f6.1)
      stop
      END
c
      SUBROUTINE rm_jump(wk3d,mdvs,ltime)
      dimension wk3d(mdvs,ltime)

      do id=1,mdvs

      clim=0.
      do it=1,9
      clim=clim+wk3d(id,it)/9.
      enddo
      do it=1,9
      wk3d(id,it)=wk3d(id,it)-clim
      enddo

      clim=0.
      do it=10,ltime
      clim=clim+wk3d(id,it)/float(ltime-9)
      enddo
      do it=10,ltime
      wk3d(id,it)=wk3d(id,it)-clim
      enddo

      enddo

      return
      end

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

