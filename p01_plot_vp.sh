#!/bin/bash
# make_fig.sh

ps=B_"$1"_vp.ps
ps1=B_"$1"vpnoray.ps


## plotting variables 
X=8.78 
Z=5
cpt=stmodel2ori.cpt
bathy=p13_bathyf.txt ##50m bathymetry


## tomo2d variables
N=4/4/4/8/1e-2/1e-3
ray=ray"$1".dat
src=src.dat
geom=geom1.dat
tt="$1"_tt.dat
smesh=out.w1."$1"/out."$1".smesh.1.1
grd=n"$1"_model.grd


rm $ray ## clear the existing raypath files



tt_forward -M$smesh -Itmp.v0 -G$geom -R$ray -S$src -T$tt -N$N > tt_"$1".dat
./togrid.sh tmp.v0 0 $X 2.5 6 0.05 0.05 $grd



gmt gmtset ANNOT_FONT_SIZE_PRIMARY=16
gmt gmtset LABEL_FONT_SIZE=16
gmt gmtset ANNOT_FONT_SIZE_SECONDARY=16




gmt psbasemap -JX17/-9 -R0/$X/2.7/4.8 -Ba1:"Profile distance (km)":/a0.4f0.1:"Depth (km)":WeSn -Y5 -X2 -K > $ps
gmt grdimage -C$cpt -J -R $grd -O -K >> $ps
gmt grdcontour $grd -C0.5 -A1+f12p -L2.5/8 -J -R -O -K >> $ps
gmt psxy $bathy -JX -R -W0.5 -O -K >> $ps
gmt psxy $ray -JX -R -W0.0001p -O -K >> $ps
gmt psxy $src -JX -R -Sc0.3 -G255/48/48 -W0.9 -O -K >> $ps
gmt psscale -C$cpt -Dx0.6/11+w7/0.2+h -Ba1f0.5 -B+l"Velocity (km/s)" -O >> $ps


gmt psbasemap -JX17/-9 -R0/$X/2.7/4.8 -Ba1:"Profile distance (km)":/a0.4f0.1:"Depth (km)":WeSn -Y5 -X2 -K > $ps1
gmt grdimage -C$cpt -J -R $grd -O -K >> $ps1
gmt grdcontour $grd -C0.5 -A1+f12p -L2.5/8 -J -R -O -K >> $ps1
gmt psxy $bathy -JX -R -W0.5 -O -K >> $ps1
gmt psxy $src -JX -R -Sc0.3 -G255/48/48 -W0.9 -O -K >> $ps1
gmt psscale -C$cpt -Dx0.6/11+w7/0.2+h -Ba1f0.5 -B+l"Velocity (km/s)" -O >> $ps1




gmt psconvert $ps $ps1 -A -Tj
rm gmt.history

