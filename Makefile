# make            -> serve KAT-Coder-V2.5-Dev IQ4_XS via llama.cpp (default)
# make single     -> Qwen3.8-27B, low latency (MTP/DFlash2 speculative decoding)
# make batch      -> Qwen3.8-27B, throughput
# make down       -> stop whatever is running
# make logs       -> follow the running server's logs
# One GPU: each serve target stops the other profiles first.

MODELS_DIR ?= ./models
KAT_GGUF   := $(MODELS_DIR)/gguf/Kwaipilot_KAT-Coder-V2.5-Dev-IQ4_XS.gguf
KAT_URL    := https://huggingface.co/bartowski/Kwaipilot_KAT-Coder-V2.5-Dev-GGUF/resolve/main/Kwaipilot_KAT-Coder-V2.5-Dev-IQ4_XS.gguf
COMPOSE    := docker compose
ALL_PROFILES := --profile kat --profile single --profile batch

.DEFAULT_GOAL := kat
.PHONY: kat single batch down logs status

kat: $(KAT_GGUF)
	$(COMPOSE) --profile single --profile batch down
	$(COMPOSE) --profile kat up -d kat
	@echo "KAT-Coder up on port $${PORT:-18020} (llama.cpp, OpenAI-compatible API)"

# 18.81 GB over a link that drops mid-transfer. Two hazards, both hit here:
# curl's own --retry does not cover a connection reset after data has started
# flowing (HTTP/2 stream resets, curl error 92 — hence --http1.1), and a
# resumed request that follows the HF redirect can come back as a full body
# that curl appends to the partial, silently producing an oversized, corrupt
# file. So: loop to resume, then verify the byte count against the CDN's
# Content-Length and start over from zero if it does not match.
# flock serializes concurrent `make` runs: a second one waits for the first
# instead of racing it into the same .part (two curls appending to one file
# produce a corrupt GGUF the container then crash-loops on).
$(KAT_GGUF):
	mkdir -p $(dir $@)
	@flock $(dir $@).download.lock $(MAKE) --no-print-directory $@.locked

.PHONY: $(KAT_GGUF).locked
$(KAT_GGUF).locked:
	@[ -f $(KAT_GGUF) ] && exit 0; \
	want=$$(curl -sLI --http1.1 "$(KAT_URL)" | awk 'BEGIN{IGNORECASE=1}/^content-length:/{n=$$2}END{gsub(/\r/,"",n);print n}'); \
	[ -n "$$want" ] || { echo "[make] could not read Content-Length from the CDN"; exit 1; }; \
	echo "[make] expecting $$want bytes"; \
	for attempt in 1 2 3 4 5; do \
	    until curl -L -C - --http1.1 --retry 5 --retry-delay 5 --retry-connrefused \
	           -o $(KAT_GGUF).part "$(KAT_URL)"; do \
	        echo "[make] transfer interrupted, resuming in 5s..."; sleep 5; \
	    done; \
	    got=$$(stat -c%s $(KAT_GGUF).part); \
	    [ "$$got" = "$$want" ] && { mv $(KAT_GGUF).part $(KAT_GGUF); echo "[make] $(KAT_GGUF) complete ($$got bytes)"; exit 0; }; \
	    echo "[make] size mismatch (got $$got, want $$want) — the resume corrupted it; restarting from zero"; \
	    rm -f $(KAT_GGUF).part; \
	done; \
	echo "[make] giving up after 5 attempts"; exit 1

single:
	$(COMPOSE) --profile kat --profile batch down
	$(COMPOSE) --profile single up -d single

batch:
	$(COMPOSE) --profile kat --profile single down
	$(COMPOSE) --profile batch up -d batch

down:
	$(COMPOSE) $(ALL_PROFILES) down

logs:
	$(COMPOSE) $(ALL_PROFILES) logs -f

status:
	$(COMPOSE) $(ALL_PROFILES) ps
