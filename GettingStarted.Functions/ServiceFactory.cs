using System;

namespace GettingStarted.Functions
{
    internal class ServiceFactory
    {
        
        private static GettingStarted.DataServices.Default.Service? dataService;
    
        public static GettingStarted.DataServices.Default.Service DataService
        {
            get
            {
                if(dataService is null)
                {
                    string connection = Environment.GetEnvironmentVariable("ConnectionString")!;
                    dataService = new GettingStarted.DataServices.Default.Service(connection);
                }
                return dataService;
            }
        }
    }
}
