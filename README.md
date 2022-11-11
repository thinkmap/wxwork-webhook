# wxwork-webhook
alertmanager webhook for wechat
```
old：
certifi==2019.6.16
chardet==3.0.4
Click==7.0
Flask>=1.0.3
idna==2.8
itsdangerous==1.1.0
Jinja2==2.10.1
MarkupSafe==1.1.1
requests==2.22.0
urllib3==1.25.3
Werkzeug>=0.15.4
```
# build image
```bash
docker build -t IMAGE_NAME:TAG .
```

# quick start

## run wxwork-webhook in docker

```bash
docker run -d \
           --restart=on-failure:5 \
           -p 5233:5233 \
           -w /usr/local/wxwork-webhook/
           IMAGE_NAME:TAG \
           python \
           app.py \
           --wxwork-webhook https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxxxxx \
           --listen 0.0.0.0 \
           --port 5233
```

## config alertmanager configuration yaml

> add receivers and route receiver

```yaml
global:
  ...
receivers:
- name: "null"
- name: "wxwork-webhook"
  webhook_configs:
    - send_resolved: true
      url: "http://<YOUR wxwork-webhook IP address>:5233/webhook"
route:
  ...
  receiver: "wxwork-webhook"
  ...
```

# alertmanager webhook json payload

```json
{
  "receiver":"wxwork",
  "status":"firing",
  "alerts":[
    {
      "status":"firing",
      "labels":{
        "alertname":"KubeletDown",
        "prometheus":"monitoring/k8s",
        "severity":"critical"
      },
      "annotations":{
        "message":"Kubelet has disappeared from Prometheus target discovery.",
        "runbook_url":"https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletdown"
      },
      "startsAt":"2019-08-12T04:12:17.64901609Z",
      "endsAt":"0001-01-01T00:00:00Z",
      "generatorURL":"http://prometheus-k8s-0:9090/graph?g0.expr=absent%28up%7Bjob%3D%22kubelet%22%7D+%3D%3D+1%29&g0.tab=1"
    }
  ],
  "groupLabels":{
    "alertname":"KubeletDown"
  },
  "commonLabels":{
    "alertname":"KubeletDown",
    "prometheus":"monitoring/k8s",
    "severity":"critical"
  },
  "commonAnnotations":{
    "message":"Kubelet has disappeared from Prometheus target discovery.",
    "runbook_url":"https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletdown"
  },
  "externalURL":"http://alertmanager-main-0:9093",
  "version":"4",
  "groupKey":"{}:{alertname='KubeletDown'}"
}
```

# webhook post json payload
```markdown
# Alertmanager告警提示
告警内容： **KubeletDown**
[来源URL](http://alertmanager-main-0:9093)


**Labels**

> alertname = KubeletDown
> prometheus = monitoring/k8s
> severity = critical

**Annotations**
> message = msg.annotations_message
```

# screen

![](./demo.png)
