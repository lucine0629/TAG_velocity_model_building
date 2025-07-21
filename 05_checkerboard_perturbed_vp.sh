#!/bin/bash
## Script: 05_checkerboard_perturbed_vp.sh
## Purpose: Add checkerboard vp anomaly to the velocity model for resolution test
## Author: S.Y. Lai


checksize=v5_25_8
inivel=v2d_50msm.dat
outvel="$checksize"km.dat

edit_smesh $inivel -Cc5/2.5/0.8s > $outvel



##############################
## DEFINE plotting variables 
##############################
ps=A_"$checksize"_chkvp_ini.ps
X=8.78
Z=4.5
bathy=../../p13_bathyf.txt


## tomo2d variables
N=4/4/4/8/1e-2/1e-3
ray=ray"$checksize".dat
src=src.dat
geom=geom1.dat
tt="$checksize"_tt.dat
smesh="$checksize"km.dat
grd="$checksize"_ini_model.grd


rm $ray ## clear the existing raypath files




#################
## ray tracing
#################
tt_forward -M$smesh -Itmp.v0 -G$geom -R$ray -S$src -T$tt -N$N > tt_"$1".dat
