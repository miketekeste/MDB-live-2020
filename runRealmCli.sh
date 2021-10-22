#!/bin/bash



echo "
/***
 *                                                                                                             
 *     _____                 ____  _____    _____ _ _ _ _            ____          _   _                 _     
 *    |     |___ ___ ___ ___|    \| __  |  | __  |_| | |_|___ ___   |    \ ___ ___| |_| |_ ___ ___ ___ _| |___ 
 *    | | | | . |   | . | . |  |  | __ -|  | __ -| | | | |   | . |  |  |  | .'|_ -|   | . | . | .'|  _| . |_ -|
 *    |_|_|_|___|_|_|_  |___|____/|_____|  |_____|_|_|_|_|_|_|_  |  |____/|__,|___|_|_|___|___|__,|_| |___|___|
 *                  |___|                                    |___|                                             
 */
"


echo STEP I -1/1- Provide your organisation ID:
read orgID
clear

echo STEP II -1/2- Provide the Public API Key at the  project level:
read publicKeyProject
clear

echo STEP II -2/2- Provide the Private API Key at the  project level:
read privateKeyProject
clear

echo STEP III -1/2- Provide the Public API key at the  org level:
read publicKeyOrg
clear

echo STEP III -2/2- Provide the Private API key at the  org level:
read privateKeyOrg
clear

echo STEP IV -1/1- What is the name of the cluster you will store the billing data?
read clusterName
clear

echo Thanks.....

sed -ie "s/"billing"/$clusterName/g" ./data_sources/mongodb-atlas/config.json

realm-cli login --api-key="$publicKeyProject" --private-api-key="$privateKeyProject"

realm-cli import --yes 

realm-cli secrets create -n billing-orgSecret -v $orgID
realm-cli secrets create -n billing-usernameSecret -v $publicKeyOrg
realm-cli secrets create -n billing-passwordSecret -v $privateKeyOrg

realm-cli push --remote "billing" -y

echo Please wait a few seconds before we run the function ...

sleep 20

realm-cli function run --name "getData"