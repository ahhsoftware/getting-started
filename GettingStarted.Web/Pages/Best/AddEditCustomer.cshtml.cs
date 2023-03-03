using GettingStarted.DataServices.Best;
using GettingStarted.DataServices.Best.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace GettingStarted.Web.Pages.Best
{
    public class AddEditCustomerModel : PageModel
    {
        private readonly Service dataService;
        public string? ErrorMessage { set; get; }
        public CustomerSaveInput? Input { set; get; }
        public AddEditCustomerModel(Service dataService)
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
                    var output = dataService.CustomerById(new(customerId));
                    if(output.ReturnValue == CustomerByIdOutput.Returns.NotFound)
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
                    if(output.ReturnValue == CustomerSaveOutput.Returns.Inserted || output.ReturnValue == CustomerSaveOutput.Returns.Modified)
                    {
                        return Redirect("~/Best/Index");
                    }
                    else
                    {
                        if (output.ReturnValue == CustomerSaveOutput.Returns.Duplicate)
                        {
                            ErrorMessage = "The email address provided is being used by another customer";
                        }
                        else
                        {
                            ErrorMessage = "The customer no longer exists. It more than like was deleted by another administrator.";
                        }
                            
                    }
                }
                catch (Exception ex)
                {
                    // Note: This is for illustration only, we would never report this error to an end user in a real world application.
                    ErrorMessage = ex.Message;

                }
            }
            return Page();
        }

        private CustomerSaveInput MapFromResult(CustomerByIdResult result)
        {
            return new CustomerSaveInput(result.CustomerId, result.FirstName, result.LastName, result.Email);
        }
    }
}
