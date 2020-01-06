# Setup Docker Nginx Reverse Proxy

## Struktur Folder

```
.
├── conf.d
│   └── default.conf
├── default-ssl.conf
├── docker-compose.yml
├── Dockerfile
├── README.md
└── ssl
    ├── certs
    │   └── dhparam.pem
    └── private
        ├── domain.crt
        └── domain.key
```

1. git clone reporsitory ini
2. create docker network sendiri
```
   sudo docker network create nginx_proxy_network (nama network yang dibuat)
```
3. Pastikan isi Dockerfile sesuai setup yang diinginkan
4. Pastikan docker-compose.yml sesuai setup yang diinginkan
5. Perbarui atau buat sendiri ssl certificate
```
   a. dhparam.pem -> /etc/ssl/certs
   b. domain.crt -> /etc/ssl/private
   c. domain.key -> /etc/ssl/private
```
6. Jalankan docker compose
```
   sudo docker docker-compose up -d
```
7. Jika docker sudah berjalan, copy file default-ssl.conf yang sudah di setting ssl port 443 ke path /conf.d dan remove default.conf
8. Rename default-ssl.conf menjadi default.conf
```
   mv default-ssl.conf default.conf
```
9. Jalankan perintah
```
   sudo docker exec nginx_proxy nginx -t
   sudo docker exec nginx_proxy nginx -s reload
```

### Setting file.conf untuk reverse proxy ke container docker
contoh settingan di default.conf
note: container yang dikoneksikan ke nginx ini harus satu network, jika container tidak satu network bisa setting pada docker-compose.yml atau command docker seperti dibawah ini:
#### docker-compose
```
networks:
  default:
    external:
      name: nginx_proxy_network(nama network nginx reverse proxy)
```
#### command docker
```
docker network connect nginx_proxy_network(nama network nginx reverse proxy) backend(nama container);
```
berikut contoh  file.conf

```
upstream dev(nama subdomain) {
  server        frontend(nama container):80(port docker);
}

server {
    listen       443 ssl;
    server_name   dev(nama subdomain).spentera.id;
    
    include       dev_common.conf;
    include       /etc/nginx/dev_ssl.conf;
 
    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        proxy_pass http://frontend(nama container); 
        include     dev_common_location.conf;
    }
    
    #location /api { jika ini diaktifkan url untuk memanggilnya https://dev.spentera.id/api
     #   proxy_pass http://backend:5000/ (nama container lain);
    #}
	
    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

   
}
```
###note
```
check ip docker
docker inspect <container id> | grep "IPAddress"

create ssl with openssl
openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=mydomain.com" -addext "subjectAltName=DNS:mydomain.com" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt;

import mysql command
mysql -u username -p new_database < data-dump.sql

a2ensite di docker
sudo docker exec nama_container a2ensite file.conf
```
