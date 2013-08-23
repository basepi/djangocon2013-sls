{{ salt['pillar.get']('dirmap:etcapache', '/etc/httpd') }}/conf.d/django-foo.conf:
  file:
    - managed
    - source: salt://apache/files/conf.d/django-foo.conf
    - require:
      - pkg: apache
      - file: /etc/httpd/conf.d/wsgi.conf
    - watch_in:
      - service: apache

{{ salt['pillar.get']('dirmap:etcapache', '/etc/httpd') }}/conf.d/welcome.conf:
  file:
    - absent
