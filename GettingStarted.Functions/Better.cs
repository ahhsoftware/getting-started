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
using GettingStarted.DataServices.Better.Models;

namespace GettingStarted.Functions
{
    public static class Better
    {
        private const string SERVICE_PROJECT = "GettingStarted.DataServices";
        private const string SERVICE_NAMESPACE = "GettingStarted.DataServices.Better";
        private static readonly Type serviceType = typeof(GettingStarted.DataServices.Better.Service);

        [FunctionName("Better")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = "v1/Better/{serviceName}")] HttpRequest req,
            string serviceName,
            ILogger log)
        {
            log.LogInformation("Called v1/Better/{serviceName}", serviceName);

            // TODO: Insert any security options here

            MethodInfo? method = serviceType.GetMethod(serviceName, BindingFlags.Public | BindingFlags.Instance);

            if (method == null)
            {
                return new NotFoundObjectResult($"Service not found: v1/Better/{serviceName}");
            }

            try
            {
                var parameters = method.GetParameters();

                if (parameters.Length != 0)
                {
                    string json = await req.ReadAsStringAsync();
                    return Execute(method, serviceName, json, log);
                }

                return new OkObjectResult(method.Invoke(ServiceFactory.BetterDataService, null));

            }
            catch (Exception ex)
            {
                /* In a production environment this would trigger some kind of incident handling. */

                log.LogError(ex.Message);

                return new BadRequestObjectResult(ex.Message);
            }
        }

        private static IActionResult Execute(MethodInfo method, string serviceName, string json, ILogger log)
        {
            if (string.IsNullOrEmpty(json))
            {
                return new BadRequestObjectResult("No json received for service input");
            }

            Type? inputType = Type.GetType($"{SERVICE_NAMESPACE}.Models.{serviceName}Input, {SERVICE_PROJECT}");
            if(inputType is null)
            {
                return new BadRequestObjectResult("Could not resolve type for service input");
            }

            var inputObject = Activator.CreateInstance(inputType);
            if (inputObject is null)
            {
                return new BadRequestObjectResult("Could not instantiate type for service input");
            }

            JsonConvert.PopulateObject(json, inputObject);

            if (((ValidInput)inputObject).IsValid())
            {
                try
                {
                    return new OkObjectResult(method.Invoke(ServiceFactory.BetterDataService, new object[] { inputObject }));
                }
                catch (Exception ex)
                {
                    /* In a production environment this would trigger some kind of incident handling. */

                    log.LogError(ex, "Error in {ServiceName}", serviceName);

                    if (ex.InnerException is not null)
                    {
                        return new BadRequestObjectResult(ex.InnerException.Message);
                    }
                    return new BadRequestObjectResult(ex.Message);
                }
            }
            else
            {
                return new BadRequestObjectResult(inputObject);
            }
        }
    }
}
