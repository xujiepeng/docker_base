FROM python:3.6-alpine

# Copy in your requirements file
ADD ./requirements.txt /requirements.txt

# OR, if you’re using a directory for your requirements, copy everything (comment out the above and uncomment this if so):
# ADD requirements /requirements

# Install build deps, then run `pip install`, then remove unneeded build deps all in a single step. Correct the path to your production requirements file, if needed.
RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
            gcc \
            make \
            libc-dev \
            musl-dev \
            linux-headers \
            pcre-dev \
            mysql-dev \
            openldap-dev \
            libxslt-dev \
    && pyvenv /venv \
    && /venv/bin/pip install -U pip \
    && LIBRARY_PATH=/lib:/usr/lib /bin/sh -c "/venv/bin/pip install --no-cache-dir -r /requirements.txt" \
    && runDeps="$( \
            scanelf --needed --nobanner --recursive /venv \
                    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
                    | sort -u \
                    | xargs -r apk info --installed \
                    | sort -u \
    )" \
    && apk add --virtual .python-rundeps $runDeps \
    && apk del .build-deps


