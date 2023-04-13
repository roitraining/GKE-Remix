## Using Cloud SQL with Google Kubernetes Engine (remix)

### Overview

We're basically tweaking the standard lab to use a private Cloud SQL instance
and Workload Identity

### Task 0 - Starting the lab

1. Start the **Using Cloud SQL with Google Kubernetes Engine** lab in Qwiklabs
2. Perform the remaining steps in the **Lab Setup** section of the lab

### Task 1 - Replace the pre-built cluster

1. In Cloud Shell, use the following commands to delete the pre-built cluster,
   and replace it with a new cluster that has Workload Identity enabled:

    ```bash
    export my_zone=us-central1-a
    export my_cluster=standard-cluster-1
    source <(kubectl completion bash)

    gcloud config set compute/zone us-central1-a
    gcloud container clusters delete standard-cluster-1
    gcloud container clusters create standard-cluster-1 \
    --enable-ip-alias \
    --workload-pool=$DEVSHELL_PROJECT_ID.svc.id.goog \
    --quiet

    gcloud container clusters get-credentials $my_cluster --zone $my_zone
    ```

    These commands will take about 10-14 minutes to complete. Continue on
    to the next section while they run.

### Task 2 - Enable service networking and create a connection

In order for resources connected to your VPC to access the Cloud SQL instance
using private networks, you need to set this up.

1. In Cloud Shell, create a 2nd tab by clicking the little `+` icon. Enter
   the following into the 2nd tab:

   ```bash
    export my_zone=us-central1-a
    export my_cluster=standard-cluster-1
    source <(kubectl completion bash)
    gcloud config set compute/zone us-central1-a
   ```

2. Use the following command to enable the Service Networking API

   ```bash
    gcloud services enable servicenetworking.googleapis.com
    ```

3. Next, use the following commands to create a private service connection for
   your Cloud SQL instance

   ```bash
    gcloud compute addresses create google-managed-services-default \
        --global \
        --purpose=VPC_PEERING \
        --addresses=192.168.0.0 \
        --prefix-length=16 \
        --network=projects/$DEVSHELL_PROJECT_ID/global/networks/default
    ```

    ```bash
    gcloud services vpc-peerings connect \
        --service=servicenetworking.googleapis.com \
        --ranges=google-managed-services-default \
        --network=default
    ```

4. You can verify that the connection has been created by visiting 
   **Navigation > VPC Network > VPC Networks > Default > Private Service
   Connection**

### Task 3 - Create a Cloud SQL instance configured for private IP

1. In Cloud Shell, use the following command to start creation of a
   Cloud SQL MySQL instance, configured for private IP

   ```bash
   gcloud sql instances create sql-instance \
    --tier=db-n1-standard-1 \
    --network=default \
    --no-assign-ip 
    ```

> Take a 10 minute break at this point. It will take 5-7 minutes for the
> database server to come online, and another 5+ minutes for the GKE cluster
> to finish. Don't take more than 10 minutes, though, because you don't want
> to run out of time!

### Task 4 - Set up workload identity

1. Switch to the first Cloud Shell tab. If you cluster is not done being
   created, wait until it's finished.

2. Create a namespace where you will run your application:

    ```bash
    kubectl create namespace wp
    ```

3. Create the Kubernetes Service Account that will be used by your application:

    ```bash
    kubectl create serviceaccount wp-sa --namespace wp
    ```

4. Create a Google Service Account that will be used to talk to Cloud SQL:

    ```bash
    gcloud iam service-accounts create wordpress-sa
    ```

5. Assign an IAM role to the GSA to allow it to use Cloud SQL:

    ```bash
    gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member=serviceAccount:wordpress-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
    --role=roles/cloudsql.client
    ```

6. Configure the service account to allow workloads running with the KSA to
   impersonate the GSA when making API calls:

   ```bash
   gcloud iam service-accounts add-iam-policy-binding \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$DEVSHELL_PROJECT_ID.svc.id.goog[wp/wp-sa]" \
    wordpress-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com
    ```

7. Annotate the KSA:

    ```bash
    kubectl annotate serviceaccount \
    --namespace wp \
    wp-sa \
    iam.gke.io/gcp-service-account=wp-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com
    ```

### Task 4.5 - Configure a user and database

1. In the Console, navigate to **Navigation > SQL > Instances > sql-instance**
2. Click on **Users**, then on **Add User Account**
3. Create a new account with the following values:

| **Username** | **Password**  |
| ------------ | ------------- |
| `sqluser`    | `sqlpassword` |

4. Click on **Databases** on the left, and create a new Database named
   `wordpress`

### Task 5 - Create Secrets

1. Create secrets for use by the application:

    ```bash
    kubectl --namespace wp create secret generic sql-credentials \
   --from-literal=username=sqluser \
   --from-literal=password=sqlpassword
   ```

### Task 6 - Deploy Wordpress

1. Create a new file named `wp.yaml` in the root of you home directory, then
   open it for editing:

   ```bash
   touch wp.yaml
   edit wp.yaml
   ```

2. Visit https://github.com/roitraining/GKE-Remix/blob/main/app.yaml and review the contents of the manifest
3. Copy the contents of the Github file and paste into your `wp.yaml` file
   > Note that the manfiest specifies the KSA to use when running your app

4. In the Console, click on **Overview** on the left hand side, and copy
   the **Private IP** address of your instance. 

5. Back in the code editor, replace the `<cloud sql private ip>` with the
   private IP address of your Cloud SQL instance. Save your work.

6. In Cloud Shell, deploy WordPress:
    
    ```bash
    kubectl apply --namespace wp -f wp.yaml
    ```

7. Use the following command to get the Public IP of the load balancer in
   front of you wordpress deployment

   ```bash
   kubectl --namespace wp get service -w
   ```

   Wait until the EXTERNAL-IP field is populated, then you can use CTRL-C 
   to exit out of the wait loop

### Task 7 - Connect to your Wordpress instance

1. Do Task 7, Steps 1-6. You should have a functional Wordpress deployment
2. Try creating several posts, and searching for posts.