using GettingStarted.Blazor.Services;
using GettingStarted.DataServices.Default.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Components;
using Microsoft.JSInterop;
using System.Xml.Linq;
using System.Xml.Serialization;

namespace GettingStarted.Blazor.Pages
{
    public partial class Customers
    {
        [Inject]
        public IJSRuntime javascript { set; get; } = default!;

        private CustomerSaveInput? Input = null;

        private List<CustomerQueryResult>? CustomersResult;

        private bool Loading = false;
     
        private string? ErrorMessage = null;

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
            ErrorMessage = null;

            var httpOutput = await new HttpService().Default<CustomerQueryOutput>(new CustomerQueryInput(10, page));

            if (httpOutput.IsSuccess)
            {
                var output = httpOutput.Data!;

                if (output.ResultData is not null && output.ResultData.Count != 0)
                {
                    CustomersResult = output.ResultData;
                    PageCount = output.PageCount!.Value;
                    CurrentPage = page;
                }
                else
                {
                    CustomersResult = new List<CustomerQueryResult>();
                    PageCount = 1;
                    CurrentPage = 1;
                }
            }
            else
            {
                ErrorMessage = httpOutput.ErrorResult;
            }
        }

        private void InitSave(int customerId)
        {
            if (customerId == 0)
            {
                Input = new CustomerSaveInput(0, null, null, null, null);
            }
            else
            {
                Input = Map(CustomersResult!.FirstOrDefault(c => c.CustomerId == customerId)!);
            }
        }

        private void CustomerSaveSuccess(CustomerSaveOutput output)
        {
            switch (output.ReturnValue)
            {
                case CustomerSaveOutput.Returns.Inserted:
                    InsertCustomerFromInput(output.CustomerId!.Value);
                    Input = null;
                    break;
                case CustomerSaveOutput.Returns.Modified:
                    UpdateExistingCustomerFromInput();
                    Input = null;
                    break;
                default:
                    throw new Exception("Unexpected case returned from form");
            }
        }

        private void CustomerSaveCancel()
        {
            Input = null;
        }

        private async Task DeleteAsync(int customerId)
        {
            var customer = CustomersResult!.FirstOrDefault(c => c.CustomerId == customerId)!;

            JsService js = new JsService(javascript);

            if (await js.Confirm($"Delete customer {customer.FirstName} {customer.LastName}?"))
            {
                var http = new HttpService();

                var httpOutput = await http.Default<CustomerDeleteOutput>(new CustomerDeleteInput(customerId));

                if (httpOutput.IsSuccess)
                {
                    CustomersResult!.Remove(customer);

                    if (CustomersResult.Count == 0)
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

        private CustomerSaveInput Map(CustomerQueryResult source)
        {
            return new CustomerSaveInput(source.CustomerId, source.CustomerTypeId, source.LastName, source.FirstName, source.Email);
        }

        private void UpdateExistingCustomerFromInput()
        {
            var existing = CustomersResult!.FirstOrDefault(c => c.CustomerId == Input!.CustomerId!.Value)!;
            existing.CustomerTypeId = Input!.CustomerTypeId!.Value!;
            existing.FirstName = Input!.FirstName!;
            existing.LastName = Input!.LastName!;
            existing.Email = Input!.Email!;
        }
        private void InsertCustomerFromInput(int customerId)
        {
            CustomersResult!.Add(new CustomerQueryResult(customerId, Input!.CustomerTypeId!.Value, Input!.FirstName!, Input!.LastName!, Input!.Email!));
        }
    }
}