using GettingStarted.DataServices.Good;
using GettingStarted.DataServices.Good.Models;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace GettingStarted.Web.Pages.Good
{
    public class IndexModel : PageModel
    {
        private readonly Service dataService;

        public List<CustomersResult>? Customers { set; get; }

        public string? ErrorMessage { set; get; }

        public int? CustomerId { set; get; }
        
        public IndexModel(Service dataService)
        {
            this.dataService = dataService;
        }

        public void OnGet()
        {
            try
            {
                var output = dataService.Customers();
                if(output.ResultData is not null)
                {
                    Customers = output.ResultData;
                }
                else
                {
                    Customers = new List<CustomersResult>();
                }
            }
            catch(Exception ex)
            {
                // TODO: Log Exception
                // Note we would never want to actually do this in a production environment
                ErrorMessage = ex.Message;
            }
        }

        public void OnGetDeleteCustomer(int customerId)
        {
            try
            {
                dataService.CustomerDelete(new(customerId));
            }
            catch (Exception ex)
            {
                // TODO: Log Exception
                // Note we would never want to actually do this in a production environment
                ErrorMessage = ex.Message;
            }

            OnGet();
        }
    }
}

