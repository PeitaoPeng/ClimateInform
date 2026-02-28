      subroutine rdfld(iunit,fld,nharm)
      dimension fld(nharm)
      character*8 on84lb(6)
      write(6,*) 'iunit=',iunit
c     read(iunit) on84lb,fld
      read(iunit) fld
      return
      end
