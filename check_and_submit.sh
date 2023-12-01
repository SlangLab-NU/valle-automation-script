#!/bin/bash

valle_root=/scratch/zhang.tianyi9/automation/valle
checkpoint_dir=$valle_root/egs/libritts
max_epochs=20  # Maximum number of epochs after which the script should stop


# Function to find the latest checkpoint and update the job name
update_job_name_and_checkpoint() {
    cd $checkpoint_dir
    local latest_epoch=$(ls epoch-*.pt 2>/dev/null | sort -V | tail -n 1)
    local latest_batch=$(ls checkpoint-*.pt 2>/dev/null | sort -V | tail -n 1)

    # Default values
    local start_epoch_arg="--start-epoch 1"
    local start_batch_arg="--start-batch 0"
    local job_name="train_1_0"
    local epoch_num="1"
    if [[ -n $latest_epoch ]]; then
        epoch_num=$(echo $latest_epoch | grep -o -E '[0-9]+')
        start_epoch_arg="--start-epoch $((epoch_num + 1))"

        if (( epoch_num >= max_epochs )); then
            echo "Maximum number of epochs ($max_epochs) reached at $(date). No further action required."
            exit 0
        fi
    fi

    if [[ -n $latest_batch ]]; then
        batch_num=$(echo $latest_batch | grep -o -E '[0-9]+')
        start_batch_arg="--start-batch $batch_num"
        
        if [[ -n $latest_epoch ]]; then
            if [[ $latest_epoch -nt $latest_batch ]]; then
                start_batch_arg=""
            fi
            job_name="train_${epoch_num}_${batch_num}"
        fi
    fi

    # Update job name, start epoch, and start batch in the train_job.sh script
    sed -i "s/#SBATCH --job-name=.*/#SBATCH --job-name=$job_name/" $valle_root/../train_job.sh
    sed -i "s/--start-epoch [0-9]*/$start_epoch_arg/" $valle_root/../train_job.sh
    sed -i "s/--start-batch [0-9]*/$start_batch_arg/" $valle_root/../train_job.sh
}


# Check if there are running or pending jobs
if squeue -u `whoami` | grep -E " R| PD" > /dev/null; then
    echo "Job still running or pending in the queue as of $(date). No action taken."
else
    # Update job name and checkpoints
    update_job_name_and_checkpoint

    # Submit the next job
    echo "Submitting job $job_name at $(date)"
    sbatch $valle_root/../train_job.sh
fi

