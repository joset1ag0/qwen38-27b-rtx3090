#!/usr/bin/env python3
"""Terminal chat against the local server (llama.cpp `kat` or vLLM `single`/`batch`).

Reads the endpoint and key from .env, keeps the conversation in memory, and
streams the reply. Ctrl-C or an empty line at the prompt exits; /reset starts a
new conversation.
"""
import json
import os
import sys
import urllib.error
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def env(name, default=""):
    val = os.environ.get(name)
    if val:
        return val
    try:
        with open(os.path.join(ROOT, ".env"), encoding="utf-8") as fh:
            for line in fh:
                line = line.strip()
                if line.startswith(f"{name}="):
                    return line.split("=", 1)[1]
    except FileNotFoundError:
        pass
    return default


PORT = env("PORT", "18020")
BASE = f"http://127.0.0.1:{PORT}"
KEY = env("VLLM_API_KEY")


def post(path, payload, stream=False):
    req = urllib.request.Request(
        BASE + path,
        data=json.dumps(payload).encode(),
        headers={"Content-Type": "application/json",
                 **({"Authorization": f"Bearer {KEY}"} if KEY else {})},
    )
    return urllib.request.urlopen(req, timeout=None if stream else 30)


def model_name():
    req = urllib.request.Request(
        BASE + "/v1/models",
        headers={"Authorization": f"Bearer {KEY}"} if KEY else {},
    )
    with urllib.request.urlopen(req, timeout=10) as resp:
        data = json.load(resp)
    entries = data.get("data") or data.get("models") or []
    return (entries[0].get("id") or entries[0].get("name")) if entries else "default"


def main():
    try:
        model = model_name()
    except (urllib.error.URLError, OSError) as exc:
        sys.exit(f"no server on {BASE} ({exc}). Start one with `make` (KAT) or "
                 f"`make single` / `make batch` (Qwen).")

    print(f"{model} @ {BASE} — empty line or Ctrl-C to quit, /reset to clear history\n")
    messages = []
    while True:
        try:
            user = input("\033[1m>\033[0m ").strip()
        except (EOFError, KeyboardInterrupt):
            print()
            return
        if not user:
            return
        if user == "/reset":
            messages = []
            print("(history cleared)\n")
            continue

        messages.append({"role": "user", "content": user})
        payload = {"model": model, "messages": messages, "stream": True}
        reply = []
        try:
            with post("/v1/chat/completions", payload, stream=True) as resp:
                for raw in resp:
                    line = raw.decode("utf-8", "replace").strip()
                    if not line.startswith("data: "):
                        continue
                    body = line[6:]
                    if body == "[DONE]":
                        break
                    try:
                        delta = json.loads(body)["choices"][0].get("delta", {})
                    except (json.JSONDecodeError, KeyError, IndexError):
                        continue
                    chunk = delta.get("content")
                    if chunk:
                        reply.append(chunk)
                        sys.stdout.write(chunk)
                        sys.stdout.flush()
        except KeyboardInterrupt:
            print("\n(interrupted)\n")
            messages.pop()
            continue
        except urllib.error.HTTPError as exc:
            print(f"\nHTTP {exc.code}: {exc.read().decode('utf-8', 'replace')[:300]}\n")
            messages.pop()
            continue
        print("\n")
        messages.append({"role": "assistant", "content": "".join(reply)})


if __name__ == "__main__":
    main()
