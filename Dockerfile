FROM alpine:3.15.0 as build

RUN apk add python3 py3-pip git build-base python3-dev libffi-dev openssl-dev

WORKDIR /opt
RUN python3 -m venv env

WORKDIR /opt/asknavidrome
COPY . .

RUN source ../env/bin/activate && pip --no-cache-dir install wheel && pip --no-cache-dir install -r skill/requirements-docker.txt


FROM alpine:3.15.0

RUN apk add python3

COPY --from=build /opt/env /opt/env
COPY --from=build /opt/asknavidrome/skill /opt/asknavidrome/

WORKDIR /opt/asknavidrome

# Activate Python Virtual Environment
ENV PATH="/opt/env/bin:$PATH"

EXPOSE 5000

ENTRYPOINT ["python3", "app.py"]