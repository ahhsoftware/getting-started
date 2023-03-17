using GettingStarted.DataServices.Bad.Models;

namespace GettingStarted.Tests
{
    [TestClass]
    public class BadTests
    {
        private GettingStarted.DataServices.Bad.Service service = new("server=(local); initial catalog = gettingstarted; integrated security = true");

        [TestMethod]
        public void A_Customer_Insert_Then_Update_Success()
        {
            // Using the object constructor
            var input = new CustomerSaveInput(0, "last_name", "first_name", RandomEmail());

            // Alternatively setting properties
            input = new CustomerSaveInput
            {
                CustomerId = 0,
                LastName = "last_name",
                FirstName = "first_name",
                Email = RandomEmail()
            };

            // This is pointless in the "bad" schema since there are no validation tags on the parameters.
            Assert.IsTrue(input.IsValid());

            // doing the insert
            var output = service.CustomerSave(input);


            Assert.IsTrue(output.CustomerId != 0);

            // getting our output from the service output
            input.CustomerId = output.CustomerId;

            // changing the last name
            input.LastName = "different";

            // saving again
            service.CustomerSave(input);
        }

        private string RandomEmail()
        {
            return $"Email{DateTime.Now.Ticks}@any.where";
        }
    }
}