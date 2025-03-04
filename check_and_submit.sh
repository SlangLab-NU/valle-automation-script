#!/bin/bash

#The following two lines make sure that VALLE_ROOT has been defined externally                                                                               
if [ -z "$VALLE_ROOT" ]; then
    echo "VALLE_ROOT is not set. Please define it externally using 'export VALLE_ROOT=/path/to/valle/root.'"
    exit 1  # Exit with an error                                                                                                                             
fi

source $VALLE_ROOT/config.sh

dynamic_job_name=''

# Function to find the latest checkpoint and update the job name
update_job_name_and_checkpoint() {
    cd $checkpoint_dir
    local latest_epoch=$(ls epoch-*.pt 2>/dev/null | sort -V | tail -n 1)
    local latest_batch=$(ls checkpoint-*.pt 2>/dev/null | sort -V | tail -n 1)

    # Defaults
    local epoch_num=1
    local batch_num=0
    local local_job_name=""

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
    local_job_name="${job_name}_${epoch_num}_${batch_num}"

    # Check if max epochs have been reached
    if (( epoch_num > max_epochs )); then
        echo "Maximum number of epochs ($max_epochs) reached at $(date). No further action required."
        exit 0
    fi

    # Update job name, start epoch, and start batch in the train_job.sh script
    sed -i "s/#SBATCH --job-name=.*/#SBATCH --job-name=$local_job_name/" $VALLE_ROOT/train_job.sh
    sed -i "s/--start-epoch [0-9]*/--start-epoch $epoch_num/" $VALLE_ROOT/train_job.sh
    sed -i "s/--start-batch [0-9]*/--start-batch $batch_num/" $VALLE_ROOT/train_job.sh

    # This ensures the dynamically updated job_name is written to a file that train_job.sh can source.
    echo "dynamic_job_name=$local_job_name" > $VALLE_ROOT/job_name.conf
    dynamic_job_name=$local_job_name
}



if squeue -u "$(whoami)" -o "%.50j" | awk -v job="$job_name" '$1 ~ job {exit 1}'; then
    echo "No matching job found. Proceeding with new job submission."
    update_job_name_and_checkpoint
    if [ -z "${dynamic_job_name// /}" ]; then
	echo "dynamic_job_name is not set."
    fi
     echo "Submitting job $dynamic_job_name at $(date)"
    sbatch "$VALLE_ROOT/train_job.sh"
else
    echo "Job $dynamic_job_name is still running or pending as of $(date). No action taken."
fi
