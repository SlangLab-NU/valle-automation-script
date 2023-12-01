#!/bin/bash

valle_root=/scratch/zhang.tianyi9/automation/valle
checkpoint_dir=$valle_root/egs/libritts
max_epochs=20  # Maximum number of epochs after which the script should stop


# Function to find the latest checkpoint and update the job name
update_job_name_and_checkpoint() {
    cd $checkpoint_dir
    local latest_epoch=$(ls epoch-*.pt 2>/dev/null | sort -V | tail -n 1)
    local latest_batch=$(ls checkpoint-*.pt 2>/dev/null | sort -V | tail -n 1)

    # Defaults
    local epoch_num=1
    local batch_num=0
    local job_name=""

    # Determine epoch number
    if [[ -n $latest_epoch ]]; then
        epoch_num=$(echo $latest_epoch | grep -o -E '[0-9]+')
        epoch_num=$((epoch_num + 1))  # Increment epoch number
    fi

    # Determine batch number
    if [[ -n $latest_batch && ( -z $latest_epoch || $latest_epoch -ot $latest_batch ) ]]; then
        batch_num=$(echo $latest_batch | grep -o -E '[0-9]+')
    fi

    # Set job name
    job_name="train_${epoch_num}_${batch_num}"

    # Check if max epochs have been reached
    if (( epoch_num > max_epochs )); then
        echo "Maximum number of epochs ($max_epochs) reached at $(date). No further action required."
        exit 0
    fi

    # Update job name, start epoch, and start batch in the train_job.sh script
    sed -i "s/#SBATCH --job-name=.*/#SBATCH --job-name=$job_name/" $valle_root/../train_job.sh
    sed -i "s/--start-epoch [0-9]*/--start-epoch $epoch_num/" $valle_root/../train_job.sh
    sed -i "s/--start-batch [0-9]*/--start-batch $batch_num/" $valle_root/../train_job.sh
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

