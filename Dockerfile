FROM jupyter/base-notebook:latest

USER $NB_UID

RUN mkdir -p /home/jovyan/.ssh/config

RUN pip install --user mkdocs mkdocs-material

ENV PATH=/home/jovyan/.local/bin:$PATH

WORKDIR /docs

ENTRYPOINT ["mkdocs"]

CMD ["--version"]