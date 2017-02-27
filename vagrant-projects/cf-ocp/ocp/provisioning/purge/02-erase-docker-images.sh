ansible -i ocp_inventory -m shell -a 'docker rmi $(docker images -q)' all
