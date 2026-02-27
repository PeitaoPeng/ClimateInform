C     read w.long (station by staion for entire time) and re-organize it
c     to be plot by grads
c
      include "parm.h"
      parameter(nstx=102)  ! nyear --> # of field
      dimension fldin(nstx)
      dimension lalo(nstx,2)
      character*8 stid
                           
      open(11,form='unformatted',access='direct',recl=4*nstx) !input data
c     open(11,form='formatted')     !input data
      open(12,form='formatted')     !lalo102 data
      open(55,status='unknown',form='unformatted')     ! sequential

ccc   read in lat/lon data
      do icd=1,nstx
         read(12,200) lalo(icd,1),lalo(icd,2)
      enddo
200   format(2i8)
c
ccc   converting data
      do ir=1,nyear
      read(11,rec=ir) fldin
c     read(11,888) fldin
c     print *, lalo
      call wrcd102(fldin,lalo,1.,55)
      enddo
 888  format(10f7.1)
c
      stop             
      end	  
c
cccc
c
      subroutine wrcd102(om,lalo102,fak,igrads)
      character*8 cd
      dimension om(102),lalo102(102,2)
      rt=0.0
      nl=1
      nflag=1
      do 10 icd=1,102
c     print *,lalo102(icd,1),lalo102(icd,2)
      cd='       '
      write(cd,'(a8)') icd
      rlat=float(lalo102(icd,1))/100.
      rlon=360.-(float(lalo102(icd,2))/100.)
      fom=fak*om(icd)
      iom=nint(fom)
      write(igrads) cd,rlat,rlon,rt,nl,nflag
      write(igrads) fom
c     print *,cd,rlat,rlon,rt,nl,nflag,fom
10    continue
      cd='       '
      rlat=0.
      rlon=0.
      nl=0
      nflag=0
      write(igrads) cd,rlat,rlon,rt,nl,nflag
      return
      end

