{% set foo_venv = salt['pillar.get']('foo:venv') %}
{% set foo_proj = salt['pillar.get']('foo:proj') %}
{% set foo_settings = salt['pillar.get']('foo:settings') %}

include:
  - git
  - pip
  - ssh.server

github.com:
  ssh_known_hosts:
    - present
    - user: root
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48
    - require:
      - pkg: ssh_server

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

foo_wsgi:
  file:
    - managed
    - name: {{ foo_proj }}/foo/wsgi.py
    - source: salt://foo/files/wsgi.py
    - template: jinja
