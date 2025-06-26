FROM postgres:17

ENV SHELL /bin/bash

COPY ./load-extensions.sh /docker-entrypoint-initdb.d/
COPY ./postgresql.conf /var/lib/postgresql/

RUN mkdir /tmp/certs/

WORKDIR /tmp/certs/

COPY ./root-ca.cnf /tmp/certs/
COPY ./server.cnf /tmp/certs/

RUN openssl req -new -nodes -keyout "root-ca.key" -out "root-ca.csr" -subj '/C=FR/ST=FR/L=Paris/O=paris/CN=Dev CA' \
  && openssl x509 -req -days 3650 -in "root-ca.csr" -signkey "root-ca.key" -out "root-ca.pem" -extfile "root-ca.cnf" -extensions root_ca \
  && openssl req -new -nodes -keyout "server.key" -out "server.csr" -subj '/C=FR/ST=FR/L=Paris/O=paris/CN=tilt_db' \
  && openssl x509 -req -days 3650 -in "server.csr" -signkey "server.key" -out "server.pem" -CAcreateserial -extfile "server.cnf" -extensions server

RUN mv ./root-ca.pem /etc/postgresql/root-ca.pem \
  && mv ./server.key /etc/postgresql/server.key \
  && mv ./server.pem /etc/postgresql/server.pem

WORKDIR /

RUN rm -rf /tmp/certs/

RUN chown postgres:postgres /var/lib/postgresql/postgresql.conf /etc/postgresql/root-ca.pem /etc/postgresql/server.pem /etc/postgresql/server.key \
  && chmod 644 /var/lib/postgresql/postgresql.conf \
  && chmod 644 /etc/postgresql/root-ca.pem \
  && chmod 644 /etc/postgresql/server.pem \
  && chmod 600 /etc/postgresql/server.key

CMD [ "postgres", "-c", "config_file=/var/lib/postgresql/postgresql.conf" ]
