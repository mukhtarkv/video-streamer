# Video Streamer

Implemented video streaming project described in [Bootstrapping Microservices](https://www.bootstrapping-microservices.com) using Elixir.

You need Docker and Docker Compose installed to run this.

Boot it up from the terminal using:

    docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
    docker compose up

Open web browser and type `http://localhost:5454/video`.

Open new browser tab and type `http://localhost:3000`. Sign in with default username `admin` and password `admin`.
You can view logs and metrics similar to the screenshots.
![Grafana Logs Screenshot](./demo/logs_screenshot.png)
![Grafana Metrics Screenshot](./demo/metrics_screenshot.png)

Clean up the project from the terminal using:

    docker compose down --rmi=all
    docker plugin disable loki

## Run in Production

To use AWS S3, you need to create S3 bucket and upload video under `priv/videos/` folder.
Moreover, you need to set up [Grafana Cloud](https://grafana.com/tutorials/) to view logs and metrics in Grafana Labs managed observability platform. You have to update credentials in `docker/alloy/endpoints.json`.

Boot it up from the terminal using:

    export AWS_ACCESS_KEY_ID=your_access_key_id AWS_SECRET_ACCESS_KEY=your_secret_access_key \
        AWS_REGION=your_aws_region S3_BUCKET=your_s3_bucket
    docker compose -f docker-compose-prod.yml up
