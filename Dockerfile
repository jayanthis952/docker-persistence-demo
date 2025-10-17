FROM ubuntu:22.04
LABEL maintainer="jayanthi1200@gmail.com" version="1.0"
ENV APP_NAME="PersistenceDemo"
ARG GREETING="Hello from Docker!"
WORKDIR /app
COPY ./app /app
ADD ./extra /app/extra
RUN apt-get update && apt-get install -y curl && \
    mkdir -p /data_volume && \
    echo "Setup complete"
EXPOSE 8080
VOLUME /data_volume
RUN useradd -ms /bin/bash appuser
USER appuser
ENTRYPOINT ["echo", "Container started:"]
CMD ["$GREETING"]

