using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using SqlPlusBase;
using System;
using System.Reflection;
using System.Threading.Tasks;

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
            log.LogInformation("Called v1/admin/{serviceName}", serviceName);

            MethodInfo? method = serviceType.GetMethod(serviceName, BindingFlags.Public | BindingFlags.Instance);

            if (method == null)
            {
                return new NotFoundObjectResult($"Service not found: v1/admin/{serviceName}");
            }

            try
            {
                var parameters = method.GetParameters();

                if (parameters.Length != 0)
                {
                    string json = await req.ReadAsStringAsync();
                    return Execute(method, serviceName, ServiceFactory.BestDataService, json, log);
                }

                return Execute(method, serviceName);

            }
            catch (Exception ex)
            {
                log.LogError(ex.Message);
                return new BadRequestObjectResult(ex.Message);
            }
        }

        private static IActionResult Execute(MethodInfo method, string serviceName)
        {
            return new OkObjectResult(method.Invoke(ServiceFactory.BestDataService, null));
        }

        private static IActionResult Execute(MethodInfo method, string serviceName, GettingStarted.DataServices.Best.Service service, string json, ILogger log)
        {
            Type inputType = Type.GetType($"{SERVICE_NAMESPACE}.Models.{serviceName}Input, {SERVICE_PROJECT}")!;
            if(inputType is null)
            {
                return new BadRequestObjectResult("Could not resolve type for service input");
            }

            var inputObject = Activator.CreateInstance(inputType);
            if(inputObject is null)
            {
                return new BadRequestObjectResult("Could not instantiate type for service input");
            }

            if (((ValidInput)inputObject).IsValid() == false)
            {
                return new BadRequestObjectResult(inputObject);
            }

            return new OkObjectResult(method.Invoke(service, new object[] { inputObject }));
        }
    }
}
