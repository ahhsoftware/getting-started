using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Reflection;
using SqlPlusBase;

namespace GettingStarted.Functions
{
    public static class Good
    {
        private const string SERVICE_PROJECT = "GettingStarted.DataServices";
        private const string SERVICE_NAMESPACE = "GettingStarted.DataServices.Good";
        private static readonly Type serviceType = typeof(GettingStarted.DataServices.Good.Service);

        [FunctionName("Good")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = "v1/good/{serviceName}")] HttpRequest req,
            string serviceName,
            ILogger log)
        {
            log.LogInformation("Called v1/admin/{serviceName}", serviceName);

            MethodInfo? method = serviceType.GetMethod(serviceName, BindingFlags.Public | BindingFlags.Instance);

            if (method == null)
            {
                return new NotFoundObjectResult($"Service not found: v1/admin/{serviceName}");
            }

            string json = await req.ReadAsStringAsync();

            try
            {
                return Execute(method, serviceName, ServiceFactory.GoodDataService, json, log);
            }
            catch (Exception ex)
            {
                log.LogError(ex.Message);
                return new BadRequestObjectResult(ex.Message);
            }
        }

        private static IActionResult Execute(MethodInfo method, string serviceName, GettingStarted.DataServices.Good.Service service, string json, ILogger log)
        {
            object? result = null;
            var parameters = method.GetParameters();
            if (parameters.Length != 0)
            {
                var input = GetInputObject(serviceName, json);
                if (((ValidInput)input).IsValid() == false)
                {
                    return new BadRequestObjectResult(input);
                }

                result = method.Invoke(service, new object[] { input });
            }
            else
            {
                result = service.Customers();// method.Invoke(service, null);
            }

            return new OkObjectResult(result);
        }

        private static object GetInputObject(string serviceName, string json)
        {
            Type inputType = Type.GetType($"{SERVICE_NAMESPACE}.Models.{serviceName}Input, {SERVICE_PROJECT}")!;
            var input = Activator.CreateInstance(inputType);
            JsonConvert.PopulateObject(json, input);
            return input!;
        }

    }
}
