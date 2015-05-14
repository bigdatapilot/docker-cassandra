FROM dronde/docker-java-8

MAINTAINER MAINTAINER Dominique Ronde <dominique.ronde@codecentric.de>

# Download and extract Cassandra
RUN mkdir /opt/cassandra;

RUN wget -O - http://www.us.apache.org/dist/cassandra/2.1.5/apache-cassandra-2.1.5-bin.tar.gz | tar xzf - --strip-components=1 -C "/opt/cassandra";

# Download and extract DataStax OpsCenter Agent
RUN mkdir /opt/agent;

RUN wget -O - http://downloads.datastax.com/community/datastax-agent-5.1.0.tar.gz | tar xzf - --strip-components=1 -C "/opt/agent";

ADD	. /src

# Copy over daemons
RUN cp /src/cassandra.yaml /opt/cassandra/conf/;

RUN mkdir -p /etc/service/cassandra;
RUN cp /src/cassandra-run /etc/service/cassandra/run;

RUN mkdir -p /etc/service/agent;
RUN cp /src/agent-run /etc/service/agent/run

# Expose ports
EXPOSE 7199 7000 7001 9160 9042

WORKDIR /opt/cassandra

CMD ["/sbin/my_init"]

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
