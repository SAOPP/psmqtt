FROM python:3.9.7 as build

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

VOLUME ["$VIRTUAL_ENV/conf"]

ENV PSMQTTCONFIG="$VIRTUAL_ENV/conf/psmqtt.conf"

FROM build as base
COPY --from=build --chown=psmqtt /opt/psmqtt $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"
CMD python psmqtt.py
