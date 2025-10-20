# add extensions to cnpg postgresql image: timescaledb, pg_cron
ARG POSTGRESQL_VERSION=15.3
ARG EXTENSIONS="timescaledb cron"
ARG TIMESCALEDB_VERSION=2.11.0


FROM ghcr.io/cloudnative-pg/postgresql:${POSTGRESQL_VERSION}
ARG POSTGRESQL_VERSION
ENV POSTGRESQL_VERSION=${POSTGRESQL_VERSION}
ARG EXTENSIONS
ENV EXTENSIONS=${EXTENSIONS}
ARG TIMESCALEDB_VERSION
ENV TIMESCALEDB_VERSION=${TIMESCALEDB_VERSION}

COPY ./install_pg_extensions.sh /
# switch to root user to install extensions
USER root
RUN \
    apt-get update && \
    PG_MAJOR="${POSTGRESQL_VERSION%%.*}" /install_pg_extensions.sh ${EXTENSIONS} && \
    # cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /install_pg_extensions.sh
# switch back to the postgres user
USER postgres
