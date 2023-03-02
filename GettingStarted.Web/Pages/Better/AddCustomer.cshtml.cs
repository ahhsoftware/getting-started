using GettingStarted.DataServices.Better;
using GettingStarted.DataServices.Better.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace GettingStarted.Web.Pages.Better
{
    public class AddCustomerModel : PageModel
    {
        private readonly Service dataService;
        public string? ErrorMessage { set; get; }
        public CustomerInsertInput? Input { set; get; }

        public AddCustomerModel(Service dataService)
        {
            this.dataService = dataService;
        }

        public void OnGet()
        {

        }

        public IActionResult OnPost(CustomerInsertInput input)
        {
            if (input.IsValid())
            {
                try
                {
                    var output = dataService.CustomerInsert(input);
                    return Redirect("/Good/Index");
                }
                catch (Exception ex)
                {
                    // Note: This is for illustration only, we would never report this error to an end user in a real world application.
                    ErrorMessage = ex.Message;

                }
            }
            Input = input;
            return Page();
        }
    }
}
