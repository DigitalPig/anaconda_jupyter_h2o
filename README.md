## Dockerfile for jupyter and H2O container

This dockerfile aims to build an image containing both jupyter notebook and h2o.

### Building image

You can use:

```shell
docker build . -t anaconda_h2o
```

### Pull image from Docker Hub

```shell
docker pull digitalpig/anaconda_jupyter_h2o
```

### Use the image

```shell
docker run -d -p 8888:8888 -p 54321:54321 -v dir_to_share_data:/codes anaconda_jupyter_h2o
```

Enjoy!
