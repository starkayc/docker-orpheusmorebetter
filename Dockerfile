# Base image (builder)
FROM python:3.13-alpine3.23 AS builder

LABEL maintainer="StarKayC"

# For reproducible builds, pin OMB_REF to a tag or commit.
ARG OMB_REPO_URL="https://github.com/walkrflocka/orpheusmorebetter"
ARG OMB_REF="master"

# Fetch source and build Python deps in a venv
RUN apk add --no-cache --virtual .fetch-deps git \
    && git clone --depth 1 --branch "${OMB_REF}" --single-branch "${OMB_REPO_URL}" /app \
    && rm -rf /app/.git /app/.github /app/tests \
    && rm -f /app/.gitignore /app/README.md /app/LICENSE \
    && python -m venv /venv \
    && /venv/bin/pip install --no-cache-dir -r /app/requirements.txt \
    && apk del .fetch-deps

# Runtime image
FROM python:3.13-alpine3.23

# Runtime defaults (override in compose if needed)
ENV HOME=/config \
    TZ=Etc/UTC \
    HOSTNAME=orpheusmorebetter \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/venv/bin:$PATH"

# Install runtime packages
RUN apk add --no-cache \
        mktorrent \
        flac \
        lame \
        sox

# Create user and writable folders
RUN adduser -D -h /config orpheus \
    && mkdir -p /app /config /data \
    && chown -R orpheus:orpheus /config /data

COPY --from=builder --chown=orpheus:orpheus /app /app
COPY --from=builder --chown=orpheus:orpheus /venv /venv

# Workdir set to writable config dir for relative writes
WORKDIR /config

# Run as non-root
USER orpheus

# Entrypoint runs the app; args come from CMD/compose
ENTRYPOINT ["/app/orpheusmorebetter"]
CMD []
