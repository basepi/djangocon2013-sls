include:
  - foo.app
  - foo.settings
  - foo.virtualenv
{% if grains['os'] == 'CentOS' %}
  - foo.firewall
{% endif %}
