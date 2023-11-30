#!/bin/bash

valle_root=/scratch/zhang.tianyi9/automation/valle
checkpoint_dir=$valle_root/egs/libritts

# Function to find the latest checkpoint and update the job name
update_job_name_and_checkpoint() {
    cd $checkpoint_dir
    local latest_epoch=$(ls epoch-*.pt 2>/dev/null | sort -V | tail -n 1)
    local latest_batch=$(ls checkpoint-*.pt 2>/dev/null | sort -V | tail -n 1)

    if [[ -n $latest_epoch ]] && [[ -z $latest_batch || $latest_epoch -nt $latest_batch ]]; then
        epoch_num=$(echo $latest_epoch | grep -o -E '[0-9]+')
        checkpoint_args="--start-epoch $((epoch_num + 1))"
        job_name="train_${epoch_num}_end"
    elif [[ -n $latest_batch ]]; then
        batch_num=$(echo $latest_batch | grep -o -E '[0-9]+')
        checkpoint_args="--start-batch $batch_num"
        job_name="train_0_${batch_num}"
    else
        checkpoint_args="--start-epoch 1 --start-batch 0"
        job_name="train_0_0"
    fi

    # Update job name and checkpoint in the train_job.sh script
    sed -i "s/#SBATCH --job-name=.*/#SBATCH --job-name=$job_name/" $valle_root/../train_job.sh
    sed -i "s/--start-epoch [0-9]* --start-batch [0-9]*/$checkpoint_args/" $valle_root/../train_job.sh
}

# Main loop
while true; do
    # Check if there are running or pending jobs
    if ! squeue -u `whoami` | grep -E " R| PD" > /dev/null; then
        # Update job name and checkpoints
        update_job_name_and_checkpoint

        # Submit the next job
        sbatch $valle_root/../train_job.sh
    fi

    # Wait for a while before checking again
    sleep 60
done

