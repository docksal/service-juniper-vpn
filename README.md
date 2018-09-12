# Juniper / Pulse Secure VPN client

Juniper / Pulse Secure VPN client packaged as a Docker image, thus can be used anywhere with Docker (Linux, macOS, Windows).

Uses the legacy Network Connect (`ncsvc`) client, which works on Linux.

Instead of joining the host machine into the VPN network (which is often not desirable), exposes access to the network 
via Socks5 (port `1080`) and HTTP/HTTPS (port `8080`) proxies.

This image(s) is part of the [Docksal](http://docksal.io) image library.


## Configuration

VPN connection settings are passed via a configuration file:

```
[vpn]
host = vpn.example.com
username = joe
password = secret
password2 = push
socks_port = 1081
host_checker = 1
```

Download a sample [juniper-vpn-wrap.conf](juniper-vpn-wrap.conf) and store it somewhere (e.g. `~/juniper-vpn-wrap.conf`).


## Running as a standalone container

```bash
docker run -d --name=juniper-vpn \
	-p 127.0.0.1:1080:1080 -p 127.0.0.1:8080:8080 \
	-v /path/to/juniper-vpn-wrap.conf:/root/.juniper_networks/juniper-vpn-wrap.conf \
	docksal/juniper-vpn
```

Proxy endpoints to use from the host:

Socks5:		`127.0.0.1:1080`  
HTTP/HTTPS:	`127.0.0.1:8080` 


## Running as a docker-compose project service

```yaml
  vpn:
    hostname: vpn
    image: docksal/juniper-vpn
    # Expose proxy ports so that the host also has access 
    ports:
      - 127.0.0.1:1080:1080
      - 127.0.0.1:8080:8080
    volumes:
      - /path/to/juniper-vpn-wrap.conf:/root/.juniper_networks/juniper-vpn-wrap.conf
```

Replace `/path/to/juniper-vpn-wrap.conf` with the actual path to the `juniper-vpn-wrap.conf` file.

Proxy endpoints to use by project containers:

Socks5:		`vpn:1080`  
HTTP/HTTPS:	`vpn:8080`

Note: in this mode the host can also access the VPN connection via `127.0.0.1:1080` and `127.0.0.1:8080` respectively. 
If this is not desirable, just remove the `ports` section from the yaml above.  


## Testing VPN connection

```bash
# This will should your direct connection IP address
curl https://ifconfig.co
# These will should your VPN connection IP address
curl --proxy http://127.0.0.1:8080 https://ifconfig.co 
curl --proxy socks5h://127.0.0.1:1080 https://ifconfig.co
```


## Using proxies with console tools 

Most console tools can pick up the HTTP/HTTPS proxy configuration from the environment: 

```bash
export http_proxy=http://127.0.0.1:8080
export https_proxy=http://127.0.0.1:8080
```

This works with `curl`, `composer`, git (`https://` schema only) and others.

For SSH and git over SSH the socks5 proxy has to be used.  
Add the following configuration to `~/.ssh/config`:

```apacheconfig
Host host.behind.vpn
	ProxyCommand nc -x 127.0.0.1:1080 %h %p
```

This will tell the ssh client (and thus git over ssh) to use the socks5 proxy to connect to `host.behind.vpn`. 


## Credits

This image is based on [russdill/ncsvc-socks-wrapper](https://github.com/russdill/ncsvc-socks-wrapper).  


## Limitations and customizations

This image was created to work with a particular VPN server and may not work with other Juniper/Pulse Secure servers. 

The VPN connection flow is handled by `juniper-vpn-wrap.py`.  
The original version was patched to add support for 2FA via Duo Mobile (push mode).

Feel free to submit issues and PR to improve it.


## License 

The origin project is published under the GPLv2 license, which requires this project to be published under the same license.
