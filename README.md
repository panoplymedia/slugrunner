# Panoply Slugrunner

The Slugrunner is a Docker container that will run [Heroku](https://www.heroku.com/)-like [slugs](https://devcenter.heroku.com/articles/platform-api-deploying-slugs). A slug is essentially a gzipped tarball of an application that is self-contained and includes everything it needs to run. These slugs can be built from [panoplymedia/slugbuilder](https://github.com/panoplymedia/slugbuilder), [lxfontes/slugbuilder](https://github.com/lxfontes/slugbuilder), [deis/slugbuilder](https://github.com/deis/slugbuilder) and the like.

## Requirements

You will need to have [Docker](https://www.docker.com/) installed and set up on your system.

## Installation

```sh
docker pull panoplymedia/slugrunner
```

## Usage

You will use `docker run` to run your slug in this container, passing a string argument at the end, which will be run.

```sh
# ellipses notate additional args
docker run ... panoplymedia/slugrunner npm start

docker run ... panoplymedia/slugrunner bundle exec rails s
```

 Alternatively, if your slug contains a [`Procfile`](https://devcenter.heroku.com/articles/procfile) you can use the start command followed by the name of the process.

```
# Procfile
web: npm start
worker: node worker.js
```

```sh
# ellipses notate additional args
docker run ... panoplymedia/slugrunner start web
```

There are various ways you can pass the slug in to be run:

### STDIN

```sh
cat myslug.tgz | docker run -i -a stdin -a stdout panoplymedia/slugrunner start worker
```

### SLUG_URL Environment Variable

By specifying the `SLUG_URL` as an environment variable, it will use the slug located at that URL.

```sh
docker run -e SLUG_URL=http://example.org/myslug.tgz panoplymedia/slugrunner bundle exec rails s
```

### Amazon S3

You can also use a slug from Amazon S3 with the following environment variables:
- `SLUG_KEY`: `s3-bucket-name/path/to/slug.tgz`
- `SLUG_AWS_KEY`: your AWS access key
- `SLUG_AWS_SECRET`: your AWS secret access key

```sh
docker run -e SLUG_KEY=my-bucket/items/stuff/someslug.tgz -e SLUG_AWS_KEY=XXX -e SLUG_AWS_SECRET=XXX panoplymedia/slugrunner start web
```

### Google Cloud Storage

You may use Google Cloud with a developer access key and secret key. Alternatively you may use service account credentials.

To use a slug from Google Cloud Storage with a developer access key and secret key, follow Google's [documentation](https://cloud.google.com/storage/docs/migrating?hl=en_US#keys) and then provide the following environment variables:
- `SLUG_KEY`: `cloud-storage-bucket-name/path/to/slug.tgz`
- `SLUG_GOOGLE_KEY`: your Cloud Storage access key
- `SLUG_GOOGLE_SECRET`: your Cloud Storage secret access key

```sh
docker run -e SLUG_KEY=my-bucket/items/stuff/someslug.tgz -e SLUG_GOOGLE_KEY=XXX -e SLUG_GOOGLE_SECRET=XXX panoplymedia/slugrunner start web
```

To use a slug from Google Cloud Storage with service account credentials, follow Google's [documentation](https://cloud.google.com/storage/docs/authentication#generating-a-private-key) to generate a service account credential and convert it into a Base64 string. Then provide the following environment variables:
- `SLUG_KEY`: `cloud-storage-bucket-name/path/to/slug.tgz`
- `SLUG_GOOGLE_ACCOUNT_KEY_B64`: your Base64 encoded Google service account credentials

## Debugging

Set environment variable `DEBUG=true` to get debug output from the script.

## Motivation and Thanks

This library is heavily based on [deis/slugrunner](https://github.com/deis/slugrunner), and most notably adds the option to run a slug off of [Amazon S3](https://aws.amazon.com/s3/) and [Google Cloud Storage](https://cloud.google.com/storage/).
