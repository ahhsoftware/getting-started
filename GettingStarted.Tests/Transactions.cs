using GettingStarted.DataServices.Default;
using GettingStarted.DataServices.Default.Models;
using System.Data.SqlClient;

namespace GettingStarted.Tests
{
    [TestClass]
    public class Transactions
    {
        private string connection = "server=(local); initial catalog = gettingstarted; integrated security = true";

        [TestMethod]
        public void A_CustomerSave_TransactionCommits()
        {
            var input1 = new CustomerSaveInput()
            {
                CustomerId = 0,
                CustomerTypeId = 1,
                Email = TestHelpers.RandomEmail(32),
                FirstName = "first name",
                LastName = "last name",
            };

            var input2 = new CustomerSaveInput()
            {
                CustomerId = 0,
                CustomerTypeId = 1,
                Email = TestHelpers.RandomEmail(32),
                FirstName = "first name",
                LastName = "last name",
            };

            using ( SqlConnection cnn = new SqlConnection(connection))
            {
                cnn.Open();
                
                SqlTransaction transaction = cnn.BeginTransaction();
                
                Service service = new Service(cnn, transaction);
                
                try
                {
                    var output1 = service.CustomerSave(input1);
                    var output2 = service.CustomerSave(input2);

                    bool bothInserted =
                        output1.ReturnValue == CustomerSaveOutput.Returns.Inserted &&
                        output2.ReturnValue == CustomerSaveOutput.Returns.Inserted;

                    if (bothInserted)
                    {
                        transaction.Commit();
                    }
                    else
                    {
                        transaction.Rollback();
                        Assert.Fail();
                    }
                }
                catch(Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    try
                    {
                        transaction.Rollback();
                    }
                    catch (Exception exRollback)
                    {
                        Console.WriteLine(exRollback.Message);
                    }

                    Assert.Fail();
                }
            }   
        }


        [TestMethod]
        public void B_CustomerSave_TransactionRollsback()
        {

            var input = new CustomerSaveInput()
            {
                CustomerId = 0,
                CustomerTypeId = 1,
                Email = TestHelpers.RandomEmail(32),
                FirstName = "first name",
                LastName = "last name",
            };

            using (SqlConnection cnn = new SqlConnection(connection))
            {
                cnn.Open();
                SqlTransaction transaction = cnn.BeginTransaction();
                Service service = new Service(cnn, transaction);

                try
                {

                    var output1 = service.CustomerSave(input);
                    var output2 = service.CustomerSave(input);

                    bool bothInserted =
                        output1.ReturnValue == CustomerSaveOutput.Returns.Inserted &&
                        output2.ReturnValue == CustomerSaveOutput.Returns.Inserted;

                    if (!bothInserted)
                    {
                        transaction.Rollback(); 
                    }
                    else
                    {
                        Assert.Fail();
                        transaction.Commit();
                    }

                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);

                    try
                    {
                        transaction.Rollback();
                    }
                    catch (Exception exRollback)
                    {
                        Console.WriteLine(exRollback.Message);
                    }

                    Assert.Fail();
                }
            }
        }
    }
}
