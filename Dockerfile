FROM python:3.9.7 as build
#FROM python:3.7.9

# based on https://github.com/pfichtner/docker-mqttwarn

# install python libraries
#RUN pip install -r requirements.txt

RUN mkdir -p /opt/psmqtt
WORKDIR /opt/psmqtt
RUN mkdir -p /var/log/psmqtt

ENV VIRTUAL_ENV=/opt/psmqtt
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

#RUN mkdir -p /opt/psmqtt
#WORKDIR /opt/psmqtt
#RUN mkdir -p /var/log/psmqtt

COPY requirements.txt .
RUN pip install -r requirements.txt

RUN useradd --create-home psmqtt
USER appuser


# add user psmqtt to image
#RUN groupadd -r psmqtt && useradd -r -g psmqtt psmqtt
#RUN chown -R psmqtt:psmqtt /opt/psmqtt
#RUN chown -R psmqtt:psmqtt /var/log/psmqtt
#RUN chown -R psmqtt /home/psmqtt

# process run as psmqtt user
#USER psmqtt

# conf file from host
VOLUME ["/opt/psmqtt/conf"]

# set conf path
ENV PSMQTTCONFIG="/opt/psmqtt/conf/psmqtt.conf"

# finally, copy the current code (ideally we'd copy only what we need, but it
#  is not clear what that is, yet)
#COPY . /opt/psmqtt
COPY --from=build --chown=psmqtt /opt/psmqtt $VIRTUAL_ENV

# run process
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
CMD python psmqtt.py
