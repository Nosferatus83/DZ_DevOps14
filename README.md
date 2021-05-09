# DZ_DevOps14

# Simple - на 80 порту nginx, tomcat на 8080/Puzzle15
# Template - шаблон по быстрому созданию нескольких параметризированых VM (vm-кол-во, cpu=vCPU и ram=RAM)



apt-get install google-cloud-sdk
gcloud auth application-default login

terraform plan
terraform apply
terraform apply -var 'vm=3' -var 'cpu=4' -var 'ram=16'
terraform show
terraform destroy
