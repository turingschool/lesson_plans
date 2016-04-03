```bash
brew install letsencrypt
letsencrypt certonly --manual
# Enter your email
# Accept terms
# Enter 'localhost' as the domain
# Say 'No' to re-entering domain names
```

### Let's Encrypt on Wordpress on digital ocean

1. Buy a domain
1. Create DO account
2. Add SSH key
1. Create wordpress container
2. Point domain to docker container
2. Log in via SSH
3. Basic set up of wordpress
4. clone letsencrypt
5. Run letsencrypt
6. Enter your domain name
7. Go to wordpress admin and change site url to https

## Let's Encrypt in Rails on digital ocean

1. Create a Ruby on Rails droplet
1. Needs to be 2GB
1. Name it
1. Put your SSH key there
1. Point a subdomain to your droplet
1. SSH into your droplet

```bash
$ ssh root@{IP_YOU_GOT_FROM_DIGITAL_OCEAN}
$ git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
$ cd /opt/letsencrypt
$ ./letsencrypt --nginx
$ /root/.local/share/letsencrypt/bin/pip install -U letsencrypt-nginx
```

1. Continue through the warning
1. Enter your full domain with subdomain
1. Enter your email address
1. Agree to the terms
1. Choose Easy
1. Go to your subdomain
1. Now go to your subdomain with https:// at the front


## Getting your code to run on this server

### Changes to your codebase

1. Add `unicorn` to your gemfile

### Changes to your server config

1. Copy the server section from `ngnix.conf`
```
server {
        server_name letsencrypt.neight.co;
        listen 443 ssl;
        ssl_certificate /etc/letsencrypt/live/letsencrypt.neight.co/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/letsencrypt.neight.co/privkey.pem;
        include /etc/letsencrypt/options-ssl-nginx.conf;
        ssl_trusted_certificate /etc/letsencrypt/live/letsencrypt.neight.co/chain.pem;
        ssl_stapling on;
        ssl_stapling_verify on;
    }
```
1. Paste it at the bottom of `sites-available/rails`
```
nano sites-available/rails
```


https://www.ssllabs.com/ssltest/analyze.html?d=letsencrypt.neight.co
