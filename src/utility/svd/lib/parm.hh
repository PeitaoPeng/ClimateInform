c  SET:
c
c  nmon = # days/mons/seasons/whatever
c  nyrs = # years
c  nmax   = largest possible #pts (or max(nmaxl,nmaxr))
c  nmaxl  = can set explicitly to # of LEFT field points
c  nmaxr  = can set explicitly to # of RIGHT field points
c  ndimsv = min(nmaxl,nmaxr)
c  idl = inner dimension of LEFT field
c  jdl = outer dimension of LEFT field
c  idr = inner dimension of RIGHT field
c  jdr = outer dimension of RIGHT field
c  nf  = # of modes starting at 1st to keep
c
      parameter (nmon=1)
      parameter (nyr=42)
      parameter (idl=48,jdl=40)
      parameter (idr=48,jdr=40)
      parameter (nmax=400)
      parameter (nmaxl=nmax)
      parameter (nmaxr=nmax)
      parameter (ndimsv=nmax)
      parameter (nf=5)
      parameter (lrsvd=1)
      parameter (nrot=20)
