## Impact
App service was unavailable. Didn't can get status of the service.

## Symptoms
For curl requests on localhost:8000/health was given an response "Connection refuse" immideatly.
Container app in docker compose was in status "Restarting(1)" and exit code 1 but db worked properly.

## Investigation
1. Try to get /health 

dvps@app-01:~/dvps$ curl localhost:8000/health
curl: (7) Failed to connect to localhost port 8000 after 0 ms: Connection refused

2. Chech status of docker compose contrainers.

dvps@app-01:~/dvps$ docker compose ps
NAME         IMAGE         COMMAND                  SERVICE   CREATED              STATUS                          PORTS
dvps-app-1   dvps-app      "uvicorn main:applic…"   app       About a minute ago   Restarting (1) 23 seconds ago
dvps-db-1    postgres:16   "docker-entrypoint.s…"   db        7 minutes ago        Up 7 minutes                    5432/tcp

3. Check logs of app container. Found an error.

dvps@app-01:~/dvps$ docker compose logs app
app-1  | ERROR:    Error loading ASGI app. Attribute "application" not found in module "main".

4. Try to find the attribute "application" in main.py script.

dvps@app-01:~/dvps/app$ grep -i 'application' main.py
dvps@app-01:~/dvps/app$

5. Check full docker compose config. Run "docker compose config".
Was found wrong string with attribute main:application

## Root Cause
In home directory of the project was created file docker-compose.override.yml.
This file contined the following data:
services:
  app:
    restart: always
    command: ["uvicorn", "main:application", "--host", "0.0.0.0", "--port", "8000"]

Attribute main:application was diffirent from docker=compose.yml. In the result the application couldn't start correctly.
In addition parameter "restart: always" also hindered in diagnostic of the problem.


## Resolution
The file docker-compose.override.yml was renamed to docker-compose.override.yml.bak and deleted later.
Docker compose containers were restarted.

## Prevention

1. Add monitoring that periodically checks availability and status of /health raises an alert when it fails.
2. Configuration of the host must be described as code.
3. All changes must go through the repository and be applied automatically, rather than manually over SSH.
