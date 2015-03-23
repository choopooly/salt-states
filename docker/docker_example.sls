{% set registry = 'private-repository.com' %}
{% set image = 'nginx' %}
{% set tag = 'latest' %}

{{ image }}_image:
  docker:
    - pulled
    - name: {{ registry }}/{{ image }}:{{ tag }}
    - force: True

{{ image }}_stop_if_old:
  cmd:
    - wait
    - name: docker stop {{ image }}
    - unless: docker inspect --format '\{\{ .Image \}\}' {{ image }} | grep $(docker images | grep "{{ registry }}/{{ image }}:{{ tag }}' %}" | awk '{ print $3 }')
    - watch:
      - docker: {{ image }}_image

{{ image }}_remove_if_old:
  cmd:
    - wait
    - name: docker rm {{ image }}
    - unless: docker inspect --format '\{\{ .Image \}\}' {{ image }} | grep $(docker images | grep "{{ registry }}/{{ image }}:{{ tag }}' %}" | awk '{ print $3 }')
    - watch:
      - cmd: {{ image }}_stop_if_old

{{ image }}_container:
  docker:
    - installed
    - name: {{ image }}
    - image: {{ registry }}/{{ image }}:{{ tag }}
    - ports:
      - "80/tcp"
    - require:
      - docker: {{ image }}_image

{{ image }}_running:
  docker:
    - running
    - container: {{ image }}
    - port_bindings:
        "80/tcp":
            HostIp: "0.0.0.0"
            HostPort: "80"
    - require:
      - docker: {{ image }}_container

