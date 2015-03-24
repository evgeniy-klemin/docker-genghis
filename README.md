Dockerfile Genghis
==================

Usage
-----

```
htpasswd .htpasswd admin
docker build -q -t "myrepository/genghis" .
docker run --name genghis -d --link mongo:mongo -p 8888:80 myrepository/genghis
```


Feature
-------

* Basic authenticate with nginx
