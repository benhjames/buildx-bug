FROM python:3.7.10-slim as base

WORKDIR /app

# Build the dependencies
FROM base as builder

RUN apt-get update && apt-get install -y curl build-essential

# Magnitude
RUN curl -Lo crawl-300d-2M.magnitude http://magnitude.plasticity.ai/fasttext/medium/crawl-300d-2M.magnitude

RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

COPY ./requirements.txt ./requirements.txt
RUN pip install -r ./requirements.txt

# Copy the built dependencies
FROM base as final

COPY --from=builder /opt/venv /opt/venv
COPY --from=builder /app/crawl-300d-2M.magnitude ./crawl-300d-2M.magnitude

# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"
