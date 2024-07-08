FROM sbtscala/scala-sbt:eclipse-temurin-focal-11.0.22_7_1.9.9_2.12.19 AS builder
RUN mkdir -p /opt/eventsim
WORKDIR /opt/eventsim

COPY . /opt/eventsim
RUN sbt plugins
RUN sbt assembly

FROM eclipse-temurin:11-jre
RUN mkdir -p /opt/eventsim
WORKDIR /opt/eventsim

COPY docker/eventsim.sh /opt/eventsim/eventsim.sh
COPY examples /opt/eventsim/examples
COPY data /opt/eventsim/data
COPY --from=builder /opt/eventsim/target/scala-2.12/eventsim-assembly-2.0.jar /opt/eventsim/eventsim-assembly-2.0.jar
ENTRYPOINT ["./eventsim.sh", "-c", "./examples/example-config.json", "--from", "365", "--nusers", "1000", "--growth-rate", "0.01", "./output"]
