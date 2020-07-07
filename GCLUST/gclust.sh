#!/bin/bash

# MVL 07/07/2020
# This bash script will do the entire GCLUST pipeline in one go but this is specific to grabbing where specific files are located for the UK Biobank dataset. If we want to run it on another dataset, it needs to be modified to look for the relevant files for another dataset.
#

# load relevant modules for doing stuff with Freesurfer and MATLAB
module load freesurfer/6.0.0
module load matlab/r2019b

# this was in gclust.csh but not sure if I need it.
source $FREESURFER_HOME/SetUpFreeSurfer.sh # edit as necessary

# directory where fsaverage is located
fsavgdir=$FREESURFER_HOME/subjects/fsaverage

# set the rootdir where all the UK Biobank Imaging data will be kept
rootdir=/rds/project/rb643/rds-rb643-ukbiobank2/Data_Imaging

# GCLUST GitHub repo directories
gclustdir=/home/ml437/code/GCLUST
matlabdir=$gclustdir/GCLUST/matlab
roidir=$gclustdir/GCLUST/clusters

# set the output directory where data will be stored after all this is finished running
rootoutdir=/home/ml437/rds/hpc-work/ukbiobank
#datadir=$rootoutdir/surfdata
#mkdir $datadir

# get a list of subjects to loop over
sublist=`ls -d $rootdir/UKB10000*`

# set some variables
nsmooth=705
area="white"
meas="thickness"
volume="volume"
target="fsaverage"

# loop over subjects
for sub in $sublist
do

    # print progress to screen
    echo Working on $sub

    # make a subject directory in rootoutdir
    mkdir $rootoutdir/$sub
    suboutdir=$rootoutdir/$sub/GCLUST    
    mkdir $suboutdir


    # left hemisphere ---------------------------------------------------------
    hemi="lh"

    # set subject's *sphere.reg file
    subj_filename=$rootdir/$sub/surfaces/$sub/surf/${hemi}.sphere.reg

    # resample thickness to common space and concatenate 
    out=$suboutdir/${hemi}.${meas}
    mris_preproc --out ${out}.mgh --target $target --f $subj_filename --hemi $hemi --meas $meas

    # smooth thickness
    mri_surf2surf --s $target --sval ${out}.mgh --cortex --nsmooth-out $nsmooth --tval ${out}.n${nsmooth}.mgh --hemi $hemi

    # resample surface area to common space and concatenate 
    out=$suboutdir/${hemi}.${area}
    mris_preproc --out ${out}.mgh --target $target --f $subj_filename --hemi $hemi --area $area

    # smooth surface
    mri_surf2surf --s $target --sval ${out}.mgh --cortex --nsmooth-out $nsmooth --tval ${out}.n${nsmooth}.mgh --hemi $hemi


    # right hemisphere --------------------------------------------------------
    hemi="rh"

    # set subject's *sphere.reg file
    subj_filename=$rootdir/$sub/surfaces/$sub/surf/${hemi}.sphere.reg

    # resample thickness to common space and concatenate 
    out=$suboutdir/${hemi}.${meas}
    mris_preproc --out ${out}.mgh --target $target --f $subj_filename --hemi $hemi --meas $meas

    # smooth thickness
    mri_surf2surf --s $target --sval ${out}.mgh --cortex --nsmooth-out $nsmooth --tval ${out}.n${nsmooth}.mgh --hemi $hemi

    # resample surface area to common space and concatenate 
    out=$suboutdir/${hemi}.${area}
    mris_preproc --out ${out}.mgh --target $target --f $subj_filename --hemi $hemi --area $area

    # smooth surface
    mri_surf2surf --s $target --sval ${out}.mgh --cortex --nsmooth-out $nsmooth --tval ${out}.n${nsmooth}.mgh --hemi $hemi

done


# # extract weighted averages for area and thickness for each cluster
# set cmd = "gclust('"$datadir"','"$roidir"','"$matlabdir"','"$outdir"')"
# matlab -nosplash -nojvm -r \
#  "try, $cmd; exit; catch e, fprintf('ERROR in matlab: %s\n',e.message); exit; end;"

