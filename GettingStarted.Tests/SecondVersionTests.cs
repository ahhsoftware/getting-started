using GettingStarted.DataServices.Default;
using GettingStarted.DataServices.Default.Models;
using System.Data.SqlClient;

namespace GettingStarted.Tests
{
    [TestClass]
    public class SecondVersionTests
    {
        private Service service = new(TestHelpers.Connectionstring);

        [TestMethod]
        public void A_CustomerSave_NullCustomerId_ThrowsArgumentExeption()
        {
            var input = new CustomerSave_V2Input()
            {
                CustomerId = null,
                CustomerTypeId = null,
                Email = null,
                FirstName = null,
                LastName = null,
            };
            try
            {
                service.CustomerSave_V2(input);
                Assert.Fail();
            }
            catch(SqlException ex)
            {
                Console.WriteLine(ex.Message);
                Assert.Fail();
            }
            catch(ArgumentException ex)
            {
                // We land here because we tried to execute the service
                // with an invalid input object

                Console.WriteLine(ex.Message);                
            }
        }

        public void B_CustomerSave_NotFoundCustomer_FailsQuietly()
        {
            var input = new CustomerSave_V1Input()
            {
                CustomerId = -1,
                CustomerTypeId = 1,
                Email = TestHelpers.RandomEmail(256),
                FirstName = TestHelpers.RandomString(64),
                LastName = TestHelpers.RandomString(64),
            };
            try
            {
                var output = service.CustomerSave_V1(input);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                Assert.Fail();
            }

            // No exceptions but no record was updated
        }


        [TestMethod]
        public void C_CustomerSave_NewCustomer_NullValues_ThrowsArgumentException()
        {
            var input = new CustomerSave_V2Input() { CustomerId = 0 };
            try
            {
                var output = service.CustomerSave_V2(input);
                Assert.Fail();
            }
            catch (SqlException ex)
            {
                Console.WriteLine(ex.Message);
                Assert.Fail();
            }
            catch (ArgumentException ex)
            {
                // We land here because we tried to execute the service
                // with an invalid input object
                
                Console.WriteLine(ex.Message);
            }
        }

        [TestMethod]
        public void D_CustomerSave_NewCustomer_ExceedMaxLength_ThrowsArgumentException()
        {
            var input = new CustomerSave_V2Input()
            {
                CustomerId = 0,
                CustomerTypeId = 1,
                Email = TestHelpers.RandomEmail(257),
                FirstName = TestHelpers.RandomString(65),
                LastName = TestHelpers.RandomString(65),
            };

            try
            {
                var saveOutput = service.CustomerSave_V2(input);
                Assert.Fail();
            }
            catch (SqlException ex)
            {
                Console.WriteLine(ex.Message);
                Assert.Fail();
            }
            catch (ArgumentException ex)
            {
                // We land here because we tried to execute the service
                // with an invalid input object

                Console.WriteLine(ex.Message);
            }

        }

        [TestMethod]
        public void E_CustomerSave_DuplicateEmail_ThrowsSQLException()
        {
            var input = new CustomerSave_V2Input()
            {
                CustomerId = 0,
                CustomerTypeId = 1,
                Email = TestHelpers.RandomEmail(128),
                FirstName = TestHelpers.RandomString(32),
                LastName = TestHelpers.RandomString(32),
            };

            // First Save
            service.CustomerSave_V2(input);

            try
            {
                // Second save with duplicate email
                service.CustomerSave_V2(input);
                Assert.Fail();
            }
            catch (SqlException ex)
            {
                // We land here because we violated the email index
                Console.WriteLine(ex.Message);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                Assert.Fail();
            }
        }

        [TestMethod]
        public void F_CustomerSave_InvalidCustomerType_ThrowsSQLException()
        {
            var input = new CustomerSave_V2Input()
            {
                CustomerId = 0,
                CustomerTypeId = 0,
                Email = TestHelpers.RandomEmail(128),
                FirstName = TestHelpers.RandomString(32),
                LastName = TestHelpers.RandomString(32),
            };

            try
            {
                service.CustomerSave_V2(input);
                Assert.Fail();
            }
            catch (SqlException ex)
            {
                // We land here because we violated the customer type FK
                Console.WriteLine(ex.Message);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                Assert.Fail();
            }
        }

    }
}
