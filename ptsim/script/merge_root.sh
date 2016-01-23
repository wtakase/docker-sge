#$ -S /bin/bash
#$ -cwd
#$ -N 'merge'
##$ qsub ./merge_root.sh JOB_ID TASK_START_ID TASK_END_ID

. /etc/profile.d/root.sh

hostname
date

export DISPLAY=dummy:0
ROOT_DIR=/home/sgeuser/ptsim/$1
root -b -q "/usr/local/ptsim/PTSapps/DynamicPort/macros/DynamicPort/MergeROOTFile.C(\"${ROOT_DIR}/hist.root\", \"${ROOT_DIR}/merged.root\", $2, $3)"
rm -f ${ROOT_DIR}/hist.root*
