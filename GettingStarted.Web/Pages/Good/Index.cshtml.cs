using GettingStarted.DataServices.Best.Models;
using GettingStarted.DataServices.Good;
using GettingStarted.DataServices.Good.Models;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace GettingStarted.Web.Pages.Good
{
    public class IndexModel : PageModel
    {
        private const string DEFAULT_ERROR_MESSAGE = "Looks like things didn't go as planned.";

        private readonly Service dataService;

        public List<CustomerQueryResult>? Customers { set; get; }

        public string ErrorMessage { set; get; }

        public int CustomerId { set; get; }
        public IndexModel(Service dataService)
        {
            // Injecting the Good Services

            this.dataService = dataService;
        }

        public void OnGet()
        {
            try
            {
                var output = dataService.CustomerQuery(new CustomerQueryInput(null, null, null));

                //Set the page data to the service result.
                Customers = output.ResultData;
            }
            catch(Exception ex)
            {
                // TODO: Log Exception
                ErrorMessage = DEFAULT_ERROR_MESSAGE;
            }
        }

        public void OnPostDeleteCustomer(int customerId)
        {
            try
            {
                dataService.CustomerDelete(new(customerId));
            }
            catch(Exception ex)
            {
                // TODO: Log Exception
                ErrorMessage = DEFAULT_ERROR_MESSAGE;
            }

            OnGet();

        }
    }
}

