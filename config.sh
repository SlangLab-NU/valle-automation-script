#!/bin/bash

valle_root=/work/van-speech-nlp/aanchan/vall-e
egs_dir=$valle_root/egs/libritts
checkpoint_dir=$egs_dir/exp/train_example
max_epochs=20
singularity_image=/work/van-speech-nlp/valle_container/valle.sif
job_name=train_orig_8_0_1
log_dir=/work/van-speech-nlp/aanchan/vall-e/logs
gpu_flags=v100-sxm2



# training parameters
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
