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

            var httpOutput = await new HttpService().Bad<CustomersOutput>(new CustomersInput(10, page));
            
            if (httpOutput.IsSuccess)
            {
                if(httpOutput.Data is not null)
                {
                    var resultOutput = httpOutput.Data!;

                    if (resultOutput.ResultData is not null)
                    {
                        Customers = resultOutput.ResultData;
                        PageCount = resultOutput.PageCount!.Value;
                        CurrentPage = page;
                    }
                    else
                    {
                        Customers = new List<CustomersResult>();
                        PageCount = 1;
                        CurrentPage = 1;
                    }
                }
            }
            else
            {
                GridError = httpOutput.ErrorResult;
            }  
        }

        private void InitSave(int customerId)
        {
            if (customerId == 0)
            {
                Input = new CustomerSaveInput(0, null, null, null);
            }
            else
            {
                Input = Map(Customers!.FirstOrDefault(c => c.CustomerId == customerId)!);
            }

            SaveError = null;
        }

        private async Task SaveAsync()
        {
            SaveError = null;

            if (Input is not null)
            {
                var httpResult = await new HttpService().Bad<CustomerSaveOutput>(Input);
                
                if (httpResult.IsSuccess)
                {
                    if(httpResult.Data is not null)
                    {
                        var output = httpResult.Data;

                        if (Input.CustomerId != 0)
                        {
                            var existing = Customers!.FirstOrDefault(c => c.CustomerId == output.CustomerId!.Value)!;
                            existing.FirstName = Input!.FirstName!;
                            existing.LastName = Input!.LastName!;
                            existing.Email = Input!.Email!;
                        }
                        else
                        {
                            Customers!.Add(new CustomersResult(output.CustomerId!.Value, Input!.FirstName!, Input!.LastName!, Input!.Email!));
                        }

                        Input = null;
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
                
                var httpOutput = await http.Bad<CustomerDeleteOutput>(new CustomerDeleteInput(customerId));

                if (httpOutput.IsSuccess)
                {
                    Customers!.Remove(customer);

                    if (Customers.Count == 0)
                    {
                        CurrentPage = CurrentPage == 1 ? CurrentPage : CurrentPage - 1;
                    }

                    await GetCustomersAsync(CurrentPage);
                }
                else
                {
                    await js.Alert(httpOutput.ErrorResult!);
                }
            }
        }

        private CustomerSaveInput Map(CustomersResult source)
        {
            return new CustomerSaveInput(source.CustomerId, source.LastName, source.FirstName, source.Email);
        }
    }
}