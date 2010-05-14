server {
	listen 80;
	server_name example.com;

	access_log /var/www/sites/example.com/shared/logs/nginx.access.log;
	error_log /var/www/sites/example.com/shared/logs/nginx.error.log;

	root /var/www/sites/example.com/current/public;

	# If file is an asset, set expires and break
	location ~* \.(ico|css|js|gif|jpe?g|png)(\?[0-9]+)?$ {
		expires max;
		break;
	}

	# Serve the directoy/file if it exists, else pass to CodeIgniter front controller
	location / {
		try_files $uri @codeigniter;
	}

	# Do not allow direct access to the CodeIgniter front controller
	location ~* ^/index.php {
		rewrite ^/index.php/?(.*)$ /$1 permanent;
	}

	# CodeIgniter Front Controller
	location @codeigniter {
		internal;
		root /var/www/sites/example.com/current/public;
		fastcgi_pass 127.0.0.1:9000;
		fastcgi_index index.php;
		include fastcgi_config;
		include fastcgi_params;
		fastcgi_param SCRIPT_FILENAME /var/www/sites/example.com/current/public/index.php;
	}

	# If directly accessing a PHP file in the public dir other than index.php
	location ~* \.php$ {
		root /var/www/sites/example.com/current/public;
		try_files $uri @codeigniter;
		fastcgi_pass 127.0.0.1:9000;
		fastcgi_index index.php;
		include fastcgi_config;
		include fastcgi_params;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
	}
}