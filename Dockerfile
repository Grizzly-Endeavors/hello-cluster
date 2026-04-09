# Replace this file with your app's Dockerfile.
#
# The included deploy.yaml workflow expects a Dockerfile at the repo root
# that produces a runnable container image. The default deploy/values.yaml
# points at the public `nginx:1.25-alpine` image so new repos work out of
# the box without a Dockerfile — but as soon as you push to main, this
# Dockerfile is built and its image replaces the default.
#
# Minimal example (echoes "hello from <repo>" and serves on :8080):

FROM nginx:1.25-alpine
RUN echo "hello from grizzly-endeavors app-deploy-template" > /usr/share/nginx/html/index.html
EXPOSE 80
