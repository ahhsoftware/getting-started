// See https://aka.ms/new-console-template for more information

using FirstService.dbo;
using FirstService.dbo.Models;

var service = new Service("server=(local); initial catalog=gettingstarted; integrated security=true");

var input = new CustomerInsertInput(1, "alan", "hyneman", "alan@sqlplus.net");
var output = service.CustomerInsert(input);

Console.WriteLine(output.CustomerId);

