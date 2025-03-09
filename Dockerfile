FROM nginx:latest
RUN rm /etc/nginx/conf.d/default.conf
COPY src/nginx.conf /etc/nginx/conf.d/default.conf
COPY src/index.html /usr/share/nginx/html/index.html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]