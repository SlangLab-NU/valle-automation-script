#!/bin/bash

# SLURM job parameters
#SBATCH --job-name=${dynamic_job_name}
#SBATCH --output=${VALLE_ROOT}/egs/libritts/exp/${job_name}/logs/%j_output.log
#SBATCH --error=${VALLE_ROOT}/egs/libritts/exp/${job_name}/logs/%j_output.log
#SBATCH --constraint=ib
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --gres=gpu:v100-sxm2
#SBATCH --mem=15G
#SBATCH --cpus-per-task=8
#SBATCH --time=08:00:00

# Print out SBATCH parameters
echo "Job Name: $SLURM_JOB_NAME"
echo "Job ID: $SLURM_JOB_ID"
echo "Partition: $SLURM_JOB_PARTITION"
echo "GPUs Requested: $SLURM_GPUS"
echo "Memory Allocated: $SLURM_MEM_PER_NODE"
echo "CPUs per Task: $SLURM_CPUS_PER_TASK"
echo "Time Limit: $SLURM_TIMELIMIT"


#Load dynamic job name and config variables
source $script_dir/config.sh

if [ -z "$job_name" ]; then
    echo "job_name is not set. Please define it."
    exit 1
fi

if [ -z "$script_dir" ]; then
    echo "script_dir is not set. Please define it."
    exit 1
fi


# Load required modules
module load singularity

# Set up environment variables
cd $egs_dir

export SINGULARITYENV_PYTHONPATH="/workspace/icefall:$PYTHONPATH"
# Run training script within Singularity container
singularity run --nv --bind $VALLE_ROOT:$VALLE_ROOT $singularity_image \
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
      --start-epoch 1 \
      --start-batch 0 \
      --accumulate-grad-steps $accumulate_grad_steps \
      --exp-dir $checkpoint_dir
