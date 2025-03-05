#!/bin/bash

#The following two lines make sure that VALLE_ROOT has been defined externally
if [ -z "$VALLE_ROOT" ]; then
    echo "VALLE_ROOT is not set. Please define it externally using 'export VALLE_ROOT=/path/to/valle/root.'"
    exit 1  # Exit with an error
fi

echo "VALLE_ROOT is $VALLE_ROOT"

#Make sure these are defined preflight check
job_name=att3_train_orig_8_0_1
source_expt_conf=$VALLE_ROOT/configs/$job_name/training.conf

if [[ ! -f "$source_expt_conf" ]]; then
    echo "Error: File '$source_expt_conf' does not exist. This step is manual! Exiting." >&2
    exit 1
fi

dataset=libritts
egs_dir=$VALLE_ROOT/egs/$dataset
checkpoint_dir=$egs_dir/exp/$job_name
log_dir=$checkpoint_dir/logs
mkdir -p $log_dir
max_epochs=20
singularity_image=/work/van-speech-nlp/valle_container/valle.sif
expt_config=$checkpoint_dir/training.conf
cp $source_expt_conf $expt_conf


