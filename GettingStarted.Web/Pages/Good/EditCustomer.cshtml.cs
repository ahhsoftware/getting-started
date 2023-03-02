using GettingStarted.DataServices.Good;
using GettingStarted.DataServices.Good.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace GettingStarted.Web.Pages.Good
{
    public class EditCustomerModel : PageModel
    {
        private readonly Service dataService;

        public string? ErrorMessage { set; get; }

        public CustomerUpdateInput? Input {set;get;}
        
        public EditCustomerModel(Service dataService)
        {
            this.dataService = dataService;
        }

        public void OnGet(int customerId)
        {
            try
            {
                var output = dataService.CustomerById(new(customerId));
                Input = MapFromResult(output.ResultData!);
            }
            catch (Exception ex)
            {
                // Note: This is for illustration only, we would never report this error to an end user in a real world application.
                ErrorMessage = ex.Message;

            }
        }

        public IActionResult OnPost(CustomerUpdateInput input)
        {
            if(input.IsValid())
            {
                try
                {
                    dataService.CustomerUpdate(input);
                    return Redirect("~/Good/Index");
                }
                catch (Exception ex)
                {
                    // Note: This is for illustration only, we would never report this error to an end user in a real world application.
                    ErrorMessage = ex.Message;

                }
            }
            return Page();
        }

        private CustomerUpdateInput MapFromResult(CustomerByIdResult result)
        {
            return new CustomerUpdateInput(result.CustomerId, result.FirstName, result.LastName, result.Email);
        }
    }
}
