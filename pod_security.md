## Securing Google Kubernetes Engine with Cloud IAM and Pod Security Policies (overlay)

### Overview

We're basically extending the standard lab but replacing PodSecurityPolicy with
Pod Security Standards

### Setup

1. Start the **Securing Google Kubernetes Engine with Cloud IAM and Pod 
   Security Policies** lab in Qwiklabs
2. Perform the remaining steps in the **Lab Setup** section of the lab

### Task 1 - Use Cloud IAM roles to grant administrative access to all the GKE clusters in the project

1. Perform **Task 1** in the Qwiklabs instructions as written

### Task 2 - Apply predefined Pod-level security policies using PodSecurity

1. In Cloud Shell, use the following to configure kubectl to work with your
   cluster:

    ```bash
    export my_zone=us-central1-a
    export my_cluster=standard-cluster-1
    gcloud container clusters get-credentials $my_cluster --zone $my_zone
    ```

2. Create two namespaces, one for permissive workloads and one for restrcited:

    ```bash
    kubectl create ns baseline-ns
    kubectl create ns restricted-ns
    ```

3. Label each of the namespaces to configure how the PodSecurity Adminssion
   Controller handles pod security:

    ```bash
    kubectl label --overwrite ns baseline-ns pod-security.kubernetes.io/warn=baseline
    kubectl label --overwrite ns restricted-ns pod-security.kubernetes.io/enforce=restricted
    ```
    > The first command will result in warning messages for pods that violate
    > the security standard. The second command will result in refusal to
    > admit pods that violate standards

4. Using the **Cloud Shell editor**, create a new file name `podsec.yaml`. Copy
   the code from the [podspec.yaml](https://github.com/roitraining/GKE-Remix/blob/main/podspec.yaml) file and paste it into your local file.

5. Apply the new configuration to the permissive namespace:

    ```bash
    kubectl apply -f podsec.yaml --namespace=baseline-ns
    ```

    You should see a warning, as expected.

6. Verify that the pod did, in fact, get deployed:

    ```bash
    kubectl get pods -ns baseline-ns
    ```

7. Apply the manifest to the restrive namespace:

    ```bash
    kubectl apply -f podsec.yaml --namespace=restricted-ns
    ```

    You should see an error indicating the pod won't be created.

8. In the Console, go to Log Explorer, and enter the following query:

    ```
    resource.type="k8s_cluster"
    protoPayload.response.reason="Forbidden"
    protoPayload.resourceName="core/v1/namespaces/restricted-ns/pods/nginx"
    ```

    Run the query. You should see an event that shows the failed attempt to
    launch a pod that doesn't comply with the security standard.

### Task 3. Rotate IP Address and Credentials

1. Perform **Task 3** in the Qwiklabs instructions as written

---
Copyright 2023, ROI TRAINING, INC. Please see LICENSE for more details.