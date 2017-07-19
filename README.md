# Juniper / Pulse Secure VPN image for Docksal

Connects to Juniper / Pulse Secure VPN using the legacy Network Connect (ncsvc) client, which works on Linux.  
Provides access to the remote network by running Socks5 (port `1080`) and HTTP/HTTPS (port `8080`) proxies.   

This image(s) is part of the [Docksal](http://docksal.io) image library.


## Configuration

VPN connection settings are passed via a configuration file.

**vpn.conf**

```
[vpn]
host = vpn.example.com
username = joe
password = secret
password2 = push
socks_port = 1081
host_checker = 1
```


## Running as a standalone container

```bash
docker run -d --name=jvpn --restart=failure \
	-p 1080:1080 -p 8080:8080 \
	-v /path/to/vpn.conf:/root/.juniper_networks/juniper-vpn-wrap.conf \
	docksal/juniper-vpn
```


## Running as a project service

```yaml
  vpn:
    hostname: vpn
    image: docksal/juniper-vpn
    ports:
      - 1080:1080
      - 8080:8080
    volumes:
      - /path/to/vpn.conf:/root/.juniper_networks/juniper-vpn-wrap.conf
```

Replace `/path/to/vpn.conf` with the actual path to the `vpn.conf` file.


## Credits

This image is based on [russdill/ncsvc-socks-wrapper](https://github.com/russdill/russdill/ncsvc-socks-wrapper).  


## Limitations and customizations

This image was created to work with a particular VPN server and may not work with other Juniper/Pulse Secure servers. 

VPN connection flow is handled by `juniper-vpn-wrap.py`.  
The original version was patched to add support for 2FA via Duo Mobile (push mode).

Feel free to submit issues and PR to improve it.


## License 

The origin project is published under the GPLv2 license, which requires this project to be published under the same license.
