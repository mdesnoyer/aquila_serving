# NOTE: This will require more than the default (8gb) amount of space afforded to new instances. Make sure you increase it!

# Install various packages
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y build-essential curl libfreetype6-dev libpng12-dev libzmq3-dev pkg-config python-pip python-dev git python-numpy python-scipy swig software-properties-common  python-dev default-jdk zip zlib1g-dev ipython

# upgrade six & install gRPC systemwide
sudo pip install --upgrade six
sudo pip install grpcio

# Blacklist Noveau which has some kind of conflict with the nvidia driver
echo -e "blacklist nouveau\nblacklist lbm-nouveau\noptions nouveau modeset=0\nalias nouveau off\nalias lbm-nouveau off\n" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
echo options nouveau modeset=0 | sudo tee -a /etc/modprobe.d/nouveau-kms.conf
sudo update-initramfs -u
sudo reboot # Reboot (annoying you have to do this in 2015!)


# Some other annoying thing we have to do
sudo apt-get install -y linux-image-extra-virtual
sudo reboot # Not sure why this is needed


# Install latest Linux headers
sudo apt-get install -y linux-source linux-headers-`uname -r` 


# Install CUDA 7.0 (note – don't use any other version)
wget http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/cuda_7.0.28_linux.run
chmod +x cuda_7.0.28_linux.run
./cuda_7.0.28_linux.run -extract=`pwd`/nvidia_installers
cd nvidia_installers
sudo ./NVIDIA-Linux-x86_64-346.46.run # accept everything it wants to do 
sudo modprobe nvidia
sudo ./cuda-linux64-rel-7.0.28-19326674.run # accept the EULA, accept the defaults
cd


# trasfer cuDNN over from elsewhere (you can't download it directly)
tar -xzf cudnn-6.5-linux-x64-v2.tgz 
sudo cp cudnn-6.5-linux-x64-v2/libcudnn* /usr/local/cuda/lib64
sudo cp cudnn-6.5-linux-x64-v2/cudnn.h /usr/local/cuda/include/


# OPTIONAL
# To increase free space, remove cuda install file & nvidia_installers
cd
rm -v cuda_7.0.28_linux.run
rm -rfv nvidia_installers/


# update to java 8 -- is this the best way to do this?
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-set-default

# this helps deal with the ABSOFUCKINGLUTELY COLOSSAL space requirements
# of bazel and tensorflow
cd /mnt/tmp
sudo mkdir /mnt/tmp
sudo chmod 777 /mnt/tmp
sudo rm -rf /tmp
sudo ln -s /mnt/tmp /tmp
# ^^^ might not be necessary

# install Bazel
git clone https://github.com/bazelbuild/bazel.git
cd bazel
git checkout tags/0.2.1  # note you can check the tags with git tag -l, you need at least 0.2.0
./compile.sh
sudo cp output/bazel /usr/bin


# more CUDA stuff - edit ~/.bashrc to put this in!
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64"
export CUDA_HOME=/usr/local/cuda


# install tensorflow / tensorflow serving
cd
git clone --recurse-submodules https://github.com/neon-lab/aquila_serving.git
cd aquila_serving/tensorflow
# configure tensorflow; unofficial settings are necessary given the GRID compute cap of 3.0
TF_UNOFFICIAL_SETTING=1 ./configure  # accept the defaults; build with gpu support; set the compute capacity to 3.0
cd ..
bazel build tensorflow_serving/...  # build the whole source tree - this will take a bit


# convert tensorflow into a pip repo
cd tensorflow
bazel build -c opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
sudo pip install /tmp/tensorflow_pkg/tensorflow-0.7.1-py2-none-linux_x86_64.whl



# clone aquila
cd ~
git clone https://github.com/neon-lab/aquila.git


