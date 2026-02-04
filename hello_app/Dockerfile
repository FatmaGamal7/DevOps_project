FROM nginx:alpine

RUN rm /usr/share/nginx/html/*

COPY index.html /usr/share/nginx/html/index.html
COPY style.css /usr/share/nginx/html/style.css

EXPOSE 8081

CMD ["nginx", "-g", "daemon off;"]
