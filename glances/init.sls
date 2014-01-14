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

Author: Nicolas Plessis <choopooly@gmail.com>
Maintainer: Nicolas Plessis <choopooly@gmail.com>
-#}

/usr/local:
  file:
    - directory
    - name: /usr/local/bin
    - makedirs: True
    - user: root
    - group: root
    - mode: 755

glances:
  virtualenv:
    - manage
    - upgrade: True
    - name: /usr/local/glances
    - require:
      - file: /usr/local
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/glances
    - requirements: /usr/local/glances/salt-requirements.txt
    - require:
      - virtualenv: glances
    - watch:
      - file: glances_requirements

glances_requirements:
  file:
    - managed
    - name: /usr/local/glances/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://glances/requirements.jinja2
    - require:
      - virtualenv: glances

/usr/local/bin/glances:
  file:
    - symlink
    - target: /usr/local/glances/local/bin/glances