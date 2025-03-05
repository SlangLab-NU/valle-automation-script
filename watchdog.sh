#!/bin/bash

remote_user=aa.mohan
remote_host="login.discovery.neu.edu"
valle_root="/work/van-speech-nlp/aanchan/refactor-valle/VallE"
job_name="att3_train_refactor_8_0_1"
script_dir=$valle_root/scripts/$job_name
remote_script_path="$script_dir/check_and_submit.sh"

sleep_sec=3600

setup="true" 
run_automation="false"

if [[ "$setup" == "true" ]]; then
    ssh -T ${remote_user}@${remote_host} "mkdir -p $script_dir && cd $script_dir && git clone https://github.com/SlangLab-NU/valle-automation-script.git"
fi

if [[ "$run_automation" == "true" ]]; then
    while true; do
	# SSH into the remote server and execute the check and submit script
         
	ssh -T ${remote_user}@${remote_host} "export VALLE_ROOT=${valle_root} && export script_dir=${script_dir}  && export job_name=${job_name} && bash ${remote_script_path}"
	# Sleep for a specified amount of time before checking again
	sleep ${sleep_sec}
    done
fi
