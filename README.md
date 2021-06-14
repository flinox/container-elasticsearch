# Introduction 
ElasticSearch and Kibana running inside a docker container!

## Configurando os arquivos para elasticsearch e kibana **config**
```
/config/elasticsearch.yml
/config/kibana.yml
```

## Dockerfile
```
FROM debian:latest

WORKDIR /opt

# Settings

ENV elastic_version="elasticsearch-7.12.0"
ENV kibana_version="kibana-7.12.0"
ENV platform="linux-x86_64" 
ENV username="elastic"
ENV PATH="${PATH}:/opt/${elastic_version}/bin:/opt/${kibana_version}/bin"

# Updates / Tools / Users

RUN apt-get update && \
    apt-get install -y apt-utils wget procps curl

RUN groupadd -r ${username} --gid 1000
RUN useradd -ms /bin/bash -r -g ${username} ${username} --uid 1000

# Install ElasticSearch

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/${elastic_version}-${platform}.tar.gz 
RUN tar -xvzf ${elastic_version}-${platform}.tar.gz -C . && \
    rm ${elastic_version}-${platform}.tar.gz

RUN chown elastic:elastic /opt/${elastic_version} -R

COPY /config/elasticsearch.yml /opt/${elastic_version}/config

EXPOSE 9200

# Install Kibana

RUN wget https://artifacts.elastic.co/downloads/kibana/${kibana_version}-${platform}.tar.gz 
RUN tar -xvzf ${kibana_version}-${platform}.tar.gz -C . && \
    rm ${kibana_version}-${platform}.tar.gz && \
    mv /opt/${kibana_version}-${platform} /opt/${kibana_version}    

RUN chown elastic:elastic /opt/${kibana_version} -R

COPY /config/kibana.yml /opt/${kibana_version}/config

EXPOSE 5601

# Rodar automaticamente
RUN echo "elasticsearch & sleep 20 && kibana" >> /home/${username}/.bashrc 

WORKDIR /opt/${elastic_version}

USER ${username}
```

## Build da imagem
Exemplo:
```
docker build -t flinox/elastic-search:7.12.0 .
```

## Execução da imagem 
Exemplo:
```
docker run --rm -it --name elastic-search --hostname elastic-search \
-v "$(pwd)/data/:/elasticsearch/data/" \
-v "$(pwd)/logs/:/elasticsearch/logs/" \
-p 9200:9200 \
-p 5601:5601 \
flinox/elastic-search:7.12.0
```

## Start ElasticSearch e Kibana
```
elasticsearch & sleep 20 && kibana
```

## Test inside container
```
docker exec -it elastic-search curl -XGET 'http://127.0.0.1:9200'
```

## Test outside container
[http://localhost:9200](http://localhost:9200)

### Health check
[http://localhost:9200/_cluster/health](http://localhost:9200/_cluster/health)



# Referencias
- https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html