FROM python:3.6-alpine

# 替换阿里云的源
RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories
RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories
RUN apk update --no-cache && apk upgrade --no-cache
# 设置时区
RUN apk --no-cache add tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone
    
COPY . /usr/local/wxwork-webhook/
WORKDIR /usr/local/wxwork-webhook/
RUN pip install -r /usr/local/wxwork-webhook/requirements.txt && \
    chmod a+rx app.py
EXPOSE 5233

CMD ["app.py"]
