      open(16,file='lalo102',form='formatted')! input data
c*c*************************************************
      do i=1,102
      read(16,120)lalo102(i,1),lalo102(i,2)
      enddo
c*c*************************************************
c     call wrcd102(tfor,lalo102,1.,45,55)
c*c*************************************************
      subroutine wrcd102(om,lalo102,fak,ichan,igrads)
      character*8 cd
      dimension om(102),lalo102(102,2)
      rt=0.0
      nl=1
      nflag=1
      do 10 icd=1,102
      cd='       '
      write(cd,'(a8)') icd
      rlat=float(lalo102(icd,1))/100.
      rlon=360.-(float(lalo102(icd,2))/100.)
      fom=fak*om(icd)
      iom=nint(fom)
      write(ichan,100)iom,lalo102(icd,1),lalo102(icd,2)
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
100   format(3i8)
      return
      end
c
