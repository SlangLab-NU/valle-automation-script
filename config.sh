#!/bin/bash

valle_root=/work/van-speech-nlp/vallE/vall-e
checkpoint_dir=$valle_root/egs/libritts/exp/aanchan_exp_check1
max_epochs=20
singularity_image=/work/van-speech-nlp/valle_container/valle.sif
job_name=valle_train