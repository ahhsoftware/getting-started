using GettingStarted.DataServices.Default.Models;

namespace GettingStarted.Tests
{
    [TestClass]
    public class DataTests
    {
        private GettingStarted.DataServices.Default.Service dataService = new DataServices.Default.Service("server=(local); initial catalog = gettingstarted; integrated security = true");
        
        [TestMethod]
        public void A_CustomerSaveInsertTests()
        {

            var input = new CustomerSaveInput(0, "last_name", "first_name", "someone@somewhere.com");
            Assert.IsTrue(input.IsValid());

            input.Email = null;
            Assert.IsFalse(input.IsValid());
            Assert.IsTrue(input.ValidationResults[0].MemberNames.Contains(nameof(input.Email)));
            input.Email = "Someone@somewhere.com";

            //TODO: set other fields invalid values and Assert

            var output = dataService.CustomerSave(input);

            Assert.IsTrue(output.ReturnValue == CustomerSaveOutput.Returns.Inserted);


        }

        [TestMethod]
        public void B_CustomerByIdTest()
        {
            var input = new CustomerByIdInput(1);
            Assert.IsTrue(input.IsValid());
            var output = dataService.CustomerById(input);

            Assert.IsTrue(output.ReturnValue == CustomerByIdOutput.Returns.Ok);

            var customer = output.ResultData!;
            Assert.IsTrue(customer.LastName == "last_name");

        }
        [TestMethod]
        public void C_CustomerDeleteTest()
        {
            var input = new CustomerDeleteInput(1);
            Assert.IsTrue(input.IsValid());
            var output = dataService.CustomerDelete(input);

            Assert.IsTrue(output.ReturnValue == CustomerDeleteOutput.Returns.OK);

        }

    }
}