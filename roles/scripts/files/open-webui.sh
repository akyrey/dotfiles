#!/bin/bash

docker run -d --rm \
  --network=host \
	--gpus all \
  --volume open-webui:/app/backend/data \
  -e OLLAMA_BASE_URL=http://localhost:11434 \
	--name open-webui \
	ghcr.io/open-webui/open-webui:main
