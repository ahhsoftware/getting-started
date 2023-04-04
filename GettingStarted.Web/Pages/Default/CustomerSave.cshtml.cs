using GettingStarted.DataServices.Default;
using GettingStarted.DataServices.Default.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace GettingStarted.Web.Pages.Default
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
                Input = new CustomerSaveInput();
            }
            else
            {
                try
                {
                    var output = dataService.CustomerSelect(new(customerId));
                    
                    if (output.ReturnValue == CustomerSelectOutput.Returns.NotFound)
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
            if (input.IsValid())
            {
                try
                {
                    var output = dataService.CustomerSave(input);
                    switch (output.ReturnValue)
                    {
                        case CustomerSaveOutput.Returns.Inserted:
                        case CustomerSaveOutput.Returns.Modified:
                            return Redirect("~/Default/Index");
                        case CustomerSaveOutput.Returns.Duplicate:
                            ErrorMessage = "The email address provided is being used by another customer";
                            break;
                        default:
                            ErrorMessage = "The customer no longer exists. It more than like was deleted by another administrator.";
                            break;
                    }

                    Input = input;
                }
                catch (Exception ex)
                {
                    // Note: This is for illustration only, we would never report this error to an end user in a real world application.
                    ErrorMessage = ex.Message;

                }
            }
            return Page();
        }

        private CustomerSaveInput MapFromResult(CustomerSelectResult result)
        {
            return new CustomerSaveInput(result.CustomerId, result.CustomerTypeId, result.FirstName, result.LastName, result.Email);
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
