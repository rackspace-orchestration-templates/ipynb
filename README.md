[![Circle CI](https://circleci.com/gh/rackspace-orchestration-templates/ipynb/tree/master.png?style=shield)](https://circleci.com/gh/rackspace-orchestration-templates/ipynb)
Description
===========
Single Linux server with [IPython Notebook
3.2.0](http://ipython.org/notebook.html) installed.

Requirements
============
* A Heat provider that supports the Rackspace `OS::Heat::ChefSolo` plugin.
* An OpenStack username, password, and tenant id.
* [python-heatclient](https://github.com/openstack/python-heatclient)
`>= v0.2.8`:

```bash
pip install python-heatclient
```

We recommend installing the client within a [Python virtual
environment](http://www.virtualenv.org/).

Example Usage
=============
Here is an example of how to deploy this template using the
[python-heatclient](https://github.com/openstack/python-heatclient):

```
heat --os-username <OS-USERNAME> --os-password <OS-PASSWORD> --os-tenant-id \
  <TENANT-ID> --os-auth-url https://identity.api.rackspacecloud.com/v2.0/ \
  stack-create IPython-Notebook -f ipynb.yaml \
  -P ssh_keypair_name=ipynb
```

* For UK customers, use `https://lon.identity.api.rackspacecloud.com/v2.0/` as
the `--os-auth-url`.

Optionally, set environmental variables to avoid needing to provide these
values every time a call is made:

```
export OS_USERNAME=<USERNAME>
export OS_PASSWORD=<PASSWORD>
export OS_TENANT_ID=<TENANT-ID>
export OS_AUTH_URL=<AUTH-URL>
```

Parameters
==========
Parameters can be replaced with your own values when standing up a stack. Use
the `-P` flag to specify a custom parameter.

* `server_hostname`: Sets the hostname of the server. (Default: ipynb)
* `image`: Operating system to install (Default: Ubuntu 14.04 LTS (Trusty
  Tahr))
* `flavor`: Cloud server size to use. (Default: 2 GB Performance)
* `ipynb_username`: System user to setup the virtual environment with.
  (Default: ipynb)
* `kitchen`: URL for the kitchen to clone with git. The Chef Solo run will copy
  all files in this repo into the kitchen for the chef run. (Default:
  https://github.com/rackspace-orchestration-templates/ipynb)
* `chef_version`: Chef client version to install for the chef run.  (Default:
  11.12.4)


Outputs
=======
Once a stack comes online, use `heat output-list` to see all available outputs.
Use `heat output-show <OUTPUT NAME>` to get the value fo a specific output.

* `private_key`: SSH private that can be used to login as root to the server.
* `server_ip`: Public IP address of the cloud server
* `ipynb_url`: URL to access IPython Notebook
* `ipynb_password`: Password for logging in IPython Notebook through the web
  interface. This value is randomly generated.

For multi-line values, the response will come in an escaped form. To get rid of
the escapes, use `echo -e '<STRING>' > file.txt`. For vim users, a substitution
can be done within a file using `%s/\\n/\r/g`.

Stack Details
=============
This launches an IPython notebook server fully configured with scientific
packages and inline matplotlib/pylab.

When the deployment finishes, you can access your deployment by using the IP
provided above. Login using the password you specified during deployment. *The
certificate will give an error as it is self-signed.*

#### Packages installed

By default, the python packages installed include:
* cython
* matplotlib
* networkx
* nltk
* numpy
* pandas
* patsy
* pillow
* pytables
* scikit-image
* scikit-learn
* scipy
* statsmodels
* sympy
* theano
* xlrd
* xlwt

#### Easy mode installation of more packages

If you want more packages installed, simply pip install them from within the
IPython notebook:

```python
In[1]: !pip install pkg_name
```

This will install it within the virtualenv that IPython notebook runs in.

#### Hard mode installation

Alternatively, you can ssh to the box, change user to ipynb, source the
virtualenv (`source ~/.ipyvirt/bin/activate`) and do a pip install.

```bash
(.ipyvirt)$ pip install pkg_name
```

If other system dependencies are needed, you will need to SSH to the box and
install the system packages (or ask us for help).

Contributing
============
There are substantial changes still happening within the [OpenStack
Heat](https://wiki.openstack.org/wiki/Heat) project. Template contribution
guidelines will be drafted in the near future.

License
=======
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
