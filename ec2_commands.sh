#!/bin/bash

menu(){
echo "Please Selece Your Command:"
commands=("create_inatance" "tag_instance" "Instance_info" "Start Instance" "Stop Instance" "Terminate An Instance" 
"Create A New EBS Volume And Attach It To An Instance" "Quit")
COLUMNS=1
select i in "${commands[@]}"
do
    case $i in
    "create_inatance") create_instance ;;
    "tag_instance") tag_instance ;;
    "Instance_info") get_ec2_info ;;
    "Start Instance") start_instance ;;
    "Stop Instance") stop_instance ;;
    "Terminate An Instance") terminate_instance;;
    "Create A New EBS Volume And Attach It To An Instance") echo "in the futrue";;
    "Quit") exit ;;
     esac
done
}

create_instance(){
    read -p "Enter instance image id: " ami
    read -p "Enter instance type: " intype
    create=$(aws ec2 run-instances --image-id $ami --instance-type $intype)
    echo
    menu
}
tag_instance(){
    read -p "enter instance id that you want to tag " num_id
    instance=$(aws ec2 start-instances --instance-ids $num_id)
    read -p "Enter instance name: " instaName
    tag_instance=$(aws ec2 create-tags --resources $num_id --tags Key=Name,Value=$instaName)
    echo
    menu
}

get_ec2_info(){
    name_command=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=*" \
    --query 'Reservations[*].Instances[*].[PublicIpAddress,InstanceId,Tags[?Key==`Name`].Value]' \
    --output text)
    echo "the information on instances: "
    echo $name_command
    echo
    menu
}


start_instance(){
    read -p "Enter The ID Number of An Instance " num_id
    if [[ $num_id != null ]]
    then
        start=$(aws ec2 start-instances --instance-ids $num_id)
        echo "The Isntance $num_id is starting"
    else
        echo "Instance is not exist"
    fi
    echo
    menu
}

stop_instance(){
    read -p "Enter The ID Number of An Instance " num_id
    if [[ $num_id != null ]]
    then
        stop=$(aws ec2 stop-instances --instance-ids $num_id)
        echo "The Isntance $num_id is stoping"
    else
        echo "Instance is not exist"
    fi
    echo
    menu
}

terminate_instance(){
    read -p "Enter The ID Number of An Instance " num_id
    if [[ $num_id != null ]]
    then
        terminate=$(aws ec2 terminate-instances --instance-ids $num_id)
        echo "The Isntance $num_id is stoping"
    else
        echo "Instance is not exist"
    fi
    echo
    menu
}


while true
do
    menu
done