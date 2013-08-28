{% set foo_venv = salt['pillar.get']('foo:venv') %}
{% set foo_proj = salt['pillar.get']('foo:proj') %}

include:
  - foo.app

foo_pth:
  file:
    - managed
    - name: {{ salt['virtualenv.get_site_packages'](foo_venv) }}/foo.pth
    - contents: {{ foo_proj }}
    - require:
      - virtualenv: foo_venv
    - watch_in:
      - module: foo_syncdb
      - module: foo_collectstatic

foo_loaddata:
  cmd:
    - run
    - name: {{ foo_venv }}/bin/django-admin.py loaddata --settings=foo.settings {{ foo_proj }}/foo/fixtures/foo.json
    - require:
      - file: foo_pth
      - file: foo_settings
