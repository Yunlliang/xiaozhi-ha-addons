# XiaoZhi Redis

Experimental HAOS Redis add-on. Requires setting a strong unique password. Persists append-only files under `/data/redis`. No host port exposed by default. The HAOS add-on hostname follows the repository prefix and slug; retrieve the actual hostname after installation. No Redis instance is currently installed on the target HAOS.

Redis image: `redis:7.4-alpine`. **Build and startup not yet validated**. Do not expose Redis port 6379 publicly.
