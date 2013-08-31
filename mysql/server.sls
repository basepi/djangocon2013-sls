{% from "mysql/map.jinja" import mysql with context %}

mysqld:
  pkg:
    - installed
    - name: {{ mysql.server }}
  service:
    - running
    - name: {{ mysql.service }}
    - enable: True
    - watch:
      - pkg: mysqld
