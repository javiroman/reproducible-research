# Virtualenv and VirtualenvWrapper
 
http://virtualenvwrapper.readthedocs.io/en/latest/command_ref.html

# Guide

Depending on your Python system environment (2.x or 3.x Python based):

```
$ sudo dnf install python2-virtualenv python2-virtualenvwrapper
Or
$ sudo dnf install python3-virtualenv python3-virtualenvwrapper
```
 
## Example session
 
```
mkvirtualenv --python=/usr/bin/python3 py-env01 -r requeriments.txt
mkvirtualenv --python=/usr/bin/python3 py-env02 
mkvirtualenv --python=/usr/bin/python3 py-env03
	
(py-env03) [javierroman@stratiohost ~]$ workon
py-env01
py-env02
py-env03
(py-env03) [javierroman@stratiohost ~]$ workon py-env01
(py-env01) [javierroman@stratiohost ~]$ deactivate
[javierroman@stratiohost ~]$ rmvirtualenv py-env03
Removing py-env03...
```

