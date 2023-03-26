using SqlPlusBase;

namespace GettingStarted.Tests
{
    public class TestHelpers
    {
        public static string RandomEmail()
        {
            return $"Email{DateTime.Now.Ticks}@any.where";
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
    }
}
