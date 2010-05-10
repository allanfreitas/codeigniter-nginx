CodeIgniter Nginx Configuration
--------------------------------
This setup adds a little bit more security by sharing only the index.php front controller on the web.

The reason for the "shared" and "current" folders is because I use [Capistrano](www.capify.org) for deployment.
The "current" folder contains the latest deployed code.
The "shared" folder contains logs that persist between deployments.
I symlink the "current/system/logs/" folder into the "shared/logs/" folder.

To keep this brief I have skipped explaining my full Capistrano and dynamic assets setup.
For a basic CodeIgniter app this should do the job.

Instructions
-------------
First we need to make the following changes to our CodeIgniter folder structure:

Start in the base folder of the CodeIgniter install:

	cd /path/to/your/codeigniter/folder/

The default structure looks like this:

	index.php
	license.txt
	system/
		application/
	user_guide/

Create a "public" folder

	mkdir public

Move index.php into the public folder

	mv index.php public/

Create an "assets" folder in the public folder. _Put all your CSS, JS and images into this folder_

	mkdir public/assets

Move the system/application folder outside of the system folder

	mv system/application/ application

Our folder structure should now look like this:

	application/
	license.txt
	public/
		assets/
		index.php
	system/
	user_guide/

Update folder paths
--------------------
Open the CodeIgniter front controller

	nano public/index.php

Make the following changes:

	$system_folder = "../system";
	$application_folder = "../application";