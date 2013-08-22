# https://github.com/terminalmage/djangocon2013-sls.git

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
    - require:
      - pkg: virtualenv

{% set foo_sitepackages = salt['cmd.exec_code'](
    salt['pillar.get']('foo:venv') ~ '/bin/python',
    'from distutils import sysconfig; print sysconfig.get_python_lib()') %}

foo_pth:
  file:
    - managed
    - name: {{ foo_sitepackages }}/foo.pth
    - contents: {{ foo_proj }}

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
    - source: salt://foo/settings.py
    - template: jinja

foo_wsgi:
  file:
    - managed
    - name: {{ foo_proj }}/foo/wsgi.py
    - source: salt://foo/wsgi.py
    - template: jinja

foo_syncdb:
  module:
    - wait
    - name: django.syncdb
    - kwargs:
      - settings_module: {{ foo_settings }}
    - bin_env: {{ foo_venv }}

foo_collectstatic:
  module:
    - wait
    - name: django.collectstatic
    - kwargs:
      - settings_module: {{ foo_settings }}
    - bin_env: {{ foo_venv }}
