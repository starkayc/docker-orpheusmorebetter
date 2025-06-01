# Set the base image
FROM python:3.13-alpine3.22

LABEL maintainer="StarKayC"

# Update System, Install packages & Clone Repo
RUN apk update && \
    apk add git mktorrent flac lame sox && \
    git clone https://github.com/walkrflocka/orpheusmorebetter /app

# Create User, Create Folders, Set Permissions
RUN adduser -D orpheus && \
    mkdir /config /data && \
    chown orpheus:orpheus -R /app /config /data

# Set User
USER orpheus

# Set Home Folder, Timezone, Hostname
ENV HOME=/config \
    TZ=Etc/UTC \
    HOSTNAME=orpheusmorebetter

# Set the working directory
WORKDIR /app

# Install pip packages
RUN pip install -r requirements.txt

# Have EntryPoint run app using command option
ENTRYPOINT ["/app/orpheusmorebetter"]
CMD []