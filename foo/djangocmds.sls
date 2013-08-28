{% set foo_venv = salt['pillar.get']('foo:venv') %}
{% set foo_settings = salt['pillar.get']('foo:settings') %}

foo_syncdb:
  module:
    - wait
    - name: django.syncdb
    - settings_module: {{ foo_settings }}
    - bin_env: {{ foo_venv }}

foo_collectstatic:
  module:
    - wait
    - name: django.collectstatic
    - settings_module: {{ foo_settings }}
    - bin_env: {{ foo_venv }}
