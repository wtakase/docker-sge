#$ -S /bin/bash
#$ -cwd
#$ -N 'ptsim'
##$ qsub -t 1-10 ./simple_ptsim_job.sh

. /etc/profile.d/geant4.sh
. /etc/profile.d/root.sh

hostname
date
echo JOB_ID: ${JOB_ID}
echo SGE_TASK_ID: ${SGE_TASK_ID}

export NBEAM=1000
export MY_JOB_ID=${JOB_ID}
export MY_TASK_ID=${SGE_TASK_ID}

OUTDIR=/home/sgeuser/ptsim/${JOB_ID}/${SGE_TASK_ID}
mkdir -p ${OUTDIR}
cp -r /usr/local/ptsim/PTSapps/DynamicPort ${OUTDIR}
cd ${OUTDIR}/DynamicPort
cp macros/DynamicPort/Sample1Grid.mac .
sed -i -e 's@^#/My/runaction/ntuple/addColumn JST dose.*$@/My/runaction/ntuple/addColumn JST dose F gray@' macros/common/NtJST.mac
sed -i -e '/^\/My\/runaction\/dumpfile/i \/control\/execute .\/macros\/common\/NtJST.mac' \
       -e 's@hist.root@../../hist.root@' \
       Sample1Grid.mac
time ./bin/PTSdemo Sample1Grid.mac
rm -rf ${OUTDIR}
