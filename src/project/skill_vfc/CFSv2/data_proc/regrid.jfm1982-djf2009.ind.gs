      'open /export-12/cacsrv1/wd52pp/CFSv2_vfc/0data/Prec_hcst.jfm1982-djf2009.ind.ctl'

t1=jan1982
t2=dec2009
tlong=336

      'set gxout fwrite'
      'set fwrite /export-12/cacsrv1/wd52pp/CFSv2_vfc/0data/Prec_hcst.jfm1982-djf2009.ind.2x2.gr'
*
      nt=1
      while(nt<=tlong)
     'set t 'nt''
      nm=1
      while(nm<=20)
     'd regrid2(f'nm',2,2,ba)'
      nm=nm+1
      endwhile
      nt=nt+1
      endwhile
     'disable fwrite'
