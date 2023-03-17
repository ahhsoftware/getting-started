using GettingStarted.Blazor.Services;
using GettingStarted.DataServices.Best.Models;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;

namespace GettingStarted.Blazor.Pages
{
    public partial class CustomersBest
    {
        [Inject]
        public IJSRuntime javascript { set; get; } = default!;

        private CustomerSaveInput? Input = null;

        private List<CustomersResult>? Customers;

        public bool Loading = false;

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

            var httpOutput = await new HttpService().Best<CustomersOutput>(new CustomersInput(10, page));

            if (httpOutput.IsSuccess)
            {
                // Compare this with the bad and better method to see how enumerated returns work

                var output = httpOutput.Data!;

                if (output.ReturnValue == CustomersOutput.Returns.Ok)
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
                // Notice how the use of default values make this straightforward

                Input = new CustomerSaveInput();
            }
            else
            {
                Input = Map(Customers!.FirstOrDefault(c => c.CustomerId == customerId)!);
            }
        }

        private async Task SaveAsync()
        {
            SaveError = null;

            if (Input is not null)
            {
                var httpResult = await new HttpService().Best<CustomerSaveOutput>(Input);

                if (httpResult.IsSuccess)
                {
                    // Notice how the return values are utilized to determine the exact outcome of a call.

                    var output = httpResult.Data!;

                    switch (output.ReturnValue)
                    {
                        case CustomerSaveOutput.Returns.Inserted:
                            Customers!.Add(new CustomersResult(output.CustomerId!.Value, Input!.FirstName!, Input!.LastName!, Input!.Email!));
                            Input = null;
                            break;

                        case CustomerSaveOutput.Returns.Modified:
                            var existing = Customers!.FirstOrDefault(c => c.CustomerId == output.CustomerId!.Value)!;
                            existing.FirstName = Input!.FirstName!;
                            existing.LastName = Input!.LastName!;
                            existing.Email = Input!.Email!;
                            Input = null;
                            break;

                        case CustomerSaveOutput.Returns.Duplicate:
                            SaveError = "A customer with that email already exists";
                            break;

                        case CustomerSaveOutput.Returns.NotFound:
                            SaveError = "This customer no longer exists. It may have been deleted by another user.";
                            break;
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

                var httpOutput = await http.Best<CustomerDeleteOutput>(new CustomerDeleteInput(customerId));
                
                if(httpOutput.IsSuccess)
                {
                    var output = httpOutput.Data!;

                    if(output.ReturnValue == CustomerDeleteOutput.Returns.NotFound)
                    {
                        await js.Alert("Could not delete customer, the customer no longer exists");
                    }

                    Customers!.Remove(customer);
                    
                    if (Customers.Count == 0)
                    {
                        CurrentPage = CurrentPage == 1 ? CurrentPage : CurrentPage - 1;
                    }

                }
                
                await GetCustomersAsync(CurrentPage);
            }
        }

        private CustomerSaveInput Map(CustomersResult source)
        {
            return new CustomerSaveInput(source.CustomerId, source.LastName, source.FirstName, source.Email);
        }
    }
}
