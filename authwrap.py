import base64
import os

from searx.webapp import app as _searxng_app

_PASSWORD = os.environ.get("AUTH_PASSWORD", "")
_CREDENTIAL = "Basic " + base64.b64encode(("raj:" + _PASSWORD).encode()).decode()


class _BasicAuthMiddleware:
    def __init__(self, inner):
        self.inner = inner

    def __call__(self, environ, start_response):
        if environ.get("PATH_INFO", "").rstrip("/") == "/healthz":
            return self.inner(environ, start_response)
        if _PASSWORD and environ.get("HTTP_AUTHORIZATION", "") != _CREDENTIAL:
            start_response(
                "401 Unauthorized",
                [
                    ("WWW-Authenticate", 'Basic realm="searxng"'),
                    ("Content-Type", "text/plain"),
                    ("Content-Length", "29"),
                ],
            )
            return [b"401 authentication required\n"]
        return self.inner(environ, start_response)


app = _BasicAuthMiddleware(_searxng_app)
