
BUCKET_NAME="my-capstone-project"
JOB_NAME="rsf_hp_$(date +"%Y%m%d_%H%M%S")"
JOB_DIR='gs://my-capstone-project'
TRAINER_PACKAGE_PATH="./training_job_folder/trainer"
MAIN_TRAINER_MODULE="trainer.train"
HPTUNING_CONFIG="training_job_folder/trainer/hptuning_config.yaml"
RUNTIME_VERSION="2.1"
PYTHON_VERSION="3.7"
REGION="us-east1"
SCALE_TIER=CUSTOM



gcloud ai-platform jobs submit training $JOB_NAME \
  --job-dir $JOB_DIR \
  --package-path $TRAINER_PACKAGE_PATH \
  --module-name $MAIN_TRAINER_MODULE \
  --region $REGION \
  --runtime-version=$RUNTIME_VERSION \
  --python-version=$PYTHON_VERSION \
  --scale-tier $SCALE_TIER \
  --config $HPTUNING_CONFIG \
  --master-machine-type c2-standard-4 \