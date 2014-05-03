#
# Cookbook Name:: auth
# Recipe:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'openssl'

deployment = search(node["deployment"]["id"], "id:webapp_ipython")

deployment.each do |app|
  app = Chef::EncryptedDataBagItem.load(node["deployment"]["id"], app['id'])

  # User specified IPython Notebook Configuration
  node.set['ipynb']['linux_user'] = app['ipynb']['linux_user']
  node.set['ipynb']['linux_group'] = app['ipynb']['linux_group']
  node.set['ipynb']['NotebookApp']['password'] = app['ipynb']['NotebookApp']['password']

  key = OpenSSL::PKey::RSA.new(1024)
  public_key = key.public_key

  subject = "/C=US/O=checkmate/OU=ipython notebook/CN=ipynb"

  cert = OpenSSL::X509::Certificate.new
  cert.subject = cert.issuer = OpenSSL::X509::Name.parse(subject)
  cert.not_before = Time.now
  cert.not_after = Time.now + 365 * 24 * 60 * 60
  cert.public_key = public_key
  cert.serial = SecureRandom.random_number(2**256)
  cert.version = 2

  ef = OpenSSL::X509::ExtensionFactory.new
  ef.subject_certificate = cert
  ef.issuer_certificate = cert
  cert.extensions = [
  ef.create_extension("basicConstraints","CA:TRUE", true),
  ef.create_extension("subjectKeyIdentifier", "hash"),
  # ef.create_extension("keyUsage", "cRLSign,keyCertSign", true),
  ]
  cert.add_extension ef.create_extension("authorityKeyIdentifier",
  "keyid:always,issuer:always")

  cert.sign key, OpenSSL::Digest::SHA1.new

  # Generate self-signed certificates
  node.set['ipynb']['ssl_certificate'] = '/etc/nginx/ssl.crt'
  node.set['ipynb']['ssl_certificate_text'] = cert.to_pem

  node.set['ipynb']['ssl_certificate_key'] = '/etc/nginx/ssl.key'
  node.set['ipynb']['ssl_certificate_key_text'] = key.to_pem

end
