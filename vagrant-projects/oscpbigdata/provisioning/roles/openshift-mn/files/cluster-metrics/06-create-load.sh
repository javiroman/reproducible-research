oc login -u user1
oc new-app docker.io/openshift/hello-openshift:latest -n user1-project

IP=$(oc get svc hello-openshift --template "{{ .spec.portalIP }}")

for time in {1..5000}; do
    echo time $time
    curl ${IP}:8080
done

