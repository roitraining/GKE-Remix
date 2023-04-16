## Creating Google Kubernetes Engine Deployments (overlay)

### Overview

We're basically doing the standard lab, but looking at some additional stuff
along the way

### Setup

1. Do **Lab Setup** as written in Qwiklabs instructions

### Task 1

1. Do **Task 1** as written in Qwiklabs instructions

### Task 1b

1. In the Console go to **Kubernetes Engine > Workloads** to see the list of
   workloads deployed to your cluster. Note the details are similar to what
   you see when doing `kubectl get deployments`.

2. Click on the **nginx-deployment** in the workload listing. Explore the 
   information displayed about the deployment (view the various pages).

   > Are the pods in the deployment exposed via any services?
   > How much memory is being consumed by the deployment?
   > What's the termination grace period for pods in the deployment?
   > Which pod is using the most memory?

3. In the **Overview** page, click on one of the managed pods to see details.

    > What labels are applied to the pod?
    >
    > What ReplicaSet controller is managing the pod?
    >
    > How many containers are running in the pod?

### Task 2

1. Do Task 2 as written in Qwiklabs

### Task 3

1. Do Steps 1-3 as written
2. In the Console, go to **Kubernetes Engine > Workloads > nginx-deployment**.
   Note the following

   * Revision number in the Pod specification line
   * Revision number in the Active revisions section
   * REVISION HISTORY tab in the deployment details

3. Click on **REVISION HISTORY**. 

    > How many revisions are listed?
    >
    > What's the difference between the revisions?

4. Continue Task 3 of the lab in the Qwiklabs instructions, starting with
   Step 4.

### Task 4

1. Do Task 4 as written in Qwiklabs instructions

### Task 4b

1. In the Console, visit **Kubernetes Engine > Workloads > nginx-deployment**.
   
   > Are the pods in this deployment exposed via any services now?

3. Visit **Kubernetes Engine > Services & Ingress**.
   
   > What type of service is the nginx service?
   >
   > How many endpoints are there?

4. Click on the **nginx** service to see the details
5. Explore the information offered in the various tabs of this page
6. In the Console, go to **Network Services > Load balancing**.

    > What kind of load balancer has been created for your K8s service?

7. Click on the load balancer to see details. Then click **EDIT** at the top
   of the page.

   > Looking at the Frontend configuration, what port is the load balancer
   > listening on?

### Task 5

1. Do Task 5 as written in Qwiklabs instructions

---
Copyright 2023, ROI TRAINING, INC. Please see LICENSE for more details.