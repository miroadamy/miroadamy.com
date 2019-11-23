---
title: "Install AWS CLI on Mac"
date: 2017-11-14T14:22:48+08:00
published: true
type: post
categories: ["DevOps"]
tags: ["aws", "cloud", "command-line"]
author: "Miro Adamy"
---

The Mac comes with Python 2.7 and no pip

This guide recommends upgrade to Python 3 which I want to avoid: http://docs.aws.amazon.com/cli/latest/userguide/cli-install-macos.html

## Unsuccesfull path - keep the Python 2.7

```
➜  ~ pip --version
zsh: command not found: pip

➜  ~ sudo easy_install pip
Password:
Searching for pip
Reading https://pypi.python.org/simple/pip/
Best match: pip 9.0.1
Downloading https://pypi.python.org/packages/11/b6/abcb525026a4be042b486df43905d6893fb04f05aac21c32c638e939e447/pip-9.0.1.tar.gz#md5=35f01da33009719497f01a4ba69d63c9
Processing pip-9.0.1.tar.gz
Writing /tmp/easy_install-QnLLJp/pip-9.0.1/setup.cfg
Running pip-9.0.1/setup.py -q bdist_egg --dist-dir /tmp/easy_install-QnLLJp/pip-9.0.1/egg-dist-tmp-03hMh7
/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/distutils/dist.py:267: UserWarning: Unknown distribution option: 'python_requires'
  warnings.warn(msg)
warning: no previously-included files found matching '.coveragerc'
warning: no previously-included files found matching '.mailmap'
warning: no previously-included files found matching '.travis.yml'
warning: no previously-included files found matching '.landscape.yml'
warning: no previously-included files found matching 'pip/_vendor/Makefile'
warning: no previously-included files found matching 'tox.ini'
warning: no previously-included files found matching 'dev-requirements.txt'
warning: no previously-included files found matching 'appveyor.yml'
no previously-included directories found matching '.github'
no previously-included directories found matching '.travis'
no previously-included directories found matching 'docs/_build'
no previously-included directories found matching 'contrib'
no previously-included directories found matching 'tasks'
no previously-included directories found matching 'tests'
creating /Library/Python/2.7/site-packages/pip-9.0.1-py2.7.egg
Extracting pip-9.0.1-py2.7.egg to /Library/Python/2.7/site-packages
Adding pip 9.0.1 to easy-install.pth file
Installing pip script to /usr/local/bin
Installing pip2.7 script to /usr/local/bin
Installing pip2 script to /usr/local/bin

Installed /Library/Python/2.7/site-packages/pip-9.0.1-py2.7.egg
Processing dependencies for pip
Finished processing dependencies for pip

➜  ~ pip --version
pip 9.0.1 from /Library/Python/2.7/site-packages/pip-9.0.1-py2.7.egg (python 2.7)

➜  ~ pip install awscli --upgrade --user
Collecting awscli
  Downloading awscli-1.11.185-py2.py3-none-any.whl (1.2MB)
    100% |████████████████████████████████| 1.2MB 1.1MB/s
Collecting colorama<=0.3.7,>=0.2.5 (from awscli)
  Downloading colorama-0.3.7-py2.py3-none-any.whl
Collecting s3transfer<0.2.0,>=0.1.9 (from awscli)
  Downloading s3transfer-0.1.11-py2.py3-none-any.whl (54kB)
    100% |████████████████████████████████| 61kB 6.2MB/s
Collecting botocore==1.7.43 (from awscli)
  Downloading botocore-1.7.43-py2.py3-none-any.whl (3.7MB)
    100% |████████████████████████████████| 3.7MB 363kB/s
Collecting docutils>=0.10 (from awscli)
  Downloading docutils-0.14-py2-none-any.whl (543kB)
    100% |████████████████████████████████| 552kB 2.4MB/s
Collecting rsa<=3.5.0,>=3.1.2 (from awscli)
  Downloading rsa-3.4.2-py2.py3-none-any.whl (46kB)
    100% |████████████████████████████████| 51kB 5.9MB/s
Collecting PyYAML<=3.12,>=3.10 (from awscli)
  Downloading PyYAML-3.12.tar.gz (253kB)
    100% |████████████████████████████████| 256kB 3.5MB/s
Collecting futures<4.0.0,>=2.2.0; python_version == "2.6" or python_version == "2.7" (from s3transfer<0.2.0,>=0.1.9->awscli)
  Downloading futures-3.1.1-py2-none-any.whl
Collecting jmespath<1.0.0,>=0.7.1 (from botocore==1.7.43->awscli)
  Downloading jmespath-0.9.3-py2.py3-none-any.whl
Collecting python-dateutil<3.0.0,>=2.1 (from botocore==1.7.43->awscli)
  Downloading python_dateutil-2.6.1-py2.py3-none-any.whl (194kB)
    100% |████████████████████████████████| 194kB 4.5MB/s
Collecting pyasn1>=0.1.3 (from rsa<=3.5.0,>=3.1.2->awscli)
  Downloading pyasn1-0.3.7-py2.py3-none-any.whl (63kB)
    100% |████████████████████████████████| 71kB 7.8MB/s
Collecting six>=1.5 (from python-dateutil<3.0.0,>=2.1->botocore==1.7.43->awscli)
  Downloading six-1.11.0-py2.py3-none-any.whl
Installing collected packages: colorama, futures, jmespath, docutils, six, python-dateutil, botocore, s3transfer, pyasn1, rsa, PyYAML, awscli
  Running setup.py install for PyYAML ... done
Successfully installed PyYAML-3.12 awscli-1.11.185 botocore-1.7.43 colorama-0.3.7 docutils-0.14 futures-3.1.1 jmespath-0.9.3 pyasn1-0.3.7 python-dateutil-2.6.1 rsa-3.4.2 s3transfer-0.1.11 six-1.11.0

➜  ~ aws --version
zsh: command not found: aws

➜  ~ sw_vers
ProductName:    Mac OS X
ProductVersion: 10.13.1
BuildVersion:   17B48
```

