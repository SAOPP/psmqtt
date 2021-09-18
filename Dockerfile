FROM python:3.9.7 as start

ENV VIRTUAL_ENV=/opt/psmqtt
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt

RUN useradd --create-home psmqtt
USER psmqtt

VOLUME ["/opt/psmqtt/conf"]

ENV PSMQTTCONFIG="/opt/psmqtt/conf/psmqtt.conf"

# FROM start as final
# COPY --from=start --chown=psmqtt /opt/psmqtt $VIRTUAL_ENV

# ENV PATH="$VIRTUAL_ENV/bin:$PATH"
# CMD python psmqtt.py
COPY psmqtt.py .
CMD ["python", "psmqtt.py"]

# FROM python:3.9.7

# # based on https://github.com/pfichtner/docker-mqttwarn

# # install python libraries
# #RUN pip install -r requirements.txt

# RUN mkdir -p /opt/psmqtt
# WORKDIR /opt/psmqtt
# RUN mkdir -p /var/log/psmqtt

# COPY ./requirements.txt /opt/psmqtt
# RUN pip install -r /opt/psmqtt/requirements.txt

# # add user psmqtt to image
# RUN groupadd -r psmqtt && useradd -r -g psmqtt psmqtt
# RUN chown -R psmqtt:psmqtt /opt/psmqtt
# RUN chown -R psmqtt:psmqtt /var/log/psmqtt
# #RUN chown -R psmqtt /home/psmqtt

# # process run as psmqtt user
# USER psmqtt

# # conf file from host
# VOLUME ["/opt/psmqtt/conf"]

# # set conf path
# ENV PSMQTTCONFIG="/opt/psmqtt/conf/psmqtt.conf"

# # finally, copy the current code (ideally we'd copy only what we need, but it
# #  is not clear what that is, yet)
# COPY . /opt/psmqtt

# # run process
# CMD python psmqtt.py
