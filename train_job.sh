#!/bin/bash

# SLURM job parameters
#SBATCH --job-name=$job_name
#SBATCH --output=$log_dir/%j_output.log
#SBATCH --error=$log_dir/%j_output.log
#SBATCH --constraint=ib
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --gres=gpu:t4:1
#SBATCH --mem=15G
#SBATCH --cpus-per-task=8
#SBATCH --time=08:00:00

# Load required modules
module load singularity

# Set up environment variables
source $(dirname "$0")/config.sh
mkdir -p $checkpoint_dir
cd $egs_dir

export SINGULARITYENV_PYTHONPATH="/workspace/icefall:$PYTHONPATH"
# Run training script within Singularity container
singularity run --nv --bind $valle_root:$valle_root $singularity_image \
    python3 bin/trainer.py \
      --max-duration $max_duration \
      --filter-min-duration $filter_min_duration \
      --filter-max-duration $filter_max_duration \
      --train-stage $train_stage \
      --num-buckets $num_buckets \
      --dtype $dtype \
      --save-every-n $save_every_n \
      --valid-interval $valid_interval \
      --model-name $model_name \
      --share-embedding $share_embedding \
      --norm-first $norm_first \
      --add-prenet $add_prenet \
      --decoder-dim $decoder_dim \
      --nhead $nhead \
      --num-decoder-layers $num_decoder_layers \
      --prefix-mode $prefix_mode \
      --base-lr $base_lr \
      --warmup-steps $warmup_steps \
      --average-period $average_period \
      --num-epochs $num_epochs \
      --start-epoch $start_epoch \
      --start-batch $start_batch \
      --accumulate-grad-steps $accumulate_grad_steps \
      --exp-dir $checkpoint_dir
