FROM nginx:stable-alpine
#COPY default.conf /etc/nginx/conf.d
#EXPOSE 80/tcp
#EXPOSE 443/tcp
CMD ["/bin/sh", "-c", "exec nginx -g 'daemon off;';"]
RUN apk add nano
RUN apk add openssl
WORKDIR /usr/share/nginx/html
