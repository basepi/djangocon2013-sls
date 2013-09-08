djangocon2013-sls
=================

This repository contains the SLS files for the 'Using SaltStack to Bootstrap
Django' tutorial for DjangoCon 2013.

The documentation in this README pertains to the single-host demo. For
documentation on the multi-host demo, see
[here](https://github.com/terminalmage/djangocon2013-sls/tree/multihost#djangocon2013-sls).

The slides for the presentation can be found in the root of the ``master``
branch, in a file called ``Salted Django.odp``. This presentation is in Open
Document Format and requires LibreOffice, OpenOffice, or another application
capable of reading ODF documents to view. Due to the large number of text
animations in these slides, they are best viewed in presentation mode, rather
than in the slide editor.

The application deployed using this SLS is the ``polls`` app from the [Django
Tutorial](https://docs.djangoproject.com/en/1.5/intro/tutorial01/). The views,
CSS, etc. which were used can be found
[here](https://github.com/terminalmage/django-tutorial).

The ``overstate.example`` and ``pillar.example`` files contain the OverState
configuration and Pillar data used for the tutorial. While I used the [git
fileserver
backend](http://docs.saltstack.com/ref/file_server/backends.html?highlight=git%20fileserver)
to serve up the SLS files for the demos, the pillar data was served up in the
traditional way. I saved the ``pillar.example`` file to the Master under
``/srv/pillar/base/django.sls`` (the location for this file in the multi-host
example is different, see the [README in the ``multihost``
branch](https://github.com/terminalmage/djangocon2013-sls/tree/multihost#djangocon2013-sls)
for more info). This Pillar data was then assigned to all hosts using the
following Pillar top.sls:

```yaml
base:
  '*':
    - django
```

The corresponding Master configuration needed to enable Pillar (for both the
single and multi-host demos) is as follows:

```yaml
pillar_roots:
  base:
    - /srv/pillar/base
  multihost:
    - /srv/pillar/multihost
