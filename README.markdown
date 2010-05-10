CodeIgniter Nginx Configuration
--------------------------------
This setup has 2 goals in mind:

* **Security**: Share only the index.php front controller on the web, not the entire source code and configs.  
* **Easy Updates**: Updating the CodeIgniter core code is just a matter of replacing the "system" folder.
    * _It's unlikely that CodeIgniter's index.php file will change, but keep an eye on it_

### Assumptions ###

* Web sites are stored in `/var/www/sites/`
* The domain name is "example.com"
* The OS in use is Ubuntu 8.04.3 LTS

_Adjust the instructions below accordingly_

### `current` & `shared` Folders Explained ###
The folder structure used is as follows:

	var/
		www/
			sites/
				example.com/
					current/
						application/
						public/
						system/
					shared/
						logs/

The reason for the shared & current folders is because I use [Capistrano](http://www.capify.org) for deployment. However, having a current and shared folder is still beneficial if you are not using Capistrano. The reasons being:

* You can keep your nginx logs, CodeIgniter logs, and any other logs relating to each site in their own `shared/logs` folder.
* When updating CodeIgniter, you can just delete the `system` folder and copy a new one in its place without worry of deleting log files.
* If you are storing files uploaded by users it's safer to store them in the `shared` folder, to avoid accidental deletions during updates to anything in the `current` folder.

Simply put, `current` is for code and `shared` is for anything created by the code/server.

For the above to work, I symlink `/var/www/sites/example.com/current/system/logs/` to `/var/www/sites/example.com/shared/logs/`, which is explained below.

Instructions
-------------
### Setup ###
First we need to setup our folder structure:

	sudo mkdir -p /var/www/sites/example.com/{current,shared}

Now copy your CodeIgniter files into `/var/www/sites/example.com/current/`

Let's work in the `current` folder and list the files within:

	cd /var/www/sites/example.com/current/
	ls -ahl

You should see a folder structure like this:

	index.php
	license.txt
	system/
		application/
	user_guide/

### New Folder Structure ###
Create a `public` folder:

	mkdir public

Move index.php into the `public` folder:

	mv index.php public/

Create an `assets` folder in the `public` folder:  
_Put all your CSS, JS and images into this folder_

	mkdir public/assets

Move the `system/application` folder outside of the `system` folder:

	mv system/application/ application

Our folder structure should now look like this:

	application/
	license.txt
	public/
		assets/
		index.php
	system/
	user_guide/

### CodeIgniter paths ###
Edit the CodeIgniter front controller:

	nano public/index.php

Make the following changes:

	$system_folder = "../system";
	$application_folder = "../application";

Edit your application config:

	nano application/config/config.php

Make the following changes:

	$config['uri\_protocol'] = "PATH_INFO";

### Symlink logs ###
First move the `system/logs` folder and remove the `index.html` file since we don't need it:  
_In fact, we don't need any of the index.html files spread across the CodeIgniter code, since none of the folders are made public, but it's not worth the effort to remove them all_

	mv system/logs ../shared/logs
	rm ../shared/logs/index.html

Now create the symlink:

	ln -nfs /var/www/sites/example.com/shared/logs/ /var/www/sites/example.com/current/system/

Note that if you delete the `system` folder during an update you must create the `system/logs` symlink again.