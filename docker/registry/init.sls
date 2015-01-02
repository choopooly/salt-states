{#-
Copyright (c) 2014, Nicolas Plessis
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Nicolas Plessis <niplessis@gmail.com>
Maintainer: Nicolas Plessis <niplessis@gmail.com>
-#}

{% set env = salt['pillar.get']('docker-registry:environment', False) %}

include:
  - docker

registry-image:
  docker:
    - name: registry
    - pulled
    - tag: latest
    - insecure_registry: true
    - require:
      - pkg: lxc-docker

docker-registry:
  docker.installed:
    - name: registry
    - image: registry
    - tag: latest
    - require:
      - docker: registry-image
    {%- if env %}
    - environment:
      {%- for key, value in env.items() %}
      - {{ key }}: {{ value }}
      {%- endfor -%}
    {% endif %}

registry:
   docker:
     - running
     - container: registry
     - port_bindings:
            "5000/tcp":
                HostIp: ""
                HostPort: "{{ salt['pillar.get']('docker-registry:port', 5000) }}"
     - require:
       - docker: docker-registry
