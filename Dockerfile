
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    build-essential \
    python3-pip \
    git

# Install Miniconda
RUN wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" && \
    bash Miniconda3-latest-Linux-x86_64.sh -b && \
    rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH="/root/miniconda3/bin:${PATH}"

# Update conda and install mamba
RUN conda update -n base conda && \
    conda install -y -c conda-forge mamba

# Install packages with mamba
RUN mamba install -y -c conda-forge -c bioconda pandas numpy matplotlib scipy


# Download blupf90
RUN curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/renumf90 && \
    curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/preGSf90 && \
    curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/Temp/remlf90 && \
    curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/Temp/airemlf90 && \
    curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/gibbsf90+ && \
    curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/blupf90+

# Move files to bin
RUN mv renumf90 /usr/local/bin/ && \
    mv preGSf90 /usr/local/bin/ && \
    mv remlf90 /usr/local/bin/ && \
    mv airemlf90 /usr/local/bin/ && \
    mv gibbsf90+ /usr/local/bin/ && \
    mv blupf90+ /usr/local/bin/

# Set permissions
RUN chmod 775 /usr/local/bin/renumf90 && \
    chmod 775 /usr/local/bin/preGSf90 && \
    chmod 775 /usr/local/bin/remlf90 && \
    chmod 775 /usr/local/bin/airemlf90 && \
    chmod 775 /usr/local/bin/gibbsf90+ && \
    chmod 775 /usr/local/bin/blupf90+

# Add blupf90 path to environment
RUN echo 'export PATH=/usr/local/bin:$PATH' >> ~/.bashrc

# Install Git and clone the repository
RUN apt-get install -y git && \
    git clone https://github.com/radumust18/python-animal-td-model

# Set the working directory to the repository
WORKDIR /python-animal-td-model

# Install am_tdm with pip
RUN pip install .

# Check if package is installed
RUN pip list

