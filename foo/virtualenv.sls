{% set foo_venv = salt['pillar.get']('foo:venv') %}
{% set foo_proj = salt['pillar.get']('foo:proj') %}

include:
  - virtualenv

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

