# Overview
This project is intended to illustrate using the services that the [SQL+ Code Generation Utility](https://marketplace.visualstudio.com/items?itemName=AHHSoftware.V4) creates.

For full documentation and to learn more about SQL+ visit us at www.sqlplus.net

## Prerequisites 
You should have Visual Studio 2022 and Sequel Server Management Studio. If you don't have these tools, they are available for free from Microsoft.

## Setup
1. Within the root folder there is a folder "SQLScripts" and nested in that folder is a "GettingStartedInstall.sql" file. Create a new database named "GettingStarted" and run the script using the newly created "GettingStarted" database as the target.
2. Connection Strings - There are connections strings in the applications that need to be edited to point to your instance of the "Getting Started" database.
    * GettingStarted.Web - edit the "appsettings.Development.json" file "ConnectionString" value.
    * GettingStarted.Tests - edit the connection in the TestHelpers.cs file.
    * GettingStarted.Functions - edit the "local.settings.json" file "ConnectionString" value.
    
## GettingStarted.Web
Set the start up project to the GettingStarted.Web project and run the project in Visual Studio
Try inserting invalid data, and notice how the UI enforces the validation.

## GettingStarted.Functions
Included in the solution folder is a postman collections. Launch the azure functions app and you can use the postman collections to target the services. You should also have a look at how the functions execute. Since the [SQL+ Code Generation Utility](https://marketplace.visualstudio.com/items?itemName=AHHSoftware.V4) adheres to a predictable naming convention, it is straightforward to reflect those objects. Long story short, you can write a SQL routine, and have it included in your http endpoints with little or no effort, and you can trust those endpoints to handle your validation gracefully.

## GettingStarted.Blazor
This project uses the "GettingStarted.Functions" services so you need to run both projects simultaneously. Again, as with the "GettingStarted.Web" project, try inserting invalid data, and notice how the UI enforces the validation.

Feel free to explore the code and enjoy!
