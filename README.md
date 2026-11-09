# XiaoZhi Home Assistant Add-ons

用于在 Home Assistant OS 内部署小智服务，不需要在 Debian 宿主机部署。

## 安装顺序（实验性，尚未在 HAOS 上完整集成测试）

1. 安装 **XiaoZhi MySQL**，配置独立的 `root_password` 和 `database_password`，启动并等待数据库 ready。
2. 安装或启动 **XiaoZhi Redis**，设置密码。
3. 配置 **XiaoZhi Console**：
   - `database_host: bd45c431-xiaozhi-mysql`
   - `database_port: 3306`
   - `database_name: xiaozhi_esp32_server`
   - `database_user: xiaozhi`
   - `database_password` 与 XiaoZhi MySQL 的 database_password 相同
   - `redis_host: bd45c431-xiaozhi-redis`
   - `redis_password` 与 Redis 的 password 相同
4. **先确认 Console 能稳定运行且数据库迁移完成**，再设置 XiaoZhi Server。Console Web 入口预期映射至 HA 主机的 8002 端口；不要把容器内部 8003 端口直接当作主机端口。
5. XiaoZhi Server 的 `manager_secret` 必须与管理 API 的实际服务端密钥匹配。当前 Console 封装未提供此选项，**尚待核对上游密钥配置来源**，不要随意生成并假定可用。

### 重要事项

- 上游 Console 数据库迁移使用 MySQL SQL，HA MariaDB 会在 `CAST(... AS JSON)` 处报语法错误。请使用独立 MySQL 8 加载项；无需删除 HA 的 MariaDB。
- 数据库数据保存在 MySQL 加载项的 `/data/mysql`；**首次初始化后**，仅修改加载项密码不会自动修改数据库中的用户密码。
- MySQL、Redis 的主机端口无需对外开放。不要将任何密码、API Key 或服务密钥提交到 GitHub。
- 当前镜像使用上游 latest 标签，部署前应验证实际版本与初始化行为。
- Sherpa-ONNX 另有加载项。NVIDIA Nemotron 模型尚未集成和验证。

上游项目：https://github.com/xinnan-tech/xiaozhi-esp32-server
