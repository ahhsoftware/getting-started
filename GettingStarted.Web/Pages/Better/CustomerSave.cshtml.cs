using GettingStarted.DataServices.Better;
using GettingStarted.DataServices.Better.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace GettingStarted.Web.Pages.Better
{
    public class CustomerSaveModel : PageModel
    {
        private readonly Service dataService;
        public string? ErrorMessage { set; get; }
        public CustomerSaveInput? Input { set; get; }
        public CustomerSaveModel(Service dataService)
        {
            this.dataService = dataService;
        }

        public void OnGet(int customerId = 0)
        {
            if (customerId == 0)
            {
                Input = new CustomerSaveInput(0, null, null, null);
            }
            else
            {
                try
                {
                    // Illustrates how we have to inspect the result vs relying on return values.
                    // In this sample it's not ideal but workable, in other case it can be a needless burden.

                    var output = dataService.CustomerById(new(customerId));
                    if (output.ResultData is null)
                    {
                        ErrorMessage = "The customer no longer exists. It more than like was deleted by another administrator.";
                    }
                    else
                    {
                        Input = MapFromResult(output.ResultData!);
                    }
                }
                catch (Exception ex)
                {
                    // Note: This is for illustration only, we would never report this error to an end user in a real world application.
                    ErrorMessage = ex.Message;
                }
            }
        }

        public IActionResult OnPost(CustomerSaveInput input)
        {
            try
            {
                // With no validation parameters or return values, we are at the mercy of the database
                // A call to is valid would serve no purpose.
                var output = dataService.CustomerSave(input);
                return Redirect($"~/Better/Index?pageNumber={GetPage()}");
            }
            catch (Exception ex)
            {
                // Note: This is for illustration only, we would never report this error to an end user in a real world application.
                ErrorMessage = ex.Message;

            }
            return Page();
        }

        private CustomerSaveInput MapFromResult(CustomerByIdResult result)
        {
            return new CustomerSaveInput(result.CustomerId, result.LastName, result.FirstName, result.Email);
        }

        public int GetPage()
        {
            int result = 1;

            if (Request.HttpContext.Session.GetInt32("page").HasValue)
            {
                result = Request.HttpContext.Session.GetInt32("page")!.Value;
            }

            return result;
        }
    }
}
