#!/bin/sh
set -eu
cd /opt/xiaozhi-esp32-server
python - <<'PY'
import json, os, sys, yaml
with open('/data/options.json', encoding='utf-8') as f:
    options = json.load(f)
secret = options.get('manager_secret', '')
if not secret:
    sys.exit('ERROR: Configure manager_secret from XiaoZhi Console server.secret before starting.')
url = options.get('manager_url', '')
if not url.startswith(('http://','https://')):
    sys.exit('ERROR: manager_url must be an HTTP(S) URL.')
template = 'config_from_api.yaml'
if not os.path.isfile(template):
    sys.exit('ERROR: Upstream config_from_api.yaml missing. Check image version.')
with open(template, encoding='utf-8') as f:
    cfg = yaml.safe_load(f)
cfg['manager-api']['url'] = url
cfg['manager-api']['secret'] = secret
cfg['server']['vision_explain'] = options.get('vision_explain_url', '')
os.makedirs('data', exist_ok=True)
with open('data/.config.yaml', 'w', encoding='utf-8') as f:
    yaml.safe_dump(cfg, f, allow_unicode=True, sort_keys=False)
os.chmod('data/.config.yaml', 0o600)
PY
exec python app.py
