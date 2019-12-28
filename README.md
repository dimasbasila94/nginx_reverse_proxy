# Setup Docker Nginx Reverse Proxy

1. git clone reporsitory ini
2. create docker network sendiri
```
   sudo docker network create nginx_proxy_network (nama network yang dibuat)
```
3. Pastikan isi Dockerfile sesuai setup yang diinginkan
4. Pastikan docker-compose.yml sesuai setup yang diinginkan
5. Perbarui atau buat sendiri ssl certificate
   a. dhparam.pem -> /etc/ssl/certs
   b. domain.crt -> /etc/ssl/private
   c. domain.key -> /etc/ssl/private
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
