{% set foo_venv = salt['pillar.get']('foo:venv') %}
{% set foo_settings = salt['pillar.get']('foo:settings') %}

include:
  - foo.app

foo_loaddata:
  module:
    - run
    - name: django.loaddata
    - settings_module: {{ foo_settings }}
    - bin_env: {{ foo_venv }}
    - watch_in:
      - module: foo_syncdb
      - module: foo_collectstatic
