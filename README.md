# Docker container for tabular data predictions

Build `docker build -t docker-tabular:latest .`

Run `docker run -it --rm --gpus all docker-tabular:latest`

Run tool `fuser -k 9090/tcp |  planemo serve --docker_run_extra_arguments "--gpus all" --docker tabular-prediction.xml`