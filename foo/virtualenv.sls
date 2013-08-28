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

{% set foo_sitepackages = salt['cmd.exec_code'](
    salt['pillar.get']('foo:venv') ~ '/bin/python',
    'from distutils import sysconfig; print sysconfig.get_python_lib()') %}

foo_pth:
  file:
    - managed
    - name: {{ foo_sitepackages }}/foo.pth
    - contents: {{ foo_proj }}

