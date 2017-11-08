FROM jupyter/scipy-notebook:da2c5a4d00fa

# handle non-project deps
RUN conda install -n root git

COPY environment.yml /home/jovyan/environment.yml

RUN conda env update -n root --file /home/jovyan/environment.yml && \
    conda clean -tipsy

RUN set -ex && \
  jupyter nbextension install rise --py --sys-prefix && \
  jupyter nbextension enable rise --py --sys-prefix && \
  jupyter nbextension enable ipywebrtc --py --sys-prefix

# do this to get the toolchain
RUN jupyter lab build

COPY ./labextensions/* /home/jovyan/labextensions/


RUN wget https://gist.githubusercontent.com/tonyfast/f95820ae08d137dac884e996a63b78b3/raw/literate-presentations.ipynb

# RUN set -ex && \
#  jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
#  jupyter labextension install file:///home/jovyan/labextensions/jupyter-webrtc-jupyterlab-0.1.0.tgz && \
#  jupyter labextension list

# copy and reown the files
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
