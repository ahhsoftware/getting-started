using GettingStarted.Blazor.Services;
using GettingStarted.DataServices.Bad.Models;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;

namespace GettingStarted.Blazor.Pages
{
    public partial class CustomersBad
    {
        [Inject]
        public IJSRuntime javascript { set; get; } = default!;

        private CustomerSaveInput? Input = null;

        private List<CustomersResult>? Customers;

        private bool Loading = false;

        private string? SaveError = null;

        private string? GridError = null;

        public int CurrentPage = 1;

        public int PageCount = 1;

        protected override async Task OnInitializedAsync()
        {
            Loading = true;
            await GetCustomersAsync(1);
            Loading = false;
        }

        private async Task GetCustomersAsync(int page)
        {
            GridError = null;

            var httpOutput = await new HttpService().Best<CustomersOutput>(new CustomersInput(10, 1));
            
            if (httpOutput.IsSuccess)
            {
                // We have to inspect the results to determine the output without return values

                var output = httpOutput.Data!;

                if (output.ResultData is not null && output.ResultData.Count != 0)
                {
                    Customers = output.ResultData;
                    PageCount = output.PageCount!.Value;
                }
                else
                {
                    Customers = new List<CustomersResult>();
                    PageCount = 1;
                }
            }
            else
            {
                GridError = httpOutput.ErrorResult;
            }  
        }

        private void InitSave(int customerId)
        {
            SaveError = null;

            if (customerId == 0)
            {
                // Since we don't have default values we have to do this manually

                Input = new CustomerSaveInput(0, null, null, null);
            }
            else
            {
                Input = Map(Customers!.FirstOrDefault(c => c.CustomerId == customerId)!);
            }
        }

        private async Task SaveAsync()
        {
            if (Input is not null)
            {
                var httpResult = await new HttpService().Bad<CustomerSaveOutput>(Input);
                if (httpResult.IsSuccess)
                {
                    var output = httpResult.Data;

                    if(Input.CustomerId != 0)
                    {
                        var existing = Customers!.FirstOrDefault(c => c.CustomerId == output.CustomerId!.Value)!;
                        existing.FirstName = Input!.FirstName!;
                        existing.LastName = Input!.LastName!;
                        existing.Email = Input!.Email!;
                        Input = null;
                    }
                    else
                    {
                        Customers!.Add(new CustomersResult(output.CustomerId!.Value, Input!.FirstName!, Input!.LastName!, Input!.Email!));
                    }
                }
                else
                {
                    SaveError = httpResult.ErrorResult;
                }
            }
        }

        private async Task DeleteAsync(int customerId)
        {
            var customer = Customers!.FirstOrDefault(c => c.CustomerId == customerId)!;

            JsService js = new JsService(javascript);
            if (await js.Confirm($"Delete customer {customer.FirstName} {customer.LastName}?"))
            {
                var http = new HttpService();
                var httpOutput = http.Best<CustomerDeleteOutput>(new CustomerDeleteInput(customerId));
                Customers!.Remove(customer);
                if (Customers.Count == 0)
                {
                    CurrentPage = CurrentPage == 1 ? CurrentPage : CurrentPage - 1;
                }

                await GetCustomersAsync(CurrentPage);
            }
        }

        private CustomerSaveInput Map(CustomersResult source)
        {
            return new CustomerSaveInput(source.CustomerId, source.FirstName, source.LastName, source.Email);
        }
    }
}