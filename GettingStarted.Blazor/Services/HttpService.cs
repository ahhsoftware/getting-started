using System.ComponentModel;
using System.Text.Json;
using static System.Net.WebRequestMethods;

namespace GettingStarted.Blazor.Services
{
    public class HttpService
    {
        protected readonly HttpClient client;

        public HttpService()
        {
            this.client = new HttpClient();
            client.BaseAddress = new Uri("http://localhost:7293");
        }

        public async Task<HttpResult<T>> Bad<T>(object? input = null)
        {
            string serviceName = typeof(T).Name.Replace("Output", "");
            return await (PostAsync<T>($"/api/v1/bad/{serviceName}", input));
        }

        public async Task<HttpResult<T>> Default<T>(object? input = null)
        {
            string serviceName = typeof(T).Name.Replace("Output", "");
            return await (PostAsync<T>($"/api/v1/Default/{serviceName}", input));
        }

        private async Task<HttpResult<T>> PostAsync<T>(string urlFragment, object? obj)
        {
            var result = new HttpResult<T>();
            
            try
            {
                var response = await client.PostAsync(urlFragment, GetStringContent(obj));
                await ProcessResult(response, result);
            }
            catch (Exception ex)
            {
                result.StatusCode = System.Net.HttpStatusCode.NotFound;
                result.ErrorResult = ex.Message;
            }

            return result;
        }

        private async Task ProcessResult<T>(HttpResponseMessage response, HttpResult<T> result)
        {
            result.StatusCode = response.StatusCode;
            
            string data = await response.Content.ReadAsStringAsync();

            if (result.IsSuccess)
            {
                if (string.IsNullOrEmpty(data))
                {
                    result.Data = default;
                }
                else
                {
                    try
                    {
                        if (typeof(T).IsValueType || typeof(T) == typeof(string))
                        {
                            result.Data = Convert<T>(data);
                        }
                        else
                        {
                            result.Data = JsonSerializer.Deserialize<T>(data, options);
                        }
                    }
                    catch (Exception ex)
                    {
                        result.ErrorResult = $"The call succeed with an HttpStatusCode {result.StatusCode} but an error occured consuming the result with the following exception: {ex}";
                    }
                }
            }
            else
            {
                if (result.StatusCode == System.Net.HttpStatusCode.Unauthorized)
                {
                    result.ErrorResult = "Access Denied";
                }
                else
                {
                    if (string.IsNullOrEmpty(data))
                    {
                        result.ErrorResult = "The call results in an error status but no additional information is available.";
                    }
                    else
                    {
                        result.ErrorResult = data;
                    }
                }
            }
        }

        private T? Convert<T>(string input)
        {
            TypeConverter? typeConverter = TypeDescriptor.GetConverter(typeof(T));
            
            if (typeConverter != null)
            {
                return (T?)typeConverter.ConvertFromString(input);
            }

            return default;
        }

        private StringContent GetStringContent(Object? obj)
        {
            if(obj is null)
            {
                return new StringContent("{}", System.Text.Encoding.UTF8, "application/json");
            }

            return new StringContent(JsonSerializer.Serialize(obj), System.Text.Encoding.UTF8, "application/json");
        }

        private readonly JsonSerializerOptions options = new JsonSerializerOptions()
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        };
    }
}
