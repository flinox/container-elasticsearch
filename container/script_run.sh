docker run --rm -it --name elastic-search --hostname elastic-search \
-v "$(pwd)/data/:/elasticsearch/data/" \
-v "$(pwd)/logs/:/elasticsearch/logs/" \
-v "$(pwd)/files/:/elasticsearch/files/" \
-p 9200:9200 \
-p 5601:5601 \
flinox/elastic-search:7.12.0 