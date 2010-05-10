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

Start in the base folder of the CodeIgniter install, with the following default structure:

	index.php
	license.txt
	system/
		application/
	user_guide/

Create a "public" folder

Move index.php into the public folder

Create an "assets" folder in the public folder. _Stick all your CSS, JS and images into this folder_

Move the system/application folder outside of the system folder

Our folder structure should now look like this:
	application/
	license.txt
	public/
		assets/
		index.php
	system/
	user_guide/

Now to update the CodeIgniter config:

public/index.php
-----------------
	...
	/*
	|---------------------------------------------------------------
	| SYSTEM FOLDER NAME
	|---------------------------------------------------------------
	|
	| This variable must contain the name of your "system" folder.
	| Include the path if the folder is not in the same  directory
	| as this file.
	|
	| NO TRAILING SLASH!
	|
	*/
		$system_folder = "../system";

	/*
	|---------------------------------------------------------------
	| APPLICATION FOLDER NAME
	|---------------------------------------------------------------
	|
	| If you want this front controller to use a different "application"
	| folder then the default one you can set its name here. The folder 
	| can also be renamed or relocated anywhere on your server.
	| For more info please see the user guide:
	| http://codeigniter.com/user_guide/general/managing_apps.html
	|
	|
	| NO TRAILING SLASH!
	|
	*/
		$application_folder = "../application";
	...