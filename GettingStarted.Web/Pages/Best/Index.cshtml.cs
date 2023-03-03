using GettingStarted.DataServices.Best;
using GettingStarted.DataServices.Best.Models;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace GettingStarted.Web.Pages.Best
{
    public class PagingModel
    {
        public int? PreviousPage { set; get; }
        public int? NextPage { set; get; }
        public int? CurrentPage { set; get; }
        public List<int>? PageItems { set; get; }
    }

    public class IndexModel : PageModel
    {

        private readonly Service dataService;
        public List<CustomersResult>? Customers { set; get; }
        public string? ErrorMessage { set; get; }
        public int? CustomerId { set; get; }
        public PagingModel? Pages { set; get; }

        public IndexModel(Service dataService)
        {
            this.dataService = dataService;
        }

        public void OnGet(int pageNumber = 1)
        {
            try
            {
                var output = dataService.Customers(new(10, pageNumber));

                if (output.ReturnValue == CustomersOutput.Returns.Ok)
                {
                    Customers = output.ResultData;
                    Pages = GetPagingModel(pageNumber, output.PageCount!.Value);
                }
            }
            catch (Exception ex)
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

        private PagingModel? GetPagingModel(int currentPage, int numberOfPages)
        {
            if (numberOfPages > 1)
            {
                int numberOfPagesToDisplay = NumberOfPagesToDisplay(numberOfPages, 9);

                PagingModel result = new() { CurrentPage = currentPage, PageItems = new List<int>() };

                result.PreviousPage = Math.Max(currentPage - 1, 1);
                result.NextPage = Math.Min(currentPage + 1, numberOfPages);

                int firstPageToDisplay = Math.Max(currentPage - 4, 1);
                int lastPageToDisplay = Math.Min(firstPageToDisplay + 8, numberOfPages);
                int rangeToDisplay = lastPageToDisplay - firstPageToDisplay + 1;

                if(rangeToDisplay < numberOfPagesToDisplay)
                {
                    if(lastPageToDisplay == numberOfPages)
                    {
                        firstPageToDisplay = numberOfPages - numberOfPagesToDisplay;
                    }
                    else
                    {
                        lastPageToDisplay = numberOfPages;
                    }
                }
                
                for (int idx = firstPageToDisplay; idx <= lastPageToDisplay; idx++)
                {
                    result.PageItems.Add(idx);
                }

                return result;
            }

            return null;
        }

        private int NumberOfPagesToDisplay(int numberOfPages, int maxNumber)
        {
            int result = Math.Min(numberOfPages, 9);
            return result % 2 == 0 ? result - 1 : result;
        }
    }
}
