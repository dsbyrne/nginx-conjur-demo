#!/usr/bin/env bash
set -e

# Load the policies into Conjur
conjur policy load --as-group security_admin policy/application_nginx.yml
conjur policy load --as-group security_admin policy/entitlements.yml

# Generate some dummy data if we need to
gen_cert () {
  openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
  openssl rsa -passin pass:x -in server.pass.key -out server.key

  rm server.pass.key

  openssl req -new -key server.key -out server.csr <<-EOF 
	US
	Massachusetts
	Boston
	MyOrg
	IT
	*.myorg.com
	admin@myorg.com
	
	
	EOF

  openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

  rm server.csr
}

SSL_DIR=ssl
mkdir -p $SSL_DIR
pushd $SSL_DIR
	if [[ ! -e server.key || ! -e server.crt ]]; then
		gen_cert
	fi


	conjur variable values add my-application/nginx/certificate "$(cat server.crt)"
	conjur variable values add my-application/nginx/certificate-key "$(cat server.key)"
popd

