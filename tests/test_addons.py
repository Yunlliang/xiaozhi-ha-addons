"""Static safety checks for the XiaoZhi HAOS add-on packaging."""
import pathlib
import unittest
import yaml

ROOT = pathlib.Path(__file__).resolve().parents[1]
ADDONS = ("redis", "xiaozhi-server", "xiaozhi-console", "sherpa-onnx")

class TestAddons(unittest.TestCase):
    def test_manifests(self):
        slugs = set()
        for name in ADDONS:
            with self.subTest(addon=name):
                config = yaml.safe_load((ROOT / name / "config.yaml").read_text())
                for key in ("name", "version", "slug", "arch", "startup", "options", "schema"):
                    self.assertIn(key, config)
                self.assertNotIn(config["slug"], slugs)
                slugs.add(config["slug"])
                self.assertTrue((ROOT / name / "Dockerfile").exists() or "image" in config)
                self.assertEqual(set(config["options"]) - set(config["schema"]), set())

    def test_unique_host_ports(self):
        occupied = {}
        for name in ADDONS:
            config = yaml.safe_load((ROOT / name / "config.yaml").read_text())
            for container_port, host_port in config.get("ports", {}).items():
                if host_port is None:
                    continue
                self.assertNotIn(host_port, occupied, f"{name} conflicts with {occupied.get(host_port)}")
                occupied[host_port] = name

    def test_server_uses_full_upstream_image(self):
        dockerfile = (ROOT / "xiaozhi-server/Dockerfile").read_text()
        self.assertIn("ghcr.io/xinnan-tech/xiaozhi-esp32-server:server_latest", dockerfile)

    def test_console_uses_full_upstream_image(self):
        dockerfile = (ROOT / "xiaozhi-console/Dockerfile").read_text()
        self.assertIn("ghcr.io/xinnan-tech/xiaozhi-esp32-server:web_latest", dockerfile)

    def test_redis_does_not_put_password_in_process_args(self):
        script = (ROOT / "redis/run.sh").read_text()
        self.assertNotIn("--requirepass", script)
        self.assertIn("chmod 600", script)

    def test_console_does_not_put_password_in_process_args(self):
        script = (ROOT / "xiaozhi-console/run.sh").read_text()
        self.assertNotIn("exec /start.sh", script)
        self.assertNotIn("--spring.datasource.druid.password", script)

if __name__ == "__main__":
    unittest.main()