This does not work.

There is no aws script in `~/.local/bin`, the pip install just added som python libraries

=> Repeating did not help either

```
Requirement already up-to-date: awscli in ./Library/Python/2.7/lib/python/site-packages
Requirement already up-to-date: colorama<=0.3.7,>=0.2.5 in ./Library/Python/2.7/lib/python/site-packages (from awscli)
Requirement already up-to-date: s3transfer<0.2.0,>=0.1.9 in ./Library/Python/2.7/lib/python/site-packages (from awscli)
Requirement already up-to-date: botocore==1.7.43 in ./Library/Python/2.7/lib/python/site-packages (from awscli)
Requirement already up-to-date: docutils>=0.10 in ./Library/Python/2.7/lib/python/site-packages (from awscli)
Requirement already up-to-date: rsa<=3.5.0,>=3.1.2 in ./Library/Python/2.7/lib/python/site-packages (from awscli)
Requirement already up-to-date: PyYAML<=3.12,>=3.10 in ./Library/Python/2.7/lib/python/site-packages (from awscli)
Requirement already up-to-date: futures<4.0.0,>=2.2.0; python_version == "2.6" or python_version == "2.7" in ./Library/Python/2.7/lib/python/site-packages (from s3transfer<0.2.0,>=0.1.9->awscli)
Requirement already up-to-date: jmespath<1.0.0,>=0.7.1 in ./Library/Python/2.7/lib/python/site-packages (from botocore==1.7.43->awscli)
Requirement already up-to-date: python-dateutil<3.0.0,>=2.1 in ./Library/Python/2.7/lib/python/site-packages (from botocore==1.7.43->awscli)
Requirement already up-to-date: pyasn1>=0.1.3 in ./Library/Python/2.7/lib/python/site-packages (from rsa<=3.5.0,>=3.1.2->awscli)
Requirement already up-to-date: six>=1.5 in ./Library/Python/2.7/lib/python/site-packages (from python-dateutil<3.0.0,>=2.1->botocore==1.7.43->awscli)
```

## Simple and working - brew to the rescue

