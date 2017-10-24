Ansible roles created with ansible-galaxy scaffolding:

ansible-galaxy init <role-name>

Example for role "common":

common/
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── library
├── lookup_plugins
├── meta
│   └── main.yml
├── README.md
├── tasks
│   └── main.yml
├── templates
└── vars
    └── main.yml

defaults:  main.yml in this directory is where the default out-of-the-box
configuration exists (for a database server, this could be data directories,
port to listen on, and others). We'll say that all sqlite databases should
exist under /var/lib/sqlite, and that we have a (for now) empty list of
databases to set up. These are default lower priority variables for this role.

files: files for use with the copy resource.

handlers: Handlers are tasks which can be set up to run on particular events,
these are typically restarting a service or similar activity on configuration
change.

library: roles can also include custom modules

lookup_plugins: other types of plugins, like lookup in this case.

meta: main.yml under the meta subfolder is where we specify information about
our module: who created it (us!), a description of the module, any other Galaxy
dependencies it has, and so on. It also contains an explicit list of which
platforms/versions it supports. Also is dedicated to role dependencies.

tasks:  here we store the task definitions for our role. 

templates:  this is where templates that get rendered by ansible get placed.
These are jinja templates with access to the Ansible variables and vars that
get passed in. Templates end in .j2

vars: variables associated with this role



