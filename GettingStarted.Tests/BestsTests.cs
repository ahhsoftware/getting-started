using GettingStarted.DataServices.Best.Models;
using System.Security.Cryptography;

namespace GettingStarted.Tests
{
    // Feel free to build out more tests

    [TestClass]
    public class BestsTests
    {
        private GettingStarted.DataServices.Best.Service service = new("server=(local); initial catalog = gettingstarted; integrated security = true");

        [TestMethod]
        public void A_Customer_Null_Values_NotValid()
        {
            // Using the object constructor
            var input = new CustomerSaveInput();

            Assert.IsFalse(input.IsValid());

            WriteValidationError(input);

        }

        [TestMethod]
        public void B_Customer_InvalidEmail_NotValid()
        {
            // Using the object constructor
            var input = new CustomerSaveInput(0, "last", "first", "invalidEmail");

            Assert.IsFalse(input.IsValid());

            WriteValidationError(input);

        }

        [TestMethod]
        public void C_Customer_Insert_Duplicate_Returns_Duplicate()
        {
            string randomEmail = RandomEmail();
            
            // Using the object constructor
            var input = new CustomerSaveInput(0, "last", "first", randomEmail);

            var output = service.CustomerSave(input);

            Assert.IsTrue(output.ReturnValue == CustomerSaveOutput.Returns.Inserted);

            input = new CustomerSaveInput(0, "last", "first", randomEmail);

            output = service.CustomerSave(input);

            Assert.IsTrue(output.ReturnValue == CustomerSaveOutput.Returns.Duplicate);

        }

        private void WriteValidationError(CustomerSaveInput input)
        {
            foreach (var error in input.ValidationResults)
            {
                Console.WriteLine($"{error.MemberNames.First()}: {error.ErrorMessage}");
            }
        }

        private string RandomEmail()
        {
            return $"Email{DateTime.Now.Ticks}@any.where";
        }
    }
}
