using System;

namespace GettingStarted.Functions
{
    internal class ServiceFactory
    {
        
        private static GettingStarted.DataServices.Bad.Service? badDataService;
        private static GettingStarted.DataServices.Better.Service? betterDataService;
        private static GettingStarted.DataServices.Best.Service? bestDataService;

        public static GettingStarted.DataServices.Bad.Service BadDataService
        {
            get
            {
                if(badDataService is null)
                {
                    string connection = Environment.GetEnvironmentVariable("ConnectionString")!;
                    badDataService = new GettingStarted.DataServices.Bad.Service(connection);
                }
                return badDataService;
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
                if (bestDataService is null)
                {
                    string connection = Environment.GetEnvironmentVariable("ConnectionString")!;
                    bestDataService = new GettingStarted.DataServices.Best.Service(connection);
                }
                return bestDataService;
            }
        }
    }
}
