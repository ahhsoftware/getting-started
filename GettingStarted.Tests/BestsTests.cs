using GettingStarted.DataServices.Best.Models;

namespace GettingStarted.Tests
{
    [TestClass]
    public class BestsTests
    {
        private GettingStarted.DataServices.Best.Service service = new("server=(local); initial catalog = gettingstarted; integrated security = true");

        private static int? customerId;
        
        [TestMethod]
        public void A_CustomerSave_NullValues_IsNotValid()
        {
            var input = new CustomerSaveInput(0, null,null,null);

            Assert.IsFalse(input.IsValid());

            
        }

        [TestMethod]
        public void B_CustomerSave_InvalidEmail_IsNotValid()
        {
            var input = new CustomerSaveInput(0, "alan", "hyneman", "invalid email");

            Assert.IsFalse(input.IsValid());
        }

        [TestMethod]
        public void C_CustomerSave_InvalidEmail_IsNotValid()
        {
            var input = new CustomerSaveInput(0, "alan", "hyneman", "invalid email");

            Assert.IsFalse(input.IsValid());
        }

        [TestMethod]
        public void D_CustomerSave_Saved_IsNotValid()
        {
            var input = new CustomerSaveInput(0, "alan", "hyneman", "alan@sqlplus.net");
            
            var output = service.CustomerSave(input);
            
            Assert.IsTrue(output.ReturnValue == CustomerSaveOutput.Returns.Inserted);

        }
    }
}
