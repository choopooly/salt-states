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

docker-dependencies:
  pkg:
    - installed
    - pkgs:
      - iptables
      - ca-certificates
      - lxc

docker-py:
  pip:
    - installed

docker-repo:
    pkgrepo:
      - managed
      - repo: 'deb http://get.docker.io/ubuntu docker main'
      - file: '/etc/apt/sources.list.d/docker.list'
      - key_url: salt://docker/key.pgp
      - require_in:
          - pkg: lxc-docker

lxc-docker:
  pkg:
    - latest
    - require:
      - pkgrepo: docker-repo
      - pkg: docker-dependencies

docker-config:
  file:
    - managed
    - name: /etc/default/docker
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://docker/config.jinja2

docker:
  service:
    - running
    - watch:
      - file: docker-config

