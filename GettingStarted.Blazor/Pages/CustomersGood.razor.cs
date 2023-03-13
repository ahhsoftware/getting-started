using GettingStarted.Blazor.Services;
using GettingStarted.DataServices.Good.Models;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;

namespace GettingStarted.Blazor.Pages
{
    public partial class CustomersGood
    {
        [Inject]
        public IJSRuntime javascript { set; get; } = default!;

        private CustomerInsertInput? Insert = null;
        
        private CustomerUpdateInput? Update = null;

        private List<CustomersResult>? Customers;

        public bool Loading = false;

        private string? InsertError = null;
        private string? UpdateError = null;

        protected override async Task OnInitializedAsync()
        {
            Loading = true;

            var httpOutput = await new HttpService().Good<CustomersOutput>();
            if (httpOutput.IsSuccess)
            {
                var result = httpOutput.Data!;
                if(result.ResultData is not null)
                {
                    Customers = httpOutput.Data!.ResultData;
                }
                else
                {
                    Customers = new List<CustomersResult>();
                }
            }
            Loading = false;
        }

        private void InitInsert()
        {
            Insert = new CustomerInsertInput();
            InsertError = null;
        }

        private async Task InsertSaveAsync()
        {
            if(Insert is not null)
            {
                var httpResult = await new HttpService().Good<CustomerInsertOutput>(Insert);
                if (httpResult.IsSuccess)
                {
                    if(httpResult.Data is not null && httpResult.Data.CustomerId.HasValue)
                    {
                        var customer = new CustomersResult(httpResult.Data.CustomerId.Value, Insert.FirstName!, Insert.LastName!, Insert.Email!);
                        Customers!.Add(customer);
                        Insert = null;
                    }
                }
                else
                {
                    InsertError = httpResult.ErrorResult;
                }
            }
        }

        private void InitUpdate(int customerId)
        {
            Update = Map(Customers!.FirstOrDefault(c => c.CustomerId == customerId)!);
            UpdateError = null;
        }

        private async Task UpdateSaveAsync()
        {
            var httpResult = await new HttpService().Good<CustomerUpdateOutput>(Update);
            if(httpResult.IsSuccess)
            {
                var existing = Customers!.FirstOrDefault(c => c.CustomerId == Update!.CustomerId);
                
                if(existing is null)
                {
                    Customers!.Add(new CustomersResult(Update!.CustomerId!.Value, Update!.FirstName!, Update!.LastName!, Update!.Email!));
                }
                else
                {
                    existing.FirstName = Update!.FirstName!;
                    existing.LastName = Update!.LastName!;
                    existing.Email = Update!.Email!;
                    
                    Update = null;
                }
            }
            else
            {
                UpdateError = httpResult.ErrorResult;
            }
        }

        
        private async Task DeleteAsync(int customerId)
        {
            var customer = Customers!.FirstOrDefault(c => c.CustomerId == customerId)!;

            JsService js = new JsService(javascript);
            if (await js.Confirm($"Delete customer {customer.FirstName} {customer.LastName}?"))
            {
                var http = new HttpService();
                var httpOutput = await http.Good<CustomerDeleteOutput>(new CustomerDeleteInput(customerId));
                Customers!.Remove(customer);
            }
        }

        private CustomerUpdateInput Map(CustomersResult source)
        {
            return new CustomerUpdateInput(source.CustomerId, source.FirstName, source.LastName, source.Email);
        }
        
    }
}
