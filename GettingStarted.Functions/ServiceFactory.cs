using System;

namespace GettingStarted.Functions
{
    internal class ServiceFactory
    {
        
        private static GettingStarted.DataServices.Good.Service? goodDataService;
        private static GettingStarted.DataServices.Better.Service? betterDataService;
        private static GettingStarted.DataServices.Best.Service? bestDataService;

        public static GettingStarted.DataServices.Good.Service GoodDataService
        {
            get
            {
                if(goodDataService is null)
                {
                    string connection = Environment.GetEnvironmentVariable("ConnectionString")!;
                    goodDataService = new GettingStarted.DataServices.Good.Service(connection);
                }
                return goodDataService;
            }
        }

        public static GettingStarted.DataServices.Better.Service BetterDataService
        {
            get
            {
                if (betterDataService is null)
                {
                    string connection = Environment.GetEnvironmentVariable("ConnectionString")!;
                    betterDataService = new GettingStarted.DataServices.Better.Service(connection);
                }
                return betterDataService;
            }
        }

        public static GettingStarted.DataServices.Best.Service BestDataService
        {
            get
            {
                if (betterDataService is null)
                {
                    string connection = Environment.GetEnvironmentVariable("ConnectionString")!;
                    bestDataService = new GettingStarted.DataServices.Best.Service(connection);
                }
                return bestDataService;
            }
        }
    }
}
