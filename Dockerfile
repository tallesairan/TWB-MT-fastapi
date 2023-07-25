FROM nvidia/cuda:11.8.0-devel-ubuntu22.04
# Pre-reqs
RUN apt-get update && apt-get install --no-install-recommends -y \
    git vim build-essential python3-dev python3-venv python3-pip curl wget
# Instantiate venv and pre-activate
RUN pip3 install virtualenv
RUN virtualenv /venv
# Credit, Itamar Turner-Trauring: https://pythonspeed.com/articles/activate-virtualenv-dockerfile/
ENV VIRTUAL_ENV=/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip3 install --upgrade pip setuptools && \
    pip3 install pip-tools && \
    pip3 install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cu117

COPY ./requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt \
    && rm -rf /root/.cache/pip

#Custom translator requirements
#COPY ./app/customtranslators/<customtranslatorname>/requirements.txt /app/customrequirements.txt
#RUN pip install -r /app/customrequirements.txt \
#    && rm -rf /root/.cache/pip

COPY . /app
WORKDIR /app

COPY ./app/nltk_pkg.py /app/nltk_pkg.py
RUN python /app/nltk_pkg.py
