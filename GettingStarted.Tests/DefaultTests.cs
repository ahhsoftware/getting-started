using GettingStarted.DataServices.Default;
using GettingStarted.DataServices.Default.Models;

namespace GettingStarted.Tests
{
    [TestClass]
    public class DefaultTests
    {
        private Service service = new("server=(local); initial catalog = gettingstarted; integrated security = true");

        [TestMethod]
        public void A_Customer_Null_Values_NotValid()
        {
            var input = new CustomerSaveInput();

            Assert.IsFalse(input.IsValid());

            TestHelpers.WriteErrors(input);

        }

        [TestMethod]
        public void B_Customer_InvalidEmail_NotValid()
        {
            var input = new CustomerSaveInput(0, 1, "first", "last", "invalidEmail");

            Assert.IsFalse(input.IsValid());

            TestHelpers.WriteErrors(input);

        }

        [TestMethod]
        public void C_Customer_UniqueInsert_Returns_Inserted()
        {
            var input = new CustomerSaveInput(0, 1, "first", "last", TestHelpers.RandomEmail());

            if(input.IsValid())
            {
                var output = service.CustomerSave(input);
                Assert.IsTrue(output.ReturnValue == CustomerSaveOutput.Returns.Inserted);
            }
            else
            {
                TestHelpers.WriteErrors(input);
                Assert.Fail();
            }  
        }

        [TestMethod]
        public void D_Customer_DuplicateEmail_Returns_Duplicate()
        {
            var input = new CustomerSaveInput(0, 1, "first", "last", TestHelpers.RandomEmail());

            if (input.IsValid())
            {
                //First save to create a row to violate
                service.CustomerSave(input);
               
                //Makes this one a duplicate
                var output = service.CustomerSave(input);
                Assert.IsTrue(output.ReturnValue == CustomerSaveOutput.Returns.Duplicate);
            }
            else
            {
                TestHelpers.WriteErrors(input);
                Assert.Fail();
            }
        }

        [TestMethod]
        public void E_Customer_InvalidCustomerType_Returns_ForeignKeyViolation()
        {
            var input = new CustomerSaveInput(0, 0, "first", "last", TestHelpers.RandomEmail());

            if (input.IsValid())
            {
                var output = service.CustomerSave(input);
                Assert.IsTrue(output.ReturnValue == CustomerSaveOutput.Returns.ForeignKeyViolation);
            }
            else
            {
                TestHelpers.WriteErrors(input);
                Assert.Fail();
            }
        }

        [TestMethod]
        public void F_Customer_ExistingCustomerUpdate_Returns_Modified()
        {
            var input = new CustomerSaveInput(0, 1, "first", "last", TestHelpers.RandomEmail());

            if (input.IsValid())
            {
                // saving to get the inserted customer id for an update
                input.CustomerId = service.CustomerSave(input).CustomerId!.Value;
                
                var output = service.CustomerSave(input);
                Assert.IsTrue(output.ReturnValue == CustomerSaveOutput.Returns.Modified);
            }
            else
            {
                TestHelpers.WriteErrors(input);
                Assert.Fail();
            }
        }

        [TestMethod]
        public void F_Customer_ExistingCustomerNotFound_Returns_NotFound()
        {
            var input = new CustomerSaveInput(-1, 1, "first", "last", TestHelpers.RandomEmail());

            if (input.IsValid())
            {
                var output = service.CustomerSave(input);
                Assert.IsTrue(output.ReturnValue == CustomerSaveOutput.Returns.NotFound);
            }
            else
            {
                TestHelpers.WriteErrors(input);
                Assert.Fail();
            }
        }

        [TestMethod]
        public void G_CustomerById_Exists_Returns_Ok()
        {
            var input = new CustomerSaveInput(0, 1, "first", "last", TestHelpers.RandomEmail());

            if (input.IsValid())
            {
                int customerId = service.CustomerSave(input).CustomerId!.Value;

                var output = service.CustomerById(new CustomerByIdInput(customerId));

                Assert.IsTrue(output.ReturnValue == CustomerByIdOutput.Returns.Ok);

                var result = output.ResultData!;

                Assert.IsTrue(result.Email == input.Email);
            }
            else
            {
                TestHelpers.WriteErrors(input);
                Assert.Fail();
            }
        }

        [TestMethod]
        public void H_CustomerById_DoesNotExists_Returns_NotFound()
        {
            var output = service.CustomerById(new CustomerByIdInput(-1));
            Assert.IsTrue(output.ReturnValue == CustomerByIdOutput.Returns.NotFound);
        }
    }
}
