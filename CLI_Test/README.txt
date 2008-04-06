README file for the CLI_Test application.


OVERVIEW:

1. What CLI_Test is doing?
2. How to install CLI_Test?
 2.a Prerequisite
 2.b Building
3. Running CLI_Test
 3.a Checking the MySQL server
 3.b Checking CLI_Test runs everywhere...
4. What CLI_Test is NOT doing
5. Troubleshooting
 5.a ranlib...
 5.b other...

I've tried to make it short, so that you can read it completly... please read before sending messages!!

*****************************************************************************
1. What CLI_Test is doing?

CLI_Test is a small Objective-C application using SMySQL or SMySQL_static frameworks, together with Foundation framework, to run very simple requests to an existing MySQL DB server.

The purpose of the application is to be both an easy example of how one can use SMySQL even in a Foundation tool (a CLI application using Foundation frameworks WITHOUT AppKit), and to be a small testing program which enable the user of the SMySQL framework to check how the installation of the framework itself.

For simplicity the CLI_Test application is using a MySQL server  running on the local computer (localhost), on the standard port. It also assumes a standard user login and password, as well as the name of the DB and the table to "explore" (see 2.a to know more about that).

*****************************************************************************
2. How to install CLI_Test?

2.a Prerequisite
The application is trying to connect to a MySQL DB server running on the localhost. It uses the following parameters:
user login : ObjC
user password : MySQL_class
DB name : test_mysqlclass
table name : test1

The only prerequisite is to have a MySQL DB server running on localhost. This server should have a correct user, DB, table (according to the above info). If you have administrative right on the DB server, you can use the Make_DB_and_table.mysql script to generate the proper user, DB and table. To do that, open a terminal, cd to the CLI_Test source directory and issue the command:

mysql -u root -p < Make_DB_and_table.mysql

You will be asked the MySQL root password (which is NOT the system root password, see documentation of MySQL for further details).
You need the MySQL root privileges in order to be able to make a new user, and possibly a new database.


2.b Building
To build the CLI_Test application you just need to open the SMySQL.pbproj project in ProjectBuilder, then select CLI_Test as target and build the target. Project builder will then check that SMySQL_static is build (if it is not, it will build it) and then start to compile and link CLI_Test.
By default the Development build style is selected, but the program should run equally well when using any of the other build styles.

Finally, the CLI_Test application is by default using the SMySQL_static of the framework, but you can also try to use the SMySQL version of the framework. To test that first check that the current selected target is CLI_Test, then in the Files tab open the Products group and uncheck SMySQL_static.framework and check SMySQL.framework; then go in the target tab, open the disclosure triangle on the left of CLI-Test target, select SMySQL_static and press delete and drag in the SMySQL target (to be sure that SMySQL.framework will be build when required by CLI_Test).

*****************************************************************************
3. Running CLI_Test

3.a Checking the MySQL server:
First you have to make sure that a MySQL DB server is running on the localhost, and that it has a proper user, DB, table (see 2.a).
An easy way to check that is to issue the following command in a terminal window:
% mysql -u ObjC -pMySQL_class test_mysqlclass

Then on the mysql prompt type:
> select * from test1;
> select  test1_id, test1_name, test1_desc from test1;

This should produce some kind of tables, if you have used the Make_DB_and_table.mysql to produce the DB and table the second table should look very similar to (the first is the same with one more column, which is more than a line long...):

+----------+------------+-------------------------------------+
| test1_id | test1_name | test1_desc                          |
+----------+------------+-------------------------------------+
|        1 | first      | first entry in the table            |
|        2 | second     | second entry in the table           |
|        3 | third      | third, and last, entry in the table |
+----------+------------+-------------------------------------+
3 rows in set (0.00 sec)


3.b Checking CLI_Test runs everywhere...
You can first check that CLI_Test is running Ok in Project Builder by selecting the CLI_Test target and then the menu Build->Build and Run.
This should output the content of the test1 table.

Then the next thing you want to verify is that the framework and the CLI_Test can be moved around (with certain restriction for the framework) without breaking the CLI_Test application:

- Move the SMySQL_static framework into any of the Library directory (/Library of ~/Library for example), be sure to remove the one present in the build directory.
- run CLI_Test from the command line.

if this works (and it should), then you can try to move CLI_Test itself anywhere out of the build directory, and run it... it should still be able to run.


*****************************************************************************
4. What CLI_Test is NOT doing

As it is CLI_Test is not able to connect to a randomly chosen MySQL server, for that you have to modify the sources (and indeed I recommend you try to make a copy of the sources and pllay with those...).

CLI_Test is not running the MySQL server by itself... before trying to run it make sure that the MySQL server IS RUNNING on your machine (3.a).

CLI_Test is not a bundle application but a simple executable (a command line program in UNIX language, or a tool in Apple developer language). Because of that has no choice but to rely on a system-wide version of the SMySQL framework (these are defined in the SMySQL and SMySQL_static targets of the PB project). It is not possible to use CLI_Test to verify (or play with) the SMySQL_bundled version of the framework.


*****************************************************************************
5. Troubleshooting

5.a ranlib...
SMySQL_static relies on the static library libmysqlclient.a which is in mysql_bins subfolder. It is likely that the first time you'll try to build this version of the framework (or the SMySQL_bundled framework, which relies on the same library) you get an error message in the link phase:

ld: table of contents for archive: mysql_bins/libmysqlclient.a is out of date; rerun ranlib(1) (can't load from it)

It is normal to get this message, and very easy to fix it, you just need to do what gcc ask you to:
Go in the mysql_bins subfolder (in a terminal), and run ranlib on the library:

% ranlib libmysqlclient.a

You should then be able to build the framework(s) and then CLI_Test.


5.b other...
If you are experiencing any problem with CLI_Test (and that you have make sure that this file can NOT provide you with any help), I'd be pleased to try and help you. Mail me at :
sergecohen@users.sourceforge.net.

