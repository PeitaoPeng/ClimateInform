CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      program read_data 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C===========================================================
      PARAMETER (mdvs=102,myr=25)
      real wk1d(mdvs),wk3d(mdvs,myr)
c
      open(unit=10,form='formatted')
      open(unit=60,form='formatted')

      DO ir=1,myr
        read(10,777) wk1d
          do id=1,mdvs
            wk3d(id,ir)=wk1d(id)
          enddo
      END DO
      call norm_data(wk3d,mdvs,myr)
      DO ir=1,myr
          do id=1,mdvs
            wk1d(id)=wk3d(id,ir)
          enddo
        write(60,777) wk1d
      END DO
c
 777  format(10f6.1)
      STOP
      end

      SUBROUTINE norm_data(wk3d,mdvs,ltime)
      dimension wk3d(mdvs,ltime)

      do id=1,mdvs
        clim=0.
        do it=1,ltime
        clim=clim+wk3d(id,it)/float(ltime)
        end do

        do it=1,ltime
        wk3d(id,it)=wk3d(id,it)-clim
        end do

        std=0.
        do it=1,ltime
        std=std+wk3d(id,it)*wk3d(id,it)/float(ltime)
        end do
        std=sqrt(std)

        do it=1,ltime
        wk3d(id,it)=wk3d(id,it)/std
        end do
      enddo
c
      return
      end
