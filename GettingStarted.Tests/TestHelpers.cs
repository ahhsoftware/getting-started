using SqlPlusBase;
using System.Globalization;

namespace GettingStarted.Tests
{
    public class TestHelpers
    {
        private static Random _random = new Random();
        private const string values = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

        public static string RandomEmail(int length)
        {
            return $"Email{RandomString(length-15)}@any.where";
        }

        public static string RandomString(int length)
        {
            char[] chars = new char[length];
            
            for(int i=0;i!=length;i++)
            {
                chars[i] = NextRandomChar();
            }

            return new string(chars);
        }

        private static char NextRandomChar()
        {
            return values[_random.Next(0, values.Length - 1)];
        }

        public static void WriteErrors(ValidInput input)
        {
            if (input.ValidationResults is not null && input.ValidationResults.Count > 0)
            {
                foreach (var error in input.ValidationResults)
                {
                    Console.WriteLine($"{string.Join(",", error.MemberNames)}: {error.ErrorMessage}");
                }
            }
        }

        
        public static string Connectionstring
        {
            get
            {
                // TODO: Edit this connection to point to your database for testing
                return "server=(local); initial catalog = gettingstarted; integrated security = true";
            }
        }
    }
}
