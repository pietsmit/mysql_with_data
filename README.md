# mysql_with_data

## Overview

This image extends the [offical MySQL image](https://registry.hub.docker.com/_/mysql/), but gives you the following benefits:

1.      You can supply your own database / data at run time,
2.      Or you can create an image containing your own database / data.
2.      Your mysql data directory is in a separate image.*
4.      It opens up mysql on 0.0.0.0.*

\* Optional
## Quick start

You came here for this:
> docker run -e MYSQL_USER=dba -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=testdb -v $(pwd)/myschema.sql:/tmp/import_database.sql mysql_with_data

The following environment variables are from the official image:

- MYSQL_ROOT_PASSWORD=password
- MYSQL_USER=dba
- MYSQL_PASSWORD=password
- MYSQL_DATABASE=testdb

The volume parameter **-v $(pwd)/myschema.sql:/tmp/import_database.sql** will run the sql script myschema.sql on mysql startup. For best results, use the database defined in the MYSQL_DATABASE variable.

# Much more is possible if you use the included shell scripts:

The full project with scripts can be downloaded from [GitHub](https://github.com/pietsmit/mysql_with_data).

## Creating your own image containing a specific schema

Let's say that you have an database schema that is static and will be reused a lot. You can create an image for it in the following way:

1.      Replace the **import_database.sql** with your own schema. Note that the name will have to stay the same.
2.      Create a new image called mysql_with_data, containing your schema:
> docker **build** -t mysql_with_data .
3.      **./startMysqlWithVolume** myimagename

Behind the scenes, the following is happening.

1.      A **new volume** image, sharing */var/lib/myimagename* is created, with the name **dataimage_myimagename**.
2.      A **new container** is spinned up and down from this new image, and is called **myimagename_data**.
3.      A **different** container for mysql_with_data is started, **using the volume from the myimagename_data** container.

This means that after you stop and delete your mysql container, you can still attach a new container to the data by running:
> ./startMysqlWithVolume myimagename

again. You will explicitly have to remove the myimagename_data container to delete the data.

## Dynamically attaching a schema to a new instance

This section explains a helper script for the functionality in the *Quick start section*.
If you have a schema you want to spin up, without building an image, you can do that too.

1.      Copy your schema to this directory. We'll pretend that you have copied newstuffs.sql here.
2.      ./startDynamic my_vol_name newstuffs.sql

This will do everything that happened in the previous section, just with the schema you specified, without having to compile it. Edit the startDynamic to suit your needs.

## Environment variables added to the MySQL image

The following are new variables you can use:

1. DEV_ACCESS=true, explicitly opens up mysql to listen on 0.0.0.0
2. IMPORT_DB=true, imports the database included in the image at */tmp/import_database.sql*, or the file that is linked to that location from the host machine. For examples how this works, see the two shell scrip$
3. MYSQL_DIR=*/some/new/dir*, all the mysql database files will be created in this directory.



