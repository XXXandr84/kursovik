#!/bin/bash
# $1 - gitlab token
# $2 - gitlab password
#creating project crawler
GITLAB_IP=`cd terraform/ && terraform output gitlab_external_ip`
GITLAB_TOKEN=$1
GITLAB_PASSWORD=$2
curl --header "PRIVATE-TOKEN: $1" -X POST "http://$GITLAB_IP/api/v4/projects?name=crawler&description=hello_otus&initialize_with_readme=true"
rm -rf temp/*
cd temp/
git clone https://github.com/express42/search_engine_crawler
git clone https://github.com/express42/search_engine_ui
git clone http://root:$GITLAB_PASSWORD@$GITLAB_IP/root/crawler.git
pwd
rm -rf search_engine_crawler/.git
rm -rf search_engine_ui/.git
mv -f search_engine_crawler/ crawler/
mv -f search_engine_ui/ crawler/
cd crawler/
cp ../../files/Dockerfile-app search_engine_crawler/Dockerfile
cp ../../files/Dockerfile-ui search_engine_ui/Dockerfile
mkdir rabbit
mkdir rabbit/data
cp ../../files/definitions.json rabbit/definitions.json
cp ../../files/rabbitmq.config rabbit/rabbitmq.config
git add *
git commit -m "init"
git push
exit
##############################
#!/bin/bash
# $1 - gitlab registration token
# $2 - docker hub login
GITLAB_IP=`cd terraform/ && terraform output gitlab_external_ip`
GITLAB_REG_TOKEN=$1
DOCKER_HUB_LOGIN=$2
#Configuring gitlab-runners
cd ansible/
echo "---" > environments/prod/group_vars/gitlab-runners.yml
echo "gitlab_runner_registration_token: '$GITLAB_REG_TOKEN'" >> environments/prod/group_vars/gitlab-runners.yml
echo "gitlab_runner_coordinator_url: 'http://$GITLAB_IP'" >> environments/prod/group_vars/gitlab-runners.yml
ansible-playbook playbooks/gitlab-runners.yml
ansible-playbook playbooks/docker-login.yml
cd ../temp/crawler
echo "variables:" > .gitlab-ci.yml
echo "    DOCKERHUBUSER: $2" >> .gitlab-ci.yml
cat ../../files/.gitlab-ci.yml >> .gitlab-ci.yml
git add .gitlab-ci.yml
git commit -m "added .gitlab-ci.yml"
echo "DOCKERHUBUSER=$DOCKER_HUB_LOGIN" > .env
cp ../../files/docker-compose-apps.yml docker-compose.yml
git add .env
git add docker-compose.yml
git commit -m "added docker-compose"
git push