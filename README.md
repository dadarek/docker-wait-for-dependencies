##Example usage:

Sample `docker-compose.yml`:

```yaml
version: '2'
services:
  the_database:
    image: ubuntu:14.04
    command: >
      /bin/bash -c "
        sleep 5;
        nc -lk 0.0.0.0 5432;
      "
  another_service:
    image: ubuntu:14.04
    command: >
      /bin/bash -c "
        sleep 8;
        nc -lk 0.0.0.0 5555;
      "

  the_web_server:
    image: ubuntu:14.04
    depends_on:
      - the_database
      - another_service
    command: >
      /bin/bash -c "
        nc -z the_database 5432 &&
        echo Connected to DB and started!
      "

  start_dependencies:
    image: dadarek/wait-for-dependencies
    depends_on:
      - the_database
      - another_service
    command: the_database:5432 another_service:5555
```

Then, to guarantee that `the_database` and `another_service` are ready before running `the_web_server`:

```bash
$ docker-compose run --rm start_dependencies
# Some output from docker compose
$ docker-compose up the_web_server
```

By default, there will be a 2 second sleep time between each check. You can modify this by setting the `SLEEP_LENGTH` environment variable:

```yaml
  start_dependencies:
    image: dadarek/wait-for-dependencies
    environment:
      - SLEEP_LENGTH: 0.5
```

By default, there will be a 300 seconds timeout before cancelling the wait_for. You can modify this by setting the `TIMEOUT_LENGTH` environment variable:

```yaml
  start_dependencies:
    image: dadarek/wait-for-dependencies
    environment:
      - SLEEP_LENGTH: 1
      - TIMEOUT_LENGTH: 60
```
