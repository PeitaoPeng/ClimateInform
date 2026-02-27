* have elnino normal lanino year data from intsam
'reinit'
'open prcp_intsmp_5094djfm_run1_12.ctl'
'set x 1 128'
'set y 1 64'
'set gxout fwrite'
'set fwrite prcp_intsmp_elnino_djfm.gr'
tt=0
while(tt<=495)
nt=tt+9
'set t 'nt''
'd z'
nt=tt+17
'set t 'nt''
'd z'
nt=tt+20
'set t 'nt''
'd z'
nt=tt+24
'set t 'nt''
'd z'
nt=tt+34
'set t 'nt''
'd z'
nt=tt+38
'set t 'nt''
'd z'
nt=tt+43
'set t 'nt''
'd z'
*
tt=tt+45
endwhile
*
'reinit'
'open prcp_intsmp_5094djfm_run1_12.ctl'
'set x 1 128'
'set y 1 64'
'set gxout fwrite'
'set fwrite prcp_intsmp_noenso_djfm.gr'
tt=0
while(tt<=495)
nt=tt+3
'set t 'nt''
'd z'
nt=tt+8
'set t 'nt''
'd z'
nt=tt+11
'set t 'nt''
'd z'
nt=tt+12
'set t 'nt''
'd z'
nt=tt+30
'set t 'nt''
'd z'
nt=tt+33
'set t 'nt''
'd z'
nt=tt+45
'set t 'nt''
'd z'
*
tt=tt+45
endwhile
*
'reinit'
'open prcp_intsmp_5094djfm_run1_12.ctl'
'set x 1 128'
'set y 1 64'
'set gxout fwrite'
'set fwrite prcp_intsmp_lanino_djfm.gr'
tt=0
while(tt<=495)
nt=tt+1
'set t 'nt''
'd z'
nt=tt+6
'set t 'nt''
'd z'
nt=tt+22
'set t 'nt''
'd z'
nt=tt+25
'set t 'nt''
'd z'
nt=tt+27
'set t 'nt''
'd z'
nt=tt+36
'set t 'nt''
'd z'
nt=tt+40
'set t 'nt''
'd z'
*
tt=tt+45
endwhile
