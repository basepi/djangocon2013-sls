{% set foo_venv = salt['pillar.get']('foo:venv') %}
{% set foo_proj = salt['pillar.get']('foo:proj') %}
{% set foo_settings = salt['pillar.get']('foo:settings') %}

include:
  - git
  - pip
  - ssh.server
  - virtualenv
  - mysql.python

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
      - virtualenv: foo_venv

foo_pkgs:
  pip:
    - installed
    - bin_env: {{ foo_venv }}
    - requirements: {{ foo_proj }}/requirements.txt
    - require:
      - git: foo
      - pkg: pip
      - virtualenv: foo_venv

# Get salt['mine.get']('djangocon-db1', 'network.interfaces')['djangocon-db1']['eth0']['inet'][0]['address']
{% set db_server_ip = salt['mine.get']('djangocon-db1', 'network.interfaces').get('djangocon-db1', {}).get('eth0', {}).get('inet', [{}])[0].get('address') %}
{% if db_server_ip %}
foo_settings:
  file:
    - managed
    - name: {{ foo_proj }}/foo/settings.py
    - source: salt://foo/files/settings.py
    - template: jinja
    - context:
      db_server_ip: {{ db_server_ip }}
    - require:
      - git: foo
      - pkg: mysql-python
{% endif %}

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
    - run
    - name: django.syncdb
    - settings_module: {{ foo_settings }}
    - bin_env: {{ foo_venv }}
    - pythonpath: {{ foo_proj }}
    - require:
      - file: foo_settings
      - pip: foo_pkgs

foo_collectstatic:
  module:
    - run
    - name: django.collectstatic
    - settings_module: {{ foo_settings }}
    - bin_env: {{ foo_venv }}
    - pythonpath: {{ foo_proj }}
    - require:
      - file: foo_settings
      - pip: foo_pkgs
