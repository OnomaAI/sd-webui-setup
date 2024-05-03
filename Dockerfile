# Dockerfile
# docker pull pytorch/pytorch:2.1.2-cuda11.8-cudnn8-devel
# use the pytorch image as the base image
FROM python:3.10.11-buster
# Enable CUDA access
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
# check python torch cuda is_avai   lable
#RUN python -c "import torch; assert (torch.cuda.is_available())"

# RUN useradd -rm -d /home/nonroot -s /bin/bash -g root -G sudo -u 1001 nonroot
# RUN usermod -aG sudo nonroot
# USER nonroot

WORKDIR /app
RUN apt-get update
# Install the OpenGL libraries required by OpenCV
RUN apt-get install -y libgl1-mesa-glx

COPY /source /app/autobuild

# install dependencies (requirements.txt and requirements-versions.txt)
RUN bash /app/autobuild/setup.sh



# Expose the necessary port
EXPOSE 9052


# run and close co
# Set the command to run your application
# cd stable-diffusion-webui then run webui.sh
WORKDIR /app/autobuild/stable-diffusion-webui
CMD ./webui.sh
