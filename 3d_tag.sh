#!/bin/bash
#2023/06/07 by Szuying

## this script plots a 3d perspective map for the tag HT field


ps=corrugations_tag.ps
R=-44.827/-44.785/26.138/26.178
xyz2n=topo/M127_AUV_WGS84_2m.xyz
xyz2=topo/TAG_2m.xyz
grd=M127.grd
grd2=2m.grd
grd3=50cm.grd

#cpt1=no_green
cptin=../cpt/temperature.cpt
cpt1=moundmap.cpt
int=tag.int

echo "Phase I: plot the basemap"
gmt set MAP_FRAME_TYPE plain
gmt set PS_PAGE_ORIENTATION=portrait
gmt set FORMAT_GEO_MAP dddmmss
gmt gmtset ANNOT_FONT_SIZE_PRIMARY=13
gmt gmtset LABEL_FONT_SIZE=13
gmt gmtset ANNOT_FONT_SIZE_SECONDARY=13

echo "plotting seismic lines"	

# here I create the colour palette for this bathymetry (actually it is topography not bathymetry as the values below the seafloor are negative) not that is it commented because this needs to be done only once, then we have the colour palette
#gmt makecpt -T-3900/-3100 -Chaxby > $cpt1

## here I plot the bathymetry

#gmt xyz2grd $xyz -R$R -I0.00027 -G$grd -V
#gmt xyz2grd $xyz2 -R$R2n -I0.00005 -G$grd2 -V
#gmt xyz2grd $xyz2n -R$R2 -I0.00005 -G$grd2n -V
#gmt xyz2grd $xyz3 -R$R3 -I0.00007 -G$grd3 -V
gmt grdgradient $grd2 -A240 -G$int -Nt1 -V

## overlay two bathymetry layers
RR=-R-44.827/-44.785/26.148/26.178/-3800/-3200
#RR=-R-44.827/-44.785/26.148/26.178/-3800/-2000

#gmt psbasemap -R-44.827/-44.785/26.148/26.178 -JM5.4i -JZ0.6i -Ba0.5mf0.5m -BSeWnZ -p220/40 -Y10 -K > $ps
# gmt grdview $grd2 $RR -JM5.4i -JZ1i -C$cpt1 -I$int -Ba0.5mf0.5m -BSeWnZ -N-3800+glightgray -Qi500 -p220/40 -K > $ps  ##ori
gmt grdview $grd2 $RR -JM5.4i -JZ1i -C$cpt1 -I$int -Ba0.5mf0.5m -BSeWnZ -N-3800+glightgray -Qi800 -p210/55 -K > $ps  ##new
# gmt grdview $grd3 $RR -JM5.4i -JZ1i -C$cpt1 -I$int -Ba0.5mf0.5m -BSeWnZ -N-3800+glightgray -Qi800 -p210/55 -O -K >> $ps 

#gmt psxyz mound.txt -R-44.827/-44.785/26.148/26.178 -J -JZ -N -p -Sc0.3 -Gred -W0.6 -K -O >> $ps
echo -44.8146 26.17083 -3467 shi > tmp
echo -44.8158	26.15550	-3580 >> tmp
echo -44.8203	26.15866	-3550 >> tmp
gmt psxyz tmp -R-44.827/-44.785/26.148/26.178/-3700/-3200 -J -JZ -p -Sc0.3 -Gred -W0.6 -K -O >> $ps


gmt psxyz p30_shotwdp-short.txt -R-44.827/-44.785/26.148/26.178/-3700/-3200 -J -JZ -N -p -Sc0.09 -Gblack -K -O >> $ps
gmt psxyz p13_shotwdp-short1.txt -R-44.827/-44.785/26.148/26.178/-3700/-3200 -J -JZ -N -p -Sc0.09 -Gblack -O >> $ps




#int=tag.int
#gmt grdimage $grd2 $RR -J -C$cpt1 -I$int -p -K -O -Y15 >> $ps
#gmt psxy mound.txt -R-44.827/-44.785/26.148/26.178 -J -JZ -N -p -Sc0.3 -Gred -W0.6 -O >> $ps
#gmt grdview $grd2 $RR -JZ3.5i -J -C$cpt1 -I$int -N-3800+glightgray -Qi500 -p220/40 -O >> $ps
#gmt psxy p30* -R-44.827/-44.785/26.148/26.178 -J -JZ -Sc0.09 -Gblack -p220/40 -O -K >> $ps
#gmt psxy p13* -R-44.827/-44.785/26.148/26.178 -J -JZ -Sc0.09 -Gblack -p220/40 -O -K >> $ps
#gmt psxy Study_OBS_coord.txt -R-44.827/-44.785/26.148/26.178 -J -JZ -Sc0.3 -Gyellow -W0.6 -p220/40 -O >> $ps


#gmt psscale -C$cpt1 -J -DjBR+w6.5/0.3+o0.5/1c+h -Baf -R -O >> $ps

rm gmt.history
# gmt psconvert $ps -Tj -A
gs $ps
