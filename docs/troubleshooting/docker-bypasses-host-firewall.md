On app-01 installed Docker engine. Docker bypasses the host's INPUT rules. If you create a container it will be available despite the default INPUT policy.
If you want to make port unavailable you should run a container with the -p flag 127.0.0.1:HOSTPORT:CONTAINERPORT or change DOCKER-USER rules.
