# Code Index
> Gerado em: 2026-08-31T06:23:40.772Z
> 43 arquivos · 130 símbolos · linguagens: python (130)

## Top símbolos (por importância)

- **`prompt`** (fn) — `bench/seat_ttft.py:44` · 155 refs
  `def prompt(salt)`
- **`run`** (fn) — `bench/demo_capture.py:54` · 154 refs
  `def run(key, label, content, max_tokens=None)`
- **`MTP`** (class) — `drafter/train_mtp.py:87` · 152 refs
  `class MTP(nn.Module)`
- **`bench`** (fn) — `bench/spec_attn_ctx_scan.py:51` · 133 refs
  `def bench(fn, iters=30)`
- **`bench`** (fn) — `bench/test_spec_decode_attn.py:52` · 133 refs
  `def bench(fn, iters=200)`
- **`bench`** (fn) — `bench/tune_gdn.py:11` · 133 refs
  `def bench(N, BV, num_warps)`
- **`prepare`** (fn) — `bench/demo_render.py:79` · 117 refs
  `def prepare(p)`
- **`make`** (fn) — `bench/spec_attn_ctx_scan.py:39` · 73 refs
  `def make(kv_len, q_len)`
- **`make`** (fn) — `bench/test_spec_decode_attn.py:17` · 73 refs
  `def make(kv_lens, q_len, num_blocks=None)`
- **`chat`** (fn) — `bench/api_smoke.py:30` · 68 refs
  `def chat(msg, **kw)`
- **`log`** (fn) — `drafter/train_mtp.py:63` · 65 refs
  `def log(*a)`
- **`flag`** (fn) — `bench/labd_accept.py:101` · 45 refs
  `def flag(name)`
- **`main`** (fn) — `drafter/capture.py:29` · 38 refs
  `def main()`
- **`main`** (fn) — `drafter/capture_dflash2.py:59` · 38 refs
  `def main()`
- **`main`** (fn) — `drafter/gen_data.py:21` · 38 refs
  `def main()`
- **`stream`** (fn) — `bench/conc_ladder.py:124` · 38 refs
  `def stream(i, salt, res, first_tok)`
- **`main`** (fn) — `bench/demo_render.py:317` · 38 refs
  `def main()`
- **`main`** (fn) — `bench/test_lookup_kernels.py:48` · 38 refs
  `def main()`
- **`dequant`** (fn) — `drafter/gptq_utils.py:87` · 33 refs
  `def dequant(q, scale, group=128)`
- **`sampler`** (fn) — `bench/conc_ladder.py:159` · 32 refs
  `def sampler(stop, peak)`
- **`pack`** (fn) — `drafter/train_mtp.py:266` · 29 refs
  `def pack(seq_list, budget)`
- **`ref`** (fn) — `bench/test_spec_decode_attn.py:34` · 29 refs
  `def ref(q, kc, vc, bt, kv_lens, q_len)`
- **`add`** (fn) — `drafter/collect_prompts.py:31` · 25 refs
  `def add(src, msgs)`
- **`check`** (fn) — `bench/api_smoke.py:38` · 25 refs
  `def check(name, fn)`
- **`KVarNConfig`** (class) — `kvarn/files/vllm/model_executor/layers/quantization/kvarn/config.py:30` · 23 refs
  `class KVarNConfig`
- **`median`** (fn) — `bench/verbatim.py:95` · 21 refs
  `def median(xs)`
- **`repeats`** (fn) — `bench/verbatim.py:57` · 16 refs
  `def repeats(ans)`
- **`ttft`** (fn) — `bench/seat_ttft.py:49` · 13 refs
  `def ttft(salt)`
- **`save`** (fn) — `drafter/train_mtp.py:441` · 10 refs
  `def save()`
- **`coverage`** (fn) — `bench/verbatim.py:40` · 10 refs
  `def coverage(ans, doc)`
- **`accumulate_hessian`** (fn) — `drafter/gptq_utils.py:9` · 8 refs
  `def accumulate_hessian(H, X, n_seen)`
- **`gptq_quantize`** (fn) — `drafter/gptq_utils.py:21` · 8 refs
  `def gptq_quantize(W, H, bits=4, group=128, blocksize=128, percdamp=0.01, ms...)`
- **`metrics`** (fn) — `bench/bugb_sweep.py:42` · 7 refs
  `def metrics()`
- **`metrics`** (fn) — `bench/conc_ladder.py:114` · 7 refs
  `def metrics()`
- **`header`** (fn) — `bench/demo_render.py:218` · 7 refs
  `def header(d, idx, n_prompts, pa)`
- **`metrics`** (fn) — `bench/labd_accept.py:127` · 7 refs
  `def metrics()`
- **`metrics`** (fn) — `bench/labd_bench.py:42` · 7 refs
  `def metrics()`
- **`metrics`** (fn) — `bench/labd_soak.py:70` · 7 refs
  `def metrics()`
- **`metrics`** (fn) — `bench/residue_sweep.py:46` · 7 refs
  `def metrics()`
- **`classify`** (fn) — `bench/verbatim.py:74` · 7 refs
  `def classify(ans, doc, ref=None, min_len=40, floor=0.5, rel=0.6, max_l...)`

## Arquivos mais densos

