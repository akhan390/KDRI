
from google.cloud import storage
from sklearn.externals import joblib
import argparse
import hypertune
import numpy as np
import pandas as pd

from sklearn.model_selection import train_test_split
import sksurv.datasets
from sksurv.ensemble import RandomSurvivalForest
from sksurv.metrics import brier_score, concordance_index_censored, concordance_index_ipcw, cumulative_dynamic_auc, integrated_brier_score


# Create the argument parser for each parameter plus the job dictionary

parser = argparse.ArgumentParser(description='Random Survival Forest')
    
parser.add_argument('--job-dir',  # handled automatically by AI Platform
                        help='GCS location to write checkpoints and export ' \
                             'models')
parser.add_argument('--n_estimators', 
                        type=int,
                        default=100,
                        help='The number of trees in the forest')
parser.add_argument('--min_samples_split', 
                        type=float,
                        default=0.0,
                        help='minimum numer of samples required to split an internal node')
parser.add_argument('--min_samples_leaf', 
                        type=float,
                        default=0.0,
                        help='The minimum number of samples required to be at a leaf node')
args = parser.parse_args()
    
    
# Load dataframe and set index
df = pd.read_csv('gs://my-capstone-project/df_gcp.csv')
df.set_index(keys = 'TRR_ID_CODE', inplace = True)


# Defining features (X) and target (y)
X, y = sksurv.datasets.get_x_y(df, attr_labels = ['GRF_STAT_NUM', 'GTIME_KI_YEARS'], 
                              pos_label = 1, survival = True)
    
# Train test split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size =0.33, random_state = 39)

# Define the model with parameters to tune
model = RandomSurvivalForest(
    n_estimators = args.n_estimators,
    min_samples_split = args.min_samples_split,
    min_samples_leaf = args.min_samples_leaf)
# Fit the training data and predict the test data
model.fit(X_train, y_train)
    

# Evaluate model by concordance index
c_index = model.score(X_test, y_test)

    
# Report the metric we're optimizing for to AI Platform's HyperTune service
# In this example, we're maximizing concordance index
hpt = hypertune.HyperTune()
hpt.report_hyperparameter_tuning_metric(
        hyperparameter_metric_tag='concordance_index',
        metric_value=c_index,
        global_step=1000       
    )


# Export model to a file
model_filename = 'model.joblib'
joblib.dump(model, model_filename)

#Define the job dir, bucket id and bucket path to upload the model to GCS
job_dir = "gs://my-capstone-project".replace('gs://','')

# Get the bucket Id
bucket_id = job_dir.split('/')[0]

# Get the path
bucket_path = job_dir.lstrip('{}/'.format(bucket_id))

#Upload the model to GCS
bucket = storage.Client().bucket(bucket_id)
blob = bucket.blob('{}/{}'.format(
    bucket_path,
    model_filename
)
                  )

blob.upload_from_filename(model_filename)
