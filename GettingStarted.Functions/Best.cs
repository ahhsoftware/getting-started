using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using SqlPlusBase;
using System;
using System.Reflection;
using System.Threading.Tasks;
using GettingStarted.DataServices.Best.Models;

namespace GettingStarted.Functions
{
    public static class Best
    {
        private const string SERVICE_PROJECT = "GettingStarted.DataServices";
        private const string SERVICE_NAMESPACE = "GettingStarted.DataServices.Best";
        private static readonly Type serviceType = typeof(GettingStarted.DataServices.Best.Service);

        [FunctionName("Best")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = "v1/Best/{serviceName}")] HttpRequest req,
            string serviceName,
            ILogger log)
        {
            log.LogInformation("Called v1/Best/{serviceName}", serviceName);

            // TODO: Insert any security options here

            MethodInfo? method = serviceType.GetMethod(serviceName, BindingFlags.Public | BindingFlags.Instance);

            if (method == null)
            {
                return new NotFoundObjectResult($"Service not found: v1/Best/{serviceName}");
            }

            try
            {
                var parameters = method.GetParameters();

                if (parameters.Length != 0)
                {
                    string json = await req.ReadAsStringAsync();
                    return Execute(method, serviceName, json, log);
                }

                return new OkObjectResult(method.Invoke(ServiceFactory.BestDataService, null));

            }
            catch (Exception ex)
            {
                // NOTE: We would never return a raw exception in a production environment.

                log.LogError(ex.Message);
                return new BadRequestObjectResult(ex.Message);
            }
        }

        private static IActionResult Execute(MethodInfo method, string serviceName, string json, ILogger log)
        {
            if(string.IsNullOrEmpty(json))
            {
                return new BadRequestObjectResult("No json received for service input");
            }

            Type? inputType = Type.GetType($"{SERVICE_NAMESPACE}.Models.{serviceName}Input, {SERVICE_PROJECT}");
            
            if(inputType is null)
            {
                return new BadRequestObjectResult("Could not resolve type for service input");
            }

            var inputObject = Activator.CreateInstance(inputType);
            if(inputObject is null)
            {
                return new BadRequestObjectResult("Could not instantiate type for service input");
            }

            JsonConvert.PopulateObject(json, inputObject);

            return ((ValidInput)inputObject).IsValid() ? new OkObjectResult(method.Invoke(ServiceFactory.BestDataService, new object[] { inputObject })) : new BadRequestObjectResult(inputObject);
        }
    }
}
