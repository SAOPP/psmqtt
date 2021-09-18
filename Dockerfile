FROM python:3.9.7

RUN mkdir -p /opt/psmqtt
WORKDIR /opt/psmqtt
RUN mkdir -p /var/log/psmqtt

ENV VIRTUAL_ENV=/opt/psmqtt
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt

RUN useradd --create-home psmqtt
USER psmqtt

VOLUME ["/opt/psmqtt/conf"]

ENV PSMQTTCONFIG="/opt/psmqtt/conf/psmqtt.conf"

COPY --chown=psmqtt . $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"
CMD python psmqtt.py
