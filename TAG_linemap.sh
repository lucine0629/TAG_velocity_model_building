#!/bin/bash
#2023/01/20 by Szuying

## this script plots the regional map for profile p13(B) & p30(A) 


ps=TAG_loc_map.ps
R=-44.863/-44.73/26.11/26.21
R2=-44.833/-44.78/26.135/26.178
R3=-44.8245/-44.807/26.15/26.16
J=M17c
xyz=M127_bathy.xyz
xyz2=topo/M127_AUV_WGS84_2m.xyz
grd=M127.grd
grd2=2m.grd
cpt1=regionalmap.cpt
int=tag.int






gmt set MAP_FRAME_TYPE plain
gmt set PS_PAGE_ORIENTATION=portrait
gmt set FORMAT_GEO_MAP dddmm





echo "Phase I: plot the basemap"
echo "plotting seismic lines"	
# here I create the colour palette for this bathymetry (actually it is topography not bathymetry as the values below the seafloor are negative) not that is it commented because this needs to be done only once, then we have the colour palette
#gmt makecpt -T-4400/-2400 -Chaxby > $cpt1

## here I plot the bathymetry

#gmt xyz2grd $xyz -R$R -I0.000275 -G$grd -V
#gmt xyz2grd $xyz2 -R$R2 -I0.00005 -G$grd2 -V
gmt grdgradient $grd -A240 -G$int -Nt0.7 -V

## overlay two bathymetry layers
gmt grdimage $grd -R$R -J$J -C$cpt1 -I$int -K -Y8 > $ps
gmt grdimage $grd2 -R$R -J$J -C$cpt1 -I$int1 -O -K >> $ps

gmt grdcontour $grd -R -J$J -C250 -A500+f10p -K -O >> $ps
gmt psbasemap -R$R -J$J -Bf1ma2m:/f1ma1m:NWse -Lx13c/-1c+w5k+f+u -O -K >> $ps




echo "Phase II: plot the shot & obs locations"
# plot the shot line
gmt psxy p30_shotloc.txt -R -J$J -Sc0.05 -Gblack -O -K >> $ps
gmt psxy p13_shotloc.txt -R -J$J -Sc0.05 -Gblack -O -K >> $ps

# plot the mcs profile
gmt psxy mcs19_short_lon.txt -R -J$J -Sc0.05 -Gred -O -K >> $ps

# plot the obs stations
gmt psxy Study_OBS_coord.txt -R -J$J -Sc0.3 -Gwhite -W0.7 -O -K >> $ps

# plot the MIR zone location
gmt psxy -R -J$J -Sc0.2 -Gorange -W0.7 -O -K << EOF >> $ps
-44.8067 26.1450
EOF

gmt psscale -C$cpt1 -J$J -DjBL+w6.5/0.3+o0.5/1c+h -Baf -R -O >> $ps



rm gmt.history
gmt psconvert $ps -Tj
gs $ps
