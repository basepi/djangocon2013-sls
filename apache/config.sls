{% set etcapache = salt['pillar.get']('dirmap:etcapache', '/etc/httpd') %}

{{ etcapache }}/conf.d/django-foo.conf:
  file:
    - managed
    - source: salt://apache/files/conf.d/django-foo.conf
    - require:
      - pkg: apache
{% if grains.get('os_family', '') == 'RedHat' %}
      - file: {{ etcapache }}/conf.d/wsgi.conf
{% endif %}
    - watch_in:
      - service: apache

{{ etcapache }}/conf.d/welcome.conf:
  file:
    - absent
