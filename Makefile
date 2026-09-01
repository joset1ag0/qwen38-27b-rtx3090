# make            -> serve KAT-Coder-V2.5-Dev IQ4_XS via llama.cpp (default)
# make chat       -> talk to whatever is running, in the terminal
# make chat-web   -> the same, in llama.cpp's built-in browser UI (kat only)
# make codex      -> Codex CLI on the local server (kat profile must be up)
# make single     -> Qwen3.8-27B, low latency (MTP/DFlash2 speculative decoding)
# make batch      -> Qwen3.8-27B, throughput
# make wakeproxy  -> install the wake proxy: requests to :18021 boot kat if down
# make down       -> stop whatever is running
# make logs       -> follow the running server's logs
# One GPU: each serve target stops the other profiles first.

MODELS_DIR ?= ./models
KAT_GGUF   := $(MODELS_DIR)/gguf/Kwaipilot_KAT-Coder-V2.5-Dev-IQ4_XS.gguf
KAT_URL    := https://huggingface.co/bartowski/Kwaipilot_KAT-Coder-V2.5-Dev-GGUF/resolve/main/Kwaipilot_KAT-Coder-V2.5-Dev-IQ4_XS.gguf
COMPOSE    := docker compose
ALL_PROFILES := --profile kat --profile single --profile batch

.DEFAULT_GOAL := kat
.PHONY: kat single batch down logs status chat chat-web codex wakeproxy

kat: $(KAT_GGUF)
	$(COMPOSE) --profile single --profile batch down
	$(COMPOSE) --profile kat up -d --force-recreate kat
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

# --force-recreate on the serve targets: the cross-profile `down` above removes
# the project network, and a plain `up` would restart the existing stopped
# container still wired to the old network id ("network ... not found").
single:
	$(COMPOSE) --profile kat --profile batch down
	$(COMPOSE) --profile single up -d --force-recreate single

batch:
	$(COMPOSE) --profile kat --profile single down
	$(COMPOSE) --profile batch up -d --force-recreate batch

down:
	$(COMPOSE) $(ALL_PROFILES) down

logs:
	$(COMPOSE) $(ALL_PROFILES) logs -f

status:
	$(COMPOSE) $(ALL_PROFILES) ps

# Talk to whichever server is up — the script reads PORT and VLLM_API_KEY from
# .env and asks /v1/models for the name, so it works against kat, single and
# batch alike.
chat:
	@python3 scripts/chat.py

# Codex CLI against the local server, via the `kat` profile in
# ~/.codex/kat.config.toml (codex >= 0.151 keeps each profile in its own
# file, and only speaks wire_api = "responses" — fine, llama.cpp serves
# /v1/responses). The API key travels through the env var named in the
# provider's env_key. Codex always sends a `developer` message, which the
# stock KAT chat template rejects ("System message must be at the beginning");
# the kat service therefore runs with --chat-template-file templates/kat.jinja,
# a patched template that folds leading system messages into one block.
codex:
	@KAT_API_KEY=$$(grep VLLM_API_KEY .env | cut -d= -f2) codex --profile kat

# Codex talks to the wake proxy (:18021), not to the server directly: a tiny
# always-on user service that boots kat via `make` when a request arrives and
# the server is down (it gets stopped to give the RAM/VRAM back to the desktop).
wakeproxy:
	mkdir -p $(HOME)/.config/systemd/user
	sed "s|@REPO@|$(CURDIR)|" scripts/kat-wakeproxy.service > $(HOME)/.config/systemd/user/kat-wakeproxy.service
	systemctl --user daemon-reload
	systemctl --user enable --now kat-wakeproxy.service
	@echo "wake proxy up on 127.0.0.1:18021 (boots kat on first request)"

# llama.cpp ships a browser UI on the same port (kat profile only; vLLM has
# none). It asks for the API key on first use — that is the VLLM_API_KEY below.
chat-web:
	@echo "API key: $$(grep VLLM_API_KEY .env | cut -d= -f2)"
	@xdg-open http://127.0.0.1:$${PORT:-18020} >/dev/null 2>&1 \
	  || echo "open http://127.0.0.1:$${PORT:-18020} in your browser"
