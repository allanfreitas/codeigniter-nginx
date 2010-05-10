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

	# Serve the directoy/file if it exists, else pass to CodeIgniter index.php
	location / {
		try_files $uri @codeigniter;
	}

	# Do not allow direct access of the CodeIgniter front controller
	location = /index.php {
		rewrite ^(.*)$ / permanent;
	}

	# CodeIgniter Front Controller
	location @codeigniter {
		internal;
		root /var/www/sites/example.com/current/public;
		fastcgi_pass 127.0.0.1:9000;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME /var/www/sites/example.com/current/public/index.php;
		fastcgi_split_path_info ^(.+\.php)(.*)$;
		fastcgi_param	 PATH_INFO $fastcgi_path_info;
		include fastcgi_params;
	}

	# If directly accessing a PHP file in the public dir other than index.php
	location ~ \.php$ {
		root /var/www/sites/example.com/current/public;
		try_files $uri @codeigniter;
		fastcgi_pass 127.0.0.1:9000;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		include fastcgi_params;
	}
}