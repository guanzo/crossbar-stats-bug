## Reproduction steps

* git clone https://github.com/guanzo/crossbar-stats-bug
* `$ cd crossbar-stats-bug`
* Run `./start-crossbar.sh` in one terminal.
* Run `./start-web.sh` in another terminal.
* `start-web.sh` will print the http server url. Open the url in the browser, then
open `backend.html` and `frontend.html` in new tabs.
* View the browser console and see connection errors.
* View the crossbar output and see the recursion error.

## Example configs

Infinite recursion with this config

```json
"stats": {
    "rated_message_size": 512,
    "trigger_after_rated_messages": 0,
    "trigger_after_duration": 60,
    "trigger_on_join": false,
    "trigger_on_leave": false
}
```

And this too

```json
"stats": {
    "rated_message_size": 512,
    "trigger_after_rated_messages": 5,
    "trigger_after_duration": 10,
    "trigger_on_join": false,
    "trigger_on_leave": false
}
```

```
2020-08-20T06:20:53+0000 [Router         10] Unhandled error in Deferred:
2020-08-20T06:20:53+0000 [Router         10]
Traceback (most recent call last):
  File "/usr/local/site-packages/crossbar/router/router.py", line 319, in process
    self._broker.processPublish(session, msg)
  File "/usr/local/site-packages/crossbar/router/broker.py", line 749, in processPublish
    txaio.add_callbacks(d, on_authorize_success, on_authorize_error)
  File "/usr/local/site-packages/txaio/tx.py", line 443, in add_callbacks
    future.addCallbacks(callback, errback)
  File "/usr/local/site-packages/twisted/internet/defer.py", line 311, in addCallbacks
    self._runCallbacks()
--- <exception caught here> ---
  File "/usr/local/site-packages/twisted/internet/defer.py", line 654, in _runCallbacks
    current.result = callback(current.result, *args, **kw)
  File "/usr/local/site-packages/crossbar/router/broker.py", line 715, in on_authorize_success
    recv for recv in receivers
  File "/usr/local/site-packages/crossbar/router/broker.py", line 668, in _notify_some
    self._router.send(receiver, msg)
  File "/usr/local/site-packages/crossbar/router/router.py", line 295, in send
    session._transport.send(msg)
  File "/usr/local/site-packages/autobahn/wamp/websocket.py", line 121, in send
    self.log.error("WAMP message serialization error: {}".format(e))
  File "/usr/local/lib_pypy/_functools.py", line 80, in __call__
    return self._func(*(self._args + fargs), **fkeywords)
  File "/usr/local/site-packages/txaio/tx.py", line 132, in _log
    self._logger.emit(level, *args, **kwargs)
  File "/usr/local/site-packages/twisted/logger/_logger.py", line 144, in emit
    self.observer(event)
  File "/usr/local/site-packages/twisted/logger/_observer.py", line 136, in __call__
    errorLogger = self._errorLoggerForObserver(brokenObserver)
  File "/usr/local/site-packages/twisted/logger/_observer.py", line 155, in _errorLoggerForObserver
    obs for obs in self._observers
  File "/usr/local/site-packages/twisted/logger/_observer.py", line 81, in __init__
    self.log = Logger(observer=self)
  File "/usr/local/site-packages/twisted/logger/_logger.py", line 64, in __init__
    namespace = self._namespaceFromCallingContext()
  File "/usr/local/site-packages/twisted/logger/_logger.py", line 42, in _namespaceFromCallingContext
    return currentframe(2).f_globals["__name__"]
  File "/usr/local/site-packages/twisted/python/compat.py", line 93, in currentframe
    f = inspect.currentframe()
builtins.RecursionError: maximum recursion depth exceeded
```

No errors with this config:
```json
"stats": {
    "rated_message_size": 512,
    "trigger_after_rated_messages": 5,
    "trigger_after_duration": 0,
    "trigger_on_join": false,
    "trigger_on_leave": false
}
```
