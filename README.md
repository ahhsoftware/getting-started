# Overview
This project is intended to illustrate using the services that the [SQL+ Code Generation Utility](https://marketplace.visualstudio.com/items?itemName=AHHSoftware.V4) creates.

## Prerequisites 
You should have Visual Studio 2022 and Sequel Server Management Studio. If you don't have these tools, they are available for free from Microsoft.

## Setup
1. Within the root folder there is a folder "SQLScripts" and nested in that folder is a "GettingStartedInstall.sql" file. Create a new database named "GettingStarted" and run the script using the newly created "GettingStarted" database as the target.
2. Connection Strings - There are connections strings in the applications that need to be editted to point to your instance of the "Getting Started" database.
    * GettingStarted.Web - edit the "appsettings.Development.json" file "ConnectionString" value.
    * GettingStarted.Tests - edit the connection strings at the top of each test class.
    * GettingStarted.Functions - edit the "local.settings.json" file "ConnectionString" value.
    
## The Fun Stuff
Within the database there are 3 schemas.
1. Good illustrates the minimum requirement to generate a service.
2. Better illustrates adding validation to parameters.
3. Best illustrated adding return values and display properties to tighten up the user experience.

## GettingStarted.Web
If you compare the pages within each of the folders Good, Better, and Best, you will notice that they are rearly identical. If you compare the database routines in the matching schemas, you will notice that the only differnce is the use of semantic tags. As you work through the various forms, try inserting invalid data, and notice the differences in how the forms handle validation.

## GettingStarted.Functions
Included in the solution folder is a series of postman collections. Launch the azure functions and you can use the postman collections to target the services. You should also have a look at how the functions execute. Since the [SQL+ Code Generation Utility](https://marketplace.visualstudio.com/items?itemName=AHHSoftware.V4) adheres to a predictable naming convention, it is straightforward to reflect those objects. Long story short, you can write a SQL routine, and have it included in your http endpoints with little or no effort, and you can trust those endpoints to handel your validation and still execute efficiently.

## GettingStarted.Blazor
This project uses the "GettingStarted.Functions" services so you need to run both projects simultaneously. Again, as with the "GettingStarted.Web" project, you will notice that the pages are nearly identical, while the behaviour is significantly different.
