# Statik hektar sitesi — container adı: c_hektar | Nginx Proxy Manager hedefi: http://c_hektar:3007
FROM nginx:1.25-alpine

RUN rm -f /etc/nginx/conf.d/default.conf

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Yayın: html, css, varlıklar (node / kaynak dışlandı, bkz. .dockerignore)
COPY . /usr/share/nginx/html
# nginx/ yalnızca imaj build için; public dizinde istenmez
RUN rm -rf /usr/share/nginx/html/nginx

EXPOSE 3007

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:3007/ > /dev/null || exit 1
