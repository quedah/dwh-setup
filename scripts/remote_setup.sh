#!/bin/bash



source env.sh

DWH_USER=$USER
homedir="/home/${DWH_USER}"


# Docker
## Update and install Docker requirements
sudo apt-get update
sudo apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  make \
  software-properties-common \
  python3-pip \
  build-essential \
  libssl-dev \
  libffi-dev \
  python3-dev

## Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
### Should check against this. Automate later
# sudo apt-key fingerprint 0EBFCD88

## Add repository, update and install Docker
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io 


# Get Docker Compose v1.28
# as per docker docs here: https://docs.docker.com/compose/install/
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create user
#sudo usermod -aG docker ${DWH_USER}

# Setup Airflow
#git clone https://github.com/quedah/docker-airflow.git
#cd docker-airflow
#docker-compose -f docker-compose-LocalExecutor.yml up

cd ${homedir}
#sudo -u ${user} git clone https://github.com/quedah/cloud-data-lake.git
git clone https://github.com/quedah/dwh.git


# I keep using this, so add to remote 
git clone https://github.com/quedah/custom_shell.git 
cd custom_shell && bash setup_vim.sh && cd ~/
echo "alias ..=\"cd ..\"" >> ${homedir}/.bashrc

# Set GCP keyfile location
echo "export GOOGLE_APPLICATION_CREDENTIALS=\"~/keyfile.json\" >> ${homedir}/.bashrc"

# Setup nginx
sudo apt-get -y install nginx
sudo cp ~/nginx.conf /etc/nginx/sites-enabled/default
sudo service nginx restart

# Setup airflow
sudo pip3 install apache-airflow[gcp,google_auth]
echo "export AIRFLOW_HOME=\"~/dwh\"" >> ${homedir}/.bashrc
echo "export GOOGLE_APPLICATION_CREDENTIALS=\"~/keyfile.json\"" >> ${homedir}/.bashrc
echo "PATH=$PATH:~/.local/bin" >> ${homedir}/.bashrc
airflow db init
airflow users create -r Admin -u ${AIRFLOW_USERNAME} -e ed@quedah.com -f Ed -l Din -p ${AIRFLOW_PW}


