FROM continuumio/anaconda:5.0.1
LABEL maintainer="lizhenqing.fudan@gmail.com"
COPY ./environment.yml /root/environment.yml

RUN /opt/conda/bin/conda env create -f /root/environment.yml

# Install Java for h2o

# Set required env vars and install Java 8
COPY install_java /usr/sbin
RUN \
  chmod 700 /usr/sbin/install_java && \
  sync && \
  /usr/sbin/install_java
ENV \
  JAVA_HOME=/usr/lib/jvm/java-8-oracle \
  PATH=/usr/lib/jvm/java-8-oracle/bin:${PATH}

# Fetch h2o latest_stable
RUN \
   echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | tee /etc/apt/apt.conf.d/no-cache && \
   apt-get update -q -y && \
   DEBIAN_FRONTEND=noninteractive apt-get install -y wget unzip && \
  wget http://h2o-release.s3.amazonaws.com/h2o/latest_stable -O latest && \
  wget --no-check-certificate -i latest -O /opt/h2o.zip && \
  unzip -d /opt /opt/h2o.zip && \
  rm /opt/h2o.zip && \
  cd /opt && \
  cd `find . -name 'h2o.jar' | sed 's/.\///;s/\/h2o.jar//g'` && \ 
  cp h2o.jar /opt && \
  /opt/conda/bin/pip install --upgrade `find . -name "*.whl"` && \
  cd / && \
  wget https://raw.githubusercontent.com/h2oai/h2o-3/master/docker/start-h2o-docker.sh && \
  chmod +x start-h2o-docker.sh

EXPOSE 8888
EXPOSE 54321

ENV PATH /opt/conda/envs/apple/bin:$PATH
COPY start_jupyter.sh /root/start_jupyter.sh
VOLUME /codes
WORKDIR /codes

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/bin/bash", "/root/start_jupyter.sh"]

