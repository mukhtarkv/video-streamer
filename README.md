# Video Streamer

Implemented video streaming project described in [Bootstrapping Microservices](https://www.bootstrapping-microservices.com) using Elixir.

You need Docker and Docker Compose installed to run this.

Boot it up from the terminal using:

    docker compose up

Open web browser and type `http://localhost:5454/video`.

Clean up the project from the terminal using:

    docker compose down --rmi=all

## Enable AWS S3

To use AWS S3, you need to create S3 bucket `video-streamer-videos` and upload video under `priv/videos/` folder.

Boot it up from the terminal using:

    export AWS_ACCESS_KEY_ID=your_access_key_id AWS_SECRET_ACCESS_KEY=your_secret_access_key \
        AWS_REGION=your_aws_region
    docker compose -f docker-compose-prod.yml up
