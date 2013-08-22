include:
  - mysql.server
  - mysql.python

{% for name, db in salt['pillar.get']('foo:DATABASES', {}).items() %}
foodb:
  mysql_database:
    - present
    - name: {{ name }}

foodb_user:
  mysql_user:
    - present
    - name: {{ db.get('USER') }}
    - host: {{ db.get('HOST') }}
    - password: {{ db.get('PASSWORD') }}
    - require:
      - mysql_database: foodb

foodb_grants:
  mysql_grants:
    - present
    - grant: all privileges
    - database: {{ name }}
    - user: {{ db.get('NAME') }}
    - host: {{ db.get('HOST') }}
    - require:
      - mysql_user: foodb_user
{% endfor %}
