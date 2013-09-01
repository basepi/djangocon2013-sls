include:
  - mysql.server
  - mysql.python

# Remove the "test" database
mysql_remove_testdb:
  mysql_database:
    - absent
    - name: test

/etc/mysql/my.cnf:
  file:
    - managed
    - source: salt://foo/files/my.cnf
    - watch_in:
      - service: mysqld

{% for name, db in salt['pillar.get']('foo:DATABASES', {}).items() %}
foodb:
  mysql_database:
    - present
    - name: {{ db.get('NAME') }}
    - require:
      - service: mysqld
      - pkg: mysql-python

{% for host, ifaces in salt['mine.get']('djangocon-web*', 'network.interfaces').iteritems() %}
# Get first IP of eth0
{% set client_ip = ifaces.get('eth0', {}).get('inet', [{}])[0].get('address') %}
{% if client_ip %}
foodb_user_{{ client_ip }}:
  mysql_user:
    - present
    - name: {{ db.get('USER') }}
    - host: {{ client_ip }}
    - password: {{ db.get('PASSWORD') }}
    - require:
      - mysql_database: foodb

foodb_grants_{{ client_ip }}:
  mysql_grants:
    - present
    - grant: all privileges
    - database: {{ db.get('NAME') }}.*
    - user: {{ db.get('USER') }}
    - host: {{ client_ip }}
    - require:
      - mysql_user: foodb_user_{{ client_ip }}
{% endif %}
{% endfor %}
{% endfor %}
