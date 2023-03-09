using GettingStarted.Blazor.Services;
using GettingStarted.DataServices.Best.Models;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;

namespace GettingStarted.Blazor.Pages
{
    public partial class CustomersBlazored
    {
        [Inject]
        public IJSRuntime javascript { set; get; } = default!;

        private CustomerSaveInput? Input = null;

        private List<CustomersResult>? Customers;

        public bool Loading = false;

        private string? InputError = null;

        private string? GridError = null;

        public int CurrentPage = 1;

        public int PageCount = 1;

        protected override async Task OnInitializedAsync()
        {
            Loading = true;
            GridError = null;

            var httpOutput = await new HttpService().Best<CustomersOutput>(new CustomersInput(10, 1));
            if (httpOutput.IsSuccess)
            {
                var output = httpOutput.Data!;
                if (output.ReturnValue == CustomersOutput.Returns.NoRecords)
                {
                    Customers = new List<CustomersResult>();
                }
                if (output.ReturnValue == CustomersOutput.Returns.Ok)
                {
                    Customers = output.ResultData;
                    PageCount = output.PageCount!.Value;
                }
            }
            else
            {
                GridError = httpOutput.ErrorResult;
            }
            Loading = false;
        }

        private async Task OnPageAsync(int page)
        {
            var httpOutput = await new HttpService().Best<CustomersOutput>(new CustomersInput(10, page));

            if (httpOutput.IsSuccess)
            {
                var output = httpOutput.Data!;
                if (output.ReturnValue == CustomersOutput.Returns.NoRecords)
                {
                    Customers = new List<CustomersResult>();
                }
                if (output.ReturnValue == CustomersOutput.Returns.Ok)
                {
                    Customers = output.ResultData;
                    PageCount = output.PageCount!.Value;
                    CurrentPage = page;
                }
            }
            else
            {
                GridError = httpOutput.ErrorResult;
            }
        }
        private void InitInsert()
        {
            Input = new CustomerSaveInput();
            InputError = null;
        }

        private async Task SaveAsync()
        {
            if (Input is not null)
            {
                var httpResult = await new HttpService().Best<CustomerSaveOutput>(Input);
                if (httpResult.IsSuccess)
                {
                    var output = httpResult.Data!;

                    switch (output.ReturnValue)
                    {
                        case CustomerSaveOutput.Returns.Inserted:
                            Customers!.Add(new CustomersResult(output.CustomerId!.Value, Input!.FirstName!, Input!.LastName!, Input!.Email!));
                            Input = null;
                            break;
                        case CustomerSaveOutput.Returns.Modified:
                            {
                                var existing = Customers!.FirstOrDefault(c => c.CustomerId == output.CustomerId!.Value)!;
                                existing.FirstName = Input!.FirstName!;
                                existing.LastName = Input!.LastName!;
                                existing.Email = Input!.Email!;
                                Input = null;
                                break;
                            }

                        case CustomerSaveOutput.Returns.Duplicate:
                            InputError = "A customer with that email already exists";
                            break;
                        case CustomerSaveOutput.Returns.NotFound:
                            InputError = "This customer no longer exists. It may have been deleted by another user.";
                            break;
                    }
                }
                else
                {
                    InputError = httpResult.ErrorResult;
                }
            }
        }

        private void InitUpdate(int customerId)
        {
            Input = Map(Customers!.FirstOrDefault(c => c.CustomerId == customerId)!);
            InputError = null;
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
                    await OnPageAsync(CurrentPage - 1);
                }

                await OnPageAsync(CurrentPage);
            }
        }

        private CustomerSaveInput Map(CustomersResult source)
        {
            return new CustomerSaveInput(source.CustomerId, source.FirstName, source.LastName, source.Email);
        }
    }
}
