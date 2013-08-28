include:
  - foo.app
  - foo.settings
  - foo.virtualenv
  - foo.djangocmds
{% if grains['os'] == 'CentOS' %}
  - foo.firewall
{% endif %}
