# Overview
This project is intended to illustrate using the services that the SQL+ Code Generation Utility Creates.

## Prerequisites 
You should have Visual Studio 2022 and Sequel Server Management Studio. If you don't have these tools, they are available for free from Microsoft.

## Setup
1. Within the root folder there is a folder "SQLScripts" and nested in that folder is a "GettingStartedInstall.sql" file. Create a new database named "GettingStarted" and run the script using the newly created "GettingStarted" database as the target.
2. Connection Strings - There are connections strings in the applications that need to be editted to point to your instance of the "Getting Started" database.
    * GettingStarted.Web - edit the appsettings.Development.json "ConnectionString"
    
