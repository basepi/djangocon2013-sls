{% set foo_venv = salt['pillar.get']('foo:venv') %}
{% set foo_proj = salt['pillar.get']('foo:proj') %}

foo_loaddata:
  cmd:
    - run
    - name: {{ foo_venv }}/bin/django-admin.py loaddata --settings=foo.settings {{ foo_proj }}/foo/fixtures/foo.json
