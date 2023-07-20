#! /usr/bin/env bash

set -eo pipefail

die() (
    echo "$1"
    exit 1
)

usage() (
    echo "Usage $0"
    echo "Options:"
    echo "-i <instance_id>                  Gantry jumpbox instance id."
    echo "-t <target>                       Target service. Default is 'airflow.workflow-services'."
    echo "-e <dev | prod>                   Deployment environment"
    echo "-p <local_port>                   Local port to bind. Default is 9999."
    echo "-h                                Display this help message."
)

while getopts ":i:t:e:p:oh" opt; do
    case "$opt" in
    i)
        instance=${OPTARG}
        ;;
    t)
        target=${OPTARG}
        ;;
    e)
        environment=${OPTARG}
        ;;
    p)
        port=${OPTARG}
        ;;
    o)
        openBrowser=true
        ;;
    h)
        usage
        exit 0
        ;;
    *)
        echo "Unknown options passed to the script."
        usage
        exit 1
        ;;
    esac
done

[[ -n "$instance" ]] || die "Gantry jumpbox instance id must be supplied."
[[ -z "$target" ]] && target="airflow.workflow-services"
[[ -z "$environment" ]] && environment="prod"
[[ -z "$port" ]] && port=9999

domain=""
if [[ "$environment" == "prod" ]]; then
    domain="seek-analytics.prod.outfra.xyz"
elif [[ "$environment" == "dev" ]]; then
    domain="hirer-analytics.dev.outfra.xyz"
else
    die "Unknown deployment environment."
fi

targetUrl="$target.$domain"

[[ "$openBrowser" == "true" ]] && open "https://$targetUrl:$port"

aws ssm start-session \
    --target "$instance" \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters "{\"host\":[\"$targetUrl\"],\"portNumber\":[\"443\"], \"localPortNumber\":[\"$port\"]}"
