* regrid to 0.5X0.5 grid for T62
'open LandMaskCONUSdeg0.5pnt.big.glb.ctl'
'set lat -90 90'
'set lon  0 360'
'set gxout fwrite'
'set fwrite LandMaskCONUSt62.gr'
'd regrid2(land,192,94,gg)'
