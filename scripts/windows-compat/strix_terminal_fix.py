"""Historical Strix 1.7 Windows Docker named-pipe compatibility workaround.

Use only after confirming the blank-output defect described in README.txt.
This changes transport behavior, not model safety or access controls.
"""
import socket
import sys

if sys.platform == "win32":
    from docker.transport.npipesocket import NpipeSocket

    if not getattr(NpipeSocket.shutdown, "_strix_halfclose_fix", False):
        _shutdown = NpipeSocket.shutdown

        def _keep_read_side(self, how):
            if how == socket.SHUT_WR:
                return None
            return _shutdown(self, how)

        _keep_read_side._strix_halfclose_fix = True
        NpipeSocket.shutdown = _keep_read_side
