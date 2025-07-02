#!/bin/bash

remote_user=lewis.jor
remote_host="login.discovery.neu.edu"
valle_root="/scratch/lewis.jor"
valle_repo_root="$valle_root/VallE"
job_name="uaspeech_12_16_test"
script_dir=$valle_repo_root/scripts/$job_name
remote_script_path="$script_dir/check_and_submit.sh"

sleep_sec=3600

setup="true" 
run_automation="false"

if [[ "$setup" == "true" ]]; then
    ssh -T ${remote_user}@${remote_host} "mkdir -p $script_dir && cd $script_dir && git clone --branch mods-to-config --depth 1 https://github.com/SlangLab-NU/valle-automation-script.git && mv valle-automation-script/* . && rm -rf valle-automation-script"
fi

if [[ "$run_automation" == "true" ]]; then
    while true; do
	    ssh -T ${remote_user}@${remote_host} "
          export VALLE_ROOT=$valle_root && \
          export VALLE_REPO_ROOT=$valle_repo_root && \
          export script_dir=$script_dir && \
          export job_name=$job_name && \
          export singularity_image=$valle_repo_root/concat_speakers_on_dev_set.sif && \
          export SINGULARITYENV_PYTHONPATH=\$VALLE_REPO_ROOT:/workspace/icefall:\$PYTHONPATH && \
          bash $remote_script_path"
      sleep $sleep_sec
    done
fi
