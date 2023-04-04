using GettingStarted.DataServices.Default;
using GettingStarted.DataServices.Default.Models;
using System.Data.SqlClient;

namespace GettingStarted.Tests
{
    [TestClass]
    public class DefaultTests
    {
        private Service service = new("server=(local); initial catalog = gettingstarted; integrated security = true");

        [TestMethod]
        public void A_CustomerSave_NullCustomerId_PreventsServiceCall()
        {
            var input = new CustomerSave_V2Input()
            {
                CustomerId = null,
                CustomerTypeId = null,
                Email = null,
                FirstName = null,
                LastName = null,
            };

            // Using the IsValid method makes are code clean

            if (input.IsValid())
            {
                Assert.Fail();
            }
        }

        [TestMethod]
        public void B_CustomerSave_NotFoundCustomer_ReturnsNotFound()
        {
            var input = new CustomerSaveInput()
            {
                CustomerId = -1,
                CustomerTypeId = 1,
                Email = TestHelpers.RandomEmail(256),
                FirstName = TestHelpers.RandomString(64),
                LastName = TestHelpers.RandomString(64),
            };

            var output = service.CustomerSave(input);

            // We determine the outcome of our call using the enumerated return values

            Assert.IsTrue(output.ReturnValue == CustomerSaveOutput.Returns.NotFound);

        }

        [TestMethod]
        public void C_CustomerSave_NewCustomer_NullValues_FailsIsvalid()
        {
            var input = new CustomerSaveInput() { CustomerId = 0 };

            // Using the IsValid method makes are code clean

            if (input.IsValid())
            {
                Assert.Fail();
            }

            TestHelpers.WriteErrors(input);
        }


        [TestMethod]
        public void D_CustomerSave_NewCustomer_ExceedMaxLength_FailsIsValid()
        {
            var input = new CustomerSaveInput()
            {
                CustomerId = 0,
                CustomerTypeId = 1,
                Email = TestHelpers.RandomEmail(257),
                FirstName = TestHelpers.RandomString(65),
                LastName = TestHelpers.RandomString(65),
            };

            if (input.IsValid())
            {
                Assert.Fail();
            }

            TestHelpers.WriteErrors(input);

        }

        [TestMethod]
        public void E_CustomerSave_DuplicateEmail_ReturnsDuplicate()
        {
            var input = new CustomerSaveInput()
            {
                CustomerId = 0,
                CustomerTypeId = 1,
                Email = TestHelpers.RandomEmail(128),
                FirstName = TestHelpers.RandomString(32),
                LastName = TestHelpers.RandomString(32),
            };

            // First Save
            service.CustomerSave(input);
            
            // Second Save
            var output = service.CustomerSave(input);

            Assert.IsTrue(output.ReturnValue == CustomerSaveOutput.Returns.Duplicate);

        }

        [TestMethod]
        public void F_CustomerSave_InvalidCustomerType_ReturnsForeignKeyViolation()
        {
            var input = new CustomerSaveInput()
            {
                CustomerId = 0,
                CustomerTypeId = 0,
                Email = TestHelpers.RandomEmail(128),
                FirstName = TestHelpers.RandomString(32),
                LastName = TestHelpers.RandomString(32),
            };

            var output = service.CustomerSave(input);

            Assert.IsTrue(output.ReturnValue == CustomerSaveOutput.Returns.ForeignKeyViolation);
        }
    }
}