Redoing with brew => installs Python 3 :-( but it works

```
➜  ~ brew install awscli
Updating Homebrew...
==> Auto-updated Homebrew!
Updated 1 tap (homebrew/core).
==> New Formulae
dps8m                                 heartbeat                             simg2img
e2tools                               kaitai-struct-compiler
==> Updated Formulae
libuv ✔            exploitdb          grpc               logstash           paket              singular
abcmidi            faac               gsmartcontrol      mdds               pandoc             sjk
amazon-ecs-cli     faas-cli           harfbuzz           mercurial          pandoc-crossref    solr
apibuilder-cli     ffmpeg@2.8         i2p                mighttpd2          pcl                source-to-image
asciidoc           firebase-cli       imagemagick        mikutter           pipenv             sourcekitten
b2-tools           flow               imagemagick@6      mingw-w64          poco               supersonic
babl               fluent-bit         influxdb           mosh               poppler            swift-protobuf
bash-snippets      fn                 inspircd           mupdf              postgresql         swiftformat
bazel              folly              iron-functions     mupdf-tools        postgresql@9.4     swiftlint
bchunk             frugal             itstool            mypy               postgresql@9.5     temporal_tables
binaryen           gdcm               jenkins            nativefier         postgresql@9.6     terragrunt
bit                gegl               jenkins-lts        nco                pre-commit         tintin
bitrise            getdns             jfrog-cli-go       ncview             prometheus         upscaledb
buku               geth               jruby              netcdf             protobuf           urh
cmake              git-annex          kerl               nickle             protobuf-c         vapoursynth
convox             git-cinnabar       kubectx            node-build         protobuf-swift     vtk
couchdb            gjstest            libgsf             ntl                pumba              wireguard-tools
cppad              glide              libmaxminddb       nuttcp             resty              xtensor
dbus               gmt                libogg             omniorb            ringojs            yara
debianutils        gmt@4              libopusenc         ompl               sassc              zabbix
docfx              gofabric8          libphonenumber     opencoarrays       scalaenv           zbackup
dssim              grafana            libpq              ortp               scalastyle         zenity
erlang             grakn              libpqxx            packetq            scm-manager        zimg
==> Renamed Formulae
newsbeuter -> newsboat

==> Installing dependencies for awscli: pkg-config, sqlite, openssl, python3
==> Installing awscli dependency: pkg-config
==> Downloading https://homebrew.bintray.com/bottles/pkg-config-0.29.2.high_sierra.bottle.tar.gz
==> Downloading from https://akamai.bintray.com/f1/f1b29fb5388dccab0fcaf665ab43d308ee51816b24262417bf83a686b6e30
######################################################################## 100.0%
==> Pouring pkg-config-0.29.2.high_sierra.bottle.tar.gz
🍺  /usr/local/Cellar/pkg-config/0.29.2: 11 files, 627.2KB
==> Installing awscli dependency: sqlite
==> Downloading https://homebrew.bintray.com/bottles/sqlite-3.21.0.high_sierra.bottle.tar.gz
==> Downloading from https://akamai.bintray.com/7d/7d2f6274d626acafed914d37e953cac4e33022eb889c6998af19bf1932270
######################################################################## 100.0%
==> Pouring sqlite-3.21.0.high_sierra.bottle.tar.gz
==> Caveats
This formula is keg-only, which means it was not symlinked into /usr/local,
because macOS provides an older sqlite3.

If you need to have this software first in your PATH run:
  echo 'export PATH="/usr/local/opt/sqlite/bin:$PATH"' >> ~/.zshrc

For compilers to find this software you may need to set:
    LDFLAGS:  -L/usr/local/opt/sqlite/lib
    CPPFLAGS: -I/usr/local/opt/sqlite/include
For pkg-config to find this software you may need to set:
    PKG_CONFIG_PATH: /usr/local/opt/sqlite/lib/pkgconfig

==> Summary
🍺  /usr/local/Cellar/sqlite/3.21.0: 11 files, 3.0MB
==> Installing awscli dependency: openssl
==> Downloading https://homebrew.bintray.com/bottles/openssl-1.0.2m.high_sierra.bottle.tar.gz
==> Downloading from https://akamai.bintray.com/0e/0eeee936b7f362ec5d2d844deb74ec92b79d3105445e5ca5e8767df4aabde
######################################################################## 100.0%
==> Pouring openssl-1.0.2m.high_sierra.bottle.tar.gz
==> Caveats
A CA file has been bootstrapped using certificates from the SystemRoots
keychain. To add additional certificates (e.g. the certificates added in
the System keychain), place .pem files in
  /usr/local/etc/openssl/certs

and run
  /usr/local/opt/openssl/bin/c_rehash

This formula is keg-only, which means it was not symlinked into /usr/local,
because Apple has deprecated use of OpenSSL in favor of its own TLS and crypto libraries.

If you need to have this software first in your PATH run:
  echo 'export PATH="/usr/local/opt/openssl/bin:$PATH"' >> ~/.zshrc

For compilers to find this software you may need to set:
    LDFLAGS:  -L/usr/local/opt/openssl/lib
    CPPFLAGS: -I/usr/local/opt/openssl/include
For pkg-config to find this software you may need to set:
    PKG_CONFIG_PATH: /usr/local/opt/openssl/lib/pkgconfig

==> Summary
🍺  /usr/local/Cellar/openssl/1.0.2m: 1,792 files, 12.3MB
==> Installing awscli dependency: python3
Warning: Building python3 from source:
  The bottle needs the Apple Command Line Tools to be installed.
  You can install them, if desired, with:
    xcode-select --install

==> Downloading https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tar.xz
######################################################################## 100.0%
==> ./configure --prefix=/usr/local/Cellar/python3/3.6.3 --enable-ipv6 --datarootdir=/usr/local/Cellar/python3/3
==> make
==> make install PYTHONAPPSDIR=/usr/local/Cellar/python3/3.6.3
==> make frameworkinstallextras PYTHONAPPSDIR=/usr/local/Cellar/python3/3.6.3/share/python3
==> Downloading https://files.pythonhosted.org/packages/a4/c8/9a7a47f683d54d83f648d37c3e180317f80dc126a304c45dc6
######################################################################## 100.0%
==> Downloading https://files.pythonhosted.org/packages/11/b6/abcb525026a4be042b486df43905d6893fb04f05aac21c32c6
######################################################################## 100.0%
==> Downloading https://files.pythonhosted.org/packages/fa/b4/f9886517624a4dcb81a1d766f68034344b7565db69f13d5269
######################################################################## 100.0%
==> /usr/local/Cellar/python3/3.6.3/bin/python3 -s setup.py --no-user-cfg install --force --verbose --install-sc
==> /usr/local/Cellar/python3/3.6.3/bin/python3 -s setup.py --no-user-cfg install --force --verbose --install-sc
==> /usr/local/Cellar/python3/3.6.3/bin/python3 -s setup.py --no-user-cfg install --force --verbose --install-sc
==> Caveats
Pip, setuptools, and wheel have been installed. To update them
  pip3 install --upgrade pip setuptools wheel

You can install Python packages with
  pip3 install <package>

They will install into the site-package directory
  /usr/local/lib/python3.6/site-packages

See: https://docs.brew.sh/Homebrew-and-Python.html
==> Summary
🍺  /usr/local/Cellar/python3/3.6.3: 7,973 files, 111MB, built in 2 minutes 14 seconds
==> Installing awscli
==> Downloading https://homebrew.bintray.com/bottles/awscli-1.11.180_1.high_sierra.bottle.tar.gz
==> Downloading from https://akamai.bintray.com/16/168d726049366b4cbd1278e0e4a4e0e7e406d555e13e3681a968ca629776c
######################################################################## 100.0%
==> Pouring awscli-1.11.180_1.high_sierra.bottle.tar.gz
==> Caveats
The "examples" directory has been installed to:
  /usr/local/share/awscli/examples

Bash completion has been installed to:
  /usr/local/etc/bash_completion.d

zsh completions and functions have been installed to:
  /usr/local/share/zsh/site-functions
==> Summary
🍺  /usr/local/Cellar/awscli/1.11.180_1: 4,119 files, 35.8MB


➜  ~ aws --version
aws-cli/1.11.180 Python/3.6.3 Darwin/17.2.0 botocore/1.7.38
➜  ~ python --version
Python 2.7.10
➜  ~ python3 --version
Python 3.6.3
➜  ~ pip --version
pip 9.0.1 from /Library/Python/2.7/site-packages/pip-9.0.1-py2.7.egg (python 2.7)
➜  ~ pip3 --version
pip 9.0.1 from /usr/local/lib/python3.6/site-packages (python 3.6)
```

Main reason why I was trying to avoid Python3 were some Python2 tools that were reportedly broken by presence of Python3. 

Luckily, it turns out I have both python and python3 working afterward
