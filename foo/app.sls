{% set foo_venv = salt['pillar.get']('foo:venv') %}
{% set foo_proj = salt['pillar.get']('foo:proj') %}
{% set foo_settings = salt['pillar.get']('foo:settings') %}

include:
  - git
  - pip
  - ssh.server
  - virtualenv

github.com:
  ssh_known_hosts:
    - present
    - user: root
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48
    - require:
      - pkg: ssh_server

empty_venv:
  virtualenv:
    - managed
    - name: /var/www/BASELINE
    - require:
      - pkg: virtualenv

foo_venv:
  virtualenv:
    - managed
    - name: {{ foo_venv }}
    - system_site_packages: True
    - require:
      - pkg: virtualenv

foo:
  git.latest:
    - name: https://github.com/terminalmage/django-tutorial.git
    - target: {{ foo_proj }}
    - force: True
    - require:
      - pkg: git
      - ssh_known_hosts: github.com
    - watch_in:
      - module: foo_syncdb
      - module: foo_collectstatic

foo_pkgs:
  pip:
    - installed
    - bin_env: {{ foo_venv }}
    - requirements: {{ foo_proj }}/requirements.txt
    - require:
      - git: foo
      - pkg: pip
      - virtualenv: foo_venv

foo_settings:
  file:
    - managed
    - name: {{ foo_proj }}/foo/settings.py
    - source: salt://foo/files/settings.py
    - template: jinja
    - require:
      - git: foo

foo_wsgi:
  file:
    - managed
    - name: {{ foo_proj }}/foo/wsgi.py
    - source: salt://foo/files/wsgi.py
    - template: jinja
    - require:
      - git: foo

foo_syncdb:
  module:
    - wait
    - name: django.syncdb
    - settings_module: {{ foo_settings }}
    - bin_env: {{ foo_venv }}
    - pythonpath: {{ foo_proj }}

foo_collectstatic:
  module:
    - wait
    - name: django.collectstatic
    - settings_module: {{ foo_settings }}
    - bin_env: {{ foo_venv }}
    - pythonpath: {{ foo_proj }}
