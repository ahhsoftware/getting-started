using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
                    string connection = Environment.GetEnvironmentVariable("GoodConnectionString")!;
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
                    string connection = Environment.GetEnvironmentVariable("BetterConnectionString")!;
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
                    string connection = Environment.GetEnvironmentVariable("BestConnectionString")!;
                    bestDataService = new GettingStarted.DataServices.Best.Service(connection);
                }
                return bestDataService;
            }
        }

    }
}
