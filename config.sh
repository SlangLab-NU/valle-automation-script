#!/bin/bash

#The following two lines make sure that VALLE_ROOT has been defined externally
if [ -z "$VALLE_ROOT" ]; then
    echo "VALLE_ROOT is not set. Please define it externally using 'export VALLE_ROOT=/path/to/valle/root.'"
    exit 1  # Exit with an error
fi

echo "VALLE_ROOT is $VALLE_ROOT"

#Make sure these are defined preflight check
if [ -z "$job_name" ]; then                                                                                                                                                                              
    echo "job_name is not set. Please define it."                                                                                                                                                        
    exit 1
fi                                                                                                                                                                                                        
                                                                                                                            
if [ -z "$script_dir" ]; then                                                                                                                                                                            
    echo "script_dir is not set. Please define it."                                                                                                                                                      
    exit 1                                                                                                                                                                                               
fi

#job_name=att3_train_orig_8_0_1
#script_dir=$VALLE_ROOT/scripts/$job_name

dataset=libritts
egs_dir=$VALLE_ROOT/egs/$dataset
checkpoint_dir=$egs_dir/exp/$job_name
log_dir=$checkpoint_dir/logs
mkdir -p $log_dir
max_epochs=20
singularity_image=/work/van-speech-nlp/valle_container/valle.sif



max_duration=80
filter_min_duration=0.5
filter_max_duration=14
train_stage=0
num_buckets=6
dtype="float16"
save_every_n=10000
valid_interval=20000
model_name="valle"
share_embedding="true"
norm_first="true"
add_prenet="false"
decoder_dim=1024
nhead=16
num_decoder_layers=8
prefix_mode=1
base_lr=0.05
warmup_steps=200
average_period=0
num_epochs=20
start_epoch=1
start_batch=0
accumulate_grad_steps=4
