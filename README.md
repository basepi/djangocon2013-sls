djangocon2013-sls
=================

This repository contains the SLS files for the 'Using SaltStack to Bootstrap
Django' tutorial for DjangoCon 2013.

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
configuration and pillar data used for the tutorial. As I did not use the git
external pillar for my pillar data, the ``pillar.example`` was copied to the
Master under ``/srv/pillar/multihost`` (the location for the Pillar SLS in the
multi-host example was different, see this same file in the ``multihost``
environment for more info), named it ``django.sls``, and assigned this Pillar
data to all hosts using the following Pillar top.sls:

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
```
