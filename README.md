# Datawarehouse Case
### Project Summary
This project is an exercise to create a datawarehouse on GCP along the lines of 
this [article](https://towardsdatascience.com/build-your-first-data-warehouse-with-airflow-on-gcp-fdd0c0ad91bb). 

### Requirements
It is assumed that gcloud (see [here](https://cloud.google.com/sdk/gcloud)) is installed and the user 
has the necessary permissions to administer GCP Compute instances as well as BiqQuery access rights. The basic project configuration is performed through environment variables in the user profile (I write mine in an activation hook for my project virtualenv). 

The required environment variables are:
* `DWH_USER`: The username to be used on airflow server
* `DWH_SERVER_NAME`: Name of airflow server
* `DWH_SERVICE_ACCOUNT`: Service account to use for airflow server
* `DWH_SERVER_ZONE`: The zone to run the server in
* `BQ_STAGING_DATASET`: The name to use for staging dataset. This dataset will be created.
* `BQ_DWH_DATASET`: The name to use for datawarehouse dataset. This dataset will be created.

## Setup
### Data
Get the dataset GlobalLandTemperaturesByCity.csv from [here](https://www.kaggle.com/berkeleyearth/climate-change-earth-surface-temperature-data?select=GlobalLandTemperaturesByCity.csv)
and place it in the `./data/` folder. Run `./bin/setup_data` to parse the datafiles into CSV 
and move them into the GCS bucket.

*NOTE: This part has not been fully implemented with env. variable configuration. Review 
file before running.*

### GCP Server and BigQuery
To instantiate the GCP infrastructure, run `./bin/setup`. This will initialise a 
GCP compute instance, create firewall permissions to access the Airflow webserver over
HTTP, install Airflow (from PIP) and clone the necessary repos (see 
[here](https://github.com/quedah/dwh)) containing the airflow.cfg and the dags folder. It 
will also create the staging and datawarehouse datasets in BigQuery. A nginx instance will be 
launched as reverse proxy to serve the Airflow UI over port 80.

### Running Airflow
You can connect to the server using `./bin/connect`. You can launch the scheduler using 
```
cd ~/dwh
airflow scheduler
```
and in a separate terminal the webserver with
```
cd ~/dwh
airflow webserver
```
Using Screen can be useful for this. 

The Airflow webserver can now be accessed over the server IP (see 
`gcloud compute instances list` to see currently allocaed IPs).

### Comments
