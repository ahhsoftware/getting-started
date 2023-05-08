// See https://aka.ms/new-console-template for more information

using FirstService.dbo;
using FirstService.dbo.Models;
using System.ComponentModel.DataAnnotations;
using System.Reflection;

var service = new Service("server=(local); initial catalog=gettingstarted; integrated security=true");

var input = new CustomerInsertInput(1, "alan", "hyneman", "alan@sqlplus.net");

Console.WriteLine(input.GetType().GetProperty("FirstName")!.GetCustomAttributes<DisplayAttribute>().First().GetDescription());

var output = service.CustomerInsert(input);

Console.WriteLine(output.CustomerId);

