#!/bin/bash

valle_root=/work/van-speech-nlp/aanchan/refactor-valle/VallE
checkpoint_dir=$valle_root/egs/uaspeech/exp/train_example
max_epochs=20
singularity_image=/work/van-speech-nlp/valle_container/valle.sif
job_name=valle_train


# training parameters
max_duration=80
filter_min_duration=0.5
filter_max_duration=14
train_stage=1
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
num_decoder_layers=12
prefix_mode=1
base_lr=0.05
warmup_steps=200
average_period=0
num_epochs=20
start_epoch=1
start_batch=0
accumulate_grad_steps=4