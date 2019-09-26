## DEMO Sources for Kafka Meetup DUS 2019-09
These are the sources for the demo of my talk "A Zero Code Tracking Pipeline
at METRO Markets" from the Apache Kafka Meetup in Düsseldorf.

### Abstract
Short before the launch of the METRO Markets' marketplace at https://www.metro.de/marktplatz/
we needed to build an event and user tracking platform to log events relevant to
monitor the business KPIs of our site.  
Confronted with having also frontend JS applications as well as several backend APIs and
services, we wanted to find a quick and elegant solution to reliably track
business events on this distributed system.  
We summarized the problems that might occur und found a way using Apache Kafka
and tools from the Kafka ecosystem, like [Confluent REST Proxy](https://docs.confluent.io/current/kafka-rest/index.html)
and [Confluent's Kafka Connect HTTP Sink](https://docs.confluent.io/current/connect/kafka-connect-http/index.html),
to easily build a pipeline that gathers all tracking messages in the distributed
log and forward them to our analytics providers without writing any line of code.

### Slides
The slides are on Speakerdeck:  
https://speakerdeck.com/rk3rn3r/kafka-meetup-dus-a-zero-code-tracking-pipeline-with-apache-kafka-at-metro-markets

### Requirements

- Docker and docker-compose should be setup properly
- GNU make for using the commands from the Makefile
- Curl to call the HTTP REST endpoints from the Makefile
- Pyhton installed to start `scripts/server.py` dummy webserver

### Config

#### config/tracking-http-sink.json
In `config/tracking-http-sink.json` replace the IP address `"http.api.url": "http://172.20.0.1:8080"`
with the proper IP address of your docker host **inside** the docker `meetup201909` network.  
On Docker Desktop for Mac you could for example use `host.docker.internal` as hostname
(not supported on Windows or Linux yet).

### Usage

1. `make startup` will start all instances from docker-compose.yml
(first 3 Zookeeper nodes, then 3 brokers, then REST Proxy and Kafka Connect Distributed)

2. `make listtopics` uses _kafka-topics_ command inside the connect container to
show a list of available topics. Only some management topics should be there:

         __consumer_offsets                                                                                                                                                                 
        meetup201909-connect-configs                                                                                                                                                                 
        meetup201909-connect-offsets                                                                                                                                                                 
        meetup201909-connect-status
    
3. `make createtopics` to create the tracking topics from the TRACKING_TOPICS env file

4. `make listtopics` should now give you the previous list including the `tracking` topic

         __consumer_offsets                                                                                                                                                                 
        meetup201909-connect-configs                                                                                                                                                                 
        meetup201909-connect-offsets                                                                                                                                                                 
        meetup201909-connect-status
        tracking
        
5. `make trackinglog` will now start a `kafka-console-consumer` on the tracking topic.  
There are no data in the topic right now, but we keep the connection open and switch to
the other terminal/console window.

6. On the second terminal/console window we can now start `make sendbatch` which will
use `scripts/batch_test.sh` script to send some message to the Kafka REST Proxy
on _http://localhost:58082/topics/tracking_  
When switching back to terminal/console 1 we'll see that we now got data send into Kafka
via Confluent REST Proxy.

7a. On terminal/console 1 (the one with the Kafka topic consumer) we now exit consuming with
`CTRL - C` and with the next step we want to confirm that the Connect HTTP Sink actually sends
data to a HTTP server.

7b. For this we will now start a simple HTTP server with `make webserver`. It'll
start the Python dummy webserver from `scripts/server.py`, which basically shows the
request body and headers so we can confirm that the data we want to be send by the
HTTP sink are actually send properly. It plays the role of the HTTP endpoint of
the analytics provider.

8. Finally we switch back to the other terminal/console again and start the HTTP Sink using
Kafka Connect Distributed (KCD) REST API with `make connectorstart`.  
We can check if it's up and running with `make connectorstatus`.

When we switch to the other terminal/console window again (the one running the dummy
webserver), we could see that the HTTP sink successfully send the messages from the topic
to our webserver (our fake analytics provider) as batches.

### Removing Containers

Run `make stop` to stop and remove the containers.


### License

Apache Licenses 2.0
