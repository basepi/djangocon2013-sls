{% set foo_proj = salt['pillar.get']('foo:proj') %}

foo_settings:
  file:
    - managed
    - name: {{ foo_proj }}/foo/settings.py
    - source: salt://foo/files/settings.py
    - template: jinja

