# Remove everything generated during the deployment while leaving other project
# contents intact:
oc new-app logging-deployer-template --param MODE=uninstall
