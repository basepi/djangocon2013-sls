include:
  - foo.app
{% if grains['os'] == 'CentOS' %}
  - foo.firewall
{% endif %}
