#!/usr/bin/env python3
"""Gera ~/.codex/kat-models.json — catálogo de modelos do codex com o KAT.

O codex avisa "Model metadata for `kat-coder-v2.5` not found" porque o slug
não está no catálogo embutido. `model_catalog_json` no profile substitui o
catálogo inteiro do processo, então este script baixa o models.json e o
prompt.md (BASE_INSTRUCTIONS) da tag da versão instalada do codex, anexa uma
entrada pro KAT com o mesmo formato do fallback interno (model_info.rs:
model_info_from_slug) — mesmo prompt base, mas context_window real do servidor
(KAT_CTX do .env) em vez dos 272k do fallback — e escreve o resultado.

Rode de novo depois de atualizar o codex (o catálogo é atrelado à versão).
"""
import json
import re
import subprocess
import urllib.request
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
OUT = Path.home() / ".codex" / "kat-models.json"
RAW = "https://raw.githubusercontent.com/openai/codex/rust-v{v}/codex-rs/models-manager/{f}"

ver = subprocess.run(["codex", "--version"], capture_output=True, text=True).stdout
ver = re.search(r"(\d+\.\d+\.\d+)", ver).group(1)

kat_ctx = 16384
for line in (REPO / ".env").read_text().splitlines():
    if line.startswith("KAT_CTX="):
        kat_ctx = int(line.split("=", 1)[1])

with urllib.request.urlopen(RAW.format(v=ver, f="models.json")) as r:
    catalog = json.load(r)
with urllib.request.urlopen(RAW.format(v=ver, f="prompt.md")) as r:
    base_instructions = r.read().decode()

catalog["models"] = [m for m in catalog["models"] if m["slug"] != "kat-coder-v2.5"]
catalog["models"].append({
    "slug": "kat-coder-v2.5",
    "display_name": "KAT-Coder-V2.5-Dev (local)",
    "description": "KAT-Coder-V2.5-Dev IQ4_XS via llama.cpp na RTX 3090",
    "supported_reasoning_levels": [],
    "shell_type": "unified_exec",
    "visibility": "none",
    "supported_in_api": True,
    "priority": 99,
    "model_messages": {"instructions_template": base_instructions},
    "supports_reasoning_summary_parameter": True,
    "default_reasoning_summary": "auto",
    "support_verbosity": False,
    "default_verbosity": None,
    "apply_patch_tool_type": None,
    "web_search_tool_type": "text",
    "truncation_policy": {"mode": "bytes", "limit": 10000},
    "context_window": kat_ctx,
    "max_context_window": kat_ctx,
    "effective_context_window_percent": 95,
    "experimental_supported_tools": [],
    "input_modalities": ["text"],
    "availability_nux": None,
    "upgrade": None,
})
OUT.write_text(json.dumps(catalog))
print(f"codex {ver} | KAT_CTX {kat_ctx} | {len(catalog['models'])} modelos -> {OUT}")
