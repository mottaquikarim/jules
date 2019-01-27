FROM python:3.6 

COPY docker/jules/test.sh /test.sh

# Install dependencies directly instead of through serverless plugin for development
COPY ./requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --requirement /tmp/requirements.txt

# Install jules
COPY ./dist /tmp/dist
RUN \
  pip install \
  --no-index \
  --find-links /tmp/dist \
  jules 

