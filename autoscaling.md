## GKE Autoscaling Strategies (overlay)

### Overview

We're basically tweaking the standard lab to avoid unnecessary long delays
waiting for clusters to build!

### Setup

1. Follow the directions in the Setup and requirements section of Qwiklabs,
   **BUT** replace the command used to create the cluster in **Provision testing
   environment** section (step 2 of that section). Use this command instead:

    ```bash
    gcloud container clusters create scaling-demo \
        --num-nodes=3 \
        --enable-vertical-pod-autoscaling \
        --enable-autoscaling \
        --min-nodes 1 \
        --max-nodes 5 \
        --autoscaling-profile optimize-utilization
    ```

    ```
    This command creates the cluster, enables VPA and cluster auto-scaling with
    the more aggressive scale-down strategy in place.

### Tasks 1-4

1. Do **Tasks 1-4** as written in the Qwiklabs instructions

### Task 5

1. Skip Steps 1-2 in the Qwiklabs instructions; pick up at Step 3.
2. Complete the rest of Task 5 as written

### Tasks 6-8 

1. Complete these tasks as written in Qwiklabs