### `bench/api_smoke.py` _(16 símbolos)_
- `def chat(msg, **kw)` — L30
- `def check(name, fn)` — L38
- `def post(url, payload, stream=False)` — L21
- `def _key(path)` — L10
- `def t_greedy_det()` — L46
- `def t_seed()` — L50
- `def t_logprobs()` — L54
- `def t_n2()` — L58
- _... mais 8_

### `bench/demo_render.py` _(15 símbolos)_
- `def prepare(p)` — L79
- `def main()` — L317
- `def header(d, idx, n_prompts, pa)` — L218
- `def visible(p, t_ms)` — L98
- `def font(path, sz, index=0)` — L46
- `def rate_at(p, i, t_ms, window=800.0)` — L112
- `def wrap(text, cols)` — L129
- `def rrect(d, box, r, **kw)` — L142
- _... mais 7_

### `drafter/train_mtp.py` _(11 símbolos)_
- `class MTP(nn.Module)` — L87
- `def log(*a)` — L63
- `def pack(seq_list, budget)` — L266
- `def save()` — L441
- `def _causal_attn_lse(q, k, v, scale)` — L80
- `def load_seq(s)` — L246
- `def make_batch(seq_list)` — L253
- `def head_loss(z, h_tgt, train, weight, x_true=None)` — L281
- _... mais 3_

### `kvarn/files/vllm/v1/attention/backends/kvarn_attn.py` _(11 símbolos)_
- `class KVarNAttentionBackend(AttentionBackend)` — L184
- `class KVarNMetadataBuilder(AttentionMetadataBuilder[KVarNMetadata])` — L399
- `class KVarNAttentionImpl(AttentionImpl["KVarNMetadata"])` — L1056
- `class KVarNMetadata(AttentionMetadata)` — L353
- `def _hadamard_cached(d: int, device_str: str) -> torch.Tensor` — L89
- `def _build_hadamard(d: int, device: torch.device) -> torch.Tensor` — L97
- `def _sinkhorn_pack_kv(K_tiles, V_tiles, cfg)` — L101
- `def _active_kvarn_cache_dtype() -> str | None` — L130
- _... mais 3_

### `bench/conc_ladder.py` _(8 símbolos)_
- `def stream(i, salt, res, first_tok)` — L124
- `def sampler(stop, peak)` — L159
- `def metrics()` — L114
- `def _key(path)` — L57
- `def _arg(flag, default, cast=int)` — L64
- `def make_prompt(i, salt)` — L90
- `def _short(name)` — L110
- `def run_one(n, salt)` — L172

### `bench/quality_battery.py` _(8 símbolos)_
- `def post(path, payload, timeout=1200)` — L34
- `def _key(path)` — L21
- `def docs()` — L39
- `def ppl_one(item)` — L59
- `def run_ppl()` — L72
- `def extract_num(s)` — L83
- `def gsm_one(row)` — L87
- `def run_gsm()` — L99

### `bench/labd_accept.py` _(7 símbolos)_
- `def flag(name)` — L101
- `def metrics()` — L127
- `def post(path, payload, stream=False, timeout=1800)` — L119
- `def arg(name, default)` — L97
- `def generate(prompt_ids, max_tokens)` — L166
- `def tokenize_chat(content)` — L148
- `def ids_from_logprobs(tokens)` — L156

### `bench/verbatim.py` _(7 símbolos)_
- `def median(xs)` — L95
- `def repeats(ans)` — L57
- `def coverage(ans, doc)` — L40
- `def classify(ans, doc, ref=None, min_len=40, floor=0.5, rel=0.6, max_l...)` — L74
- `def prefix_match(ans, doc)` — L49
- `def invented_repeats(ans, doc)` — L63
- `def _selftest()` — L100

### `drafter/gptq_utils.py` _(4 símbolos)_
- `def dequant(q, scale, group=128)` — L87
- `def accumulate_hessian(H, X, n_seen)` — L9
- `def gptq_quantize(W, H, bits=4, group=128, blocksize=128, percdamp=0.01, ms...)` — L21
- `def rtn_quantize(W, bits=4, group=128)` — L77

### `bench/seat_ttft.py` _(3 símbolos)_
- `def prompt(salt)` — L44
- `def ttft(salt)` — L49
- `def _key()` — L25

### `bench/spec_attn_ctx_scan.py` _(3 símbolos)_
- `def bench(fn, iters=30)` — L51
- `def make(kv_len, q_len)` — L39
- `def tua_call(q, kc, vc, out, cu, seqused, bt, q_len, kv_len, segm=None)` — L65

### `bench/test_spec_decode_attn.py` _(3 símbolos)_
- `def bench(fn, iters=200)` — L52
- `def make(kv_lens, q_len, num_blocks=None)` — L17
- `def ref(q, kc, vc, bt, kv_lens, q_len)` — L34

### `drafter/capture_dflash2.py` _(3 símbolos)_
- `def main()` — L59
- `def find_draft_model(root)` — L37
- `def reduce_wide()` — L166

### `bench/test_lookup_kernels.py` _(3 símbolos)_
- `def main()` — L48
- `def ref_lookup(seq, k, nmin, nmax)` — L16
- `def run_case(seq, k, nmin, nmax, device="cuda")` — L34

### `drafter/collect_prompts.py` _(3 símbolos)_
- `def add(src, msgs)` — L31
- `def dl(repo, patterns)` — L13
- `def parquet_rows(root, cols=None)` — L18
