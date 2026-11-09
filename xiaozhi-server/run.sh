#!/bin/sh
set -eu
cd /opt/xiaozhi-esp32-server
python - <<'PY'
import json, os, shutil, sys, yaml
with open('/data/options.json', encoding='utf-8') as f:
    options = json.load(f)
secret = options.get('manager_secret', '')
if not secret:
    sys.exit('ERROR: Configure manager_secret from XiaoZhi Console server.secret before starting.')
url = options.get('manager_url', '')
if not url.startswith(('http://', 'https://')):
    sys.exit('ERROR: manager_url must be an HTTP(S) URL.')
template = 'config_from_api.yaml'
if not os.path.isfile(template):
    sys.exit('ERROR: Upstream config_from_api.yaml missing. Check image version.')
with open(template, encoding='utf-8') as f:
    cfg = yaml.safe_load(f)
cfg['manager-api']['url'] = url
cfg['manager-api']['secret'] = secret
cfg['server']['vision_explain'] = options.get('vision_explain_url', '')
persist = '/data/xiaozhi-server'
os.makedirs(persist, exist_ok=True)
if os.path.islink('data'):
    if os.path.realpath('data') != os.path.realpath(persist):
        sys.exit('ERROR: Existing data symlink points elsewhere.')
elif os.path.isdir('data'):
    for item in os.listdir('data'):
        src, dst = os.path.join('data', item), os.path.join(persist, item)
        if not os.path.exists(dst):
            if os.path.isdir(src):
                shutil.copytree(src, dst)
            else:
                shutil.copy2(src, dst)
    shutil.rmtree('data')
    os.symlink(persist, 'data')
elif os.path.lexists('data'):
    sys.exit('ERROR: data exists and is not a directory.')
else:
    os.symlink(persist, 'data')
with open(os.path.join(persist, '.config.yaml'), 'w', encoding='utf-8') as f:
    yaml.safe_dump(cfg, f, allow_unicode=True, sort_keys=False)
os.chmod(os.path.join(persist, '.config.yaml'), 0o600)
PY
exec python app.py
