#!/bin/bash
### Script:  11_residual_plot.sh
### Purpose: Plot traveltime residuals change along offset
### Author: S.Y. LAI 2025

if [ $# -eq 0 ]; then
    echo "Error: No arguments provided."
    exit 1
fi


###################################
### DEFINE variable and file path
###################################
id=$1
invdir=out.w1."$1"
log=log.all.$1


N=4/4/4/8/1e-2/1e-3
geom=./geom.dat
smesh=out.w1."$1"/out."$1".smesh.1.1


refrtt=${invdir}/"$1"refr_tt
ini_refrtt=${invdir}/ini_refr_tt
init_mesh=./v2d_50msm.dat

pick=./p13_obstt_alldc4.dat
pick_refrtt=${invdir}/pick_refr_tt



#########################
### forward modelling
#########################
### ttfile format: distance(km),time(s)
### final model
tt_forward -M$smesh -G$geom -T$refrtt -N$N
tt_forward -M$init_mesh -G$geom -T$ini_refrtt -N$N
awk 'NF > 4' $pick | awk '{printf "%4.3f\t%4.2f\n", $2, $5*1000}' > $pick_refrtt 




####################################
### calculate traveltime residuals
### residuals = modelled-observed
####################################
awk 'NF > 1' $refrtt | awk '{printf "%4.3f\t%4.2f\n", $1,$2*1000}' > ${invdir}/misfit
awk 'NF > 1' $ini_refrtt | awk '{printf "%4.3f\t%4.2f\n", $1,$2*1000}' > ${invdir}/ini_misfit



cd $invdir
paste ini_misfit pick_refr_tt > ini_tmp
awk '{printf "%4.3f\t%4.2f\n", $1, $2-$4}' ini_tmp > ini_residuals
paste misfit pick_refr_tt > fn_tmp
awk '{printf "%4.3f\t%4.2f\n", $1, $2-$4}' fn_tmp > fn_residuals

##################################
### plot residuals along distance
##################################
gmt gmtset ANNOT_FONT_SIZE_PRIMARY=12
gmt gmtset LABEL_FONT_SIZE=12
gmt gmtset FONT_TITLE=12
gmt gmtset ANNOT_FONT_SIZE_SECONDARY=12


ps=${id}_residual.ps
ps1=${id}_resbin.ps
Mobs="-Sc0.035 -Gsienna1"
gmt psbasemap -JX15/5.2 -R0/8.78/-150/150 -Bx2f1+l"Profile distance (km)" -By50f10g50+l"Travel-time residuals (ms)" \
-BWeSn+t"modelled - observed traveltimes" -K -Y10 > $ps
gmt psxy ini_residuals -J -R $Mobs -O -K >> $ps
gmt psxy fn_residuals -J -R -Sc0.035 -Gdeepskyblue1 -O -K >> $ps
gmt pslegend -R -J -F+gwhite -Dx0.2i/1.5i+w2.1i/0.5i+jBL+l1.2 -C0.1i/0.1i -B -O << EOF >> $ps
S 0.07 c 0.15 sienna1 0p 0.4 initial residuals x^2=19.4
S 0.07 c 0.15 deepskyblue1 0p 0.4 final residuals x^2=0.8
EOF


##################################
### count of normalised misfits
##################################
awk '{print $2}' ini_residuals | \
gmt pshistogram -JX6/5.5 -T5 -R-200/200/0/250 -Wsienna1 -Gsienna1 -Bx200f50+l"Traveltime residual (ms)" -By50f10+l"count" -BneSW -X19.5 -K > $ps1 
gmt psbasemap -JX -R -B0 -O -K >> $ps1

awk '{print $2}' fn_residuals | \
gmt pshistogram -JX6/5.5 -T5 -R -Wdeepskyblue1 -Gdeepskyblue1 -Bx200f50 -By50f10 -Bnwse -O -K >> $ps1 
gmt psbasemap -JX -R -B0 -O -K >> $ps1

gmt gmtset ANNOT_FONT_SIZE_PRIMARY=12
gmt pslegend -R -J -F+gwhite -Dx0.1i/1.6i+w0.5i/0.5i+jBL+l1.2 -C0.1i/0.1i -B -O << EOF >> $ps1
S 0.07 c 0.15 sienna1 0p 0.4 initial
S 0.07 c 0.15 deepskyblue1 0p 0.4 final
EOF



###########################
## remove temporary files
###########################
gmt psconvert $ps $ps1 -A -Tj
rm $ps $ps1
rm ini_residuals fn_residuals ini_tmp fn_tmp gmt*
rm pick_refr_tt "$1"refr_tt


cd ..
