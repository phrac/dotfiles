#!/bin/bash
curl -XPUT "localhost:9200/_river/mongogridfs/_meta" -d'
{
    type: "mongodb",
    mongodb: {
        db: "partfindr", 
        host: "127.0.0.1",
        collection: "parts", 
        gridfs: true
    },
    index: {
        name: "partfindr_part_index", 
        type: "part"
    }
}'
