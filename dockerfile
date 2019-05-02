FROM nginx

copy nginx.conf /etc/nginx/

RUN service nginx restart

EXPOSE 80
