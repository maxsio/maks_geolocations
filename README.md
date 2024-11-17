# Rails Geolocation App

A Ruby on Rails application that uses IPStack for geolocation services, containerized with Docker.

## Environment Setup

1. Copy the environment template:

```
cp .env.template .env
```

2. Update your IPStack API key in .env:

```
IPSTACK_ACCESS_KEY=your_api_key_here
```

## Running with Docker

1. Build and start containers in detached mode:

```
docker compose up --build -d
```

2. Access the application Rswag documentation:
- http://localhost:3000/api-docs

## Stopping the Application

```
docker compose down
```

## Running the tests

```
docker compose exec web bin/bundle exec rspec
```

## Architecture

- Ruby 3.3.2
- Rails (latest)
- PostgreSQL
