//using GettingStarted.DataServices.Good.Models;

//namespace GettingStarted.Tests
//{
//    [TestClass]
//    public class GoodTests
//    {
//        private GettingStarted.DataServices.Good.Service goodService = new ("server=(local); initial catalog = gettingstarted; integrated security = true");
        
//        private static int? customerId;

//        [TestMethod]
//        public void B_CustomerInsertTest()
//        {
//            // Using the object constructor
//            var input = new CustomerInsertInput("last_name", "first_name", RandomEmail());

//            // Alternatively setting properties
//            input = new CustomerInsertInput
//            {
//                LastName = "last_name",
//                FirstName = "first_name",
//                Email = RandomEmail()
//            };

//            // This is pointless in the "good" schema since there are no validation tags on the parameters.
//            Assert.IsTrue(input.IsValid());

//            var output = goodService.CustomerInsert(input);

//            Assert.IsTrue(output.CustomerId != 0);

//            customerId = output.CustomerId;
//        }

//        [TestMethod]
//        public void C_CustomerUpdateTest()
//        {
//            // Using the object constructor
//            var input = new CustomerUpdateInput(customerId, "changed_first_name", "changed_last_name", RandomEmail());

//            // Alternatively setting properties
//            input = new CustomerUpdateInput
//            {
//                CustomerId = customerId,
//                LastName = "changed_last_name",
//                FirstName = "changed_first_name",
//                Email = RandomEmail()
//            };

//            // This is pointless in the "good" schema since there are no validation tags on the parameters.
//            Assert.IsTrue(input.IsValid());
           
//            var output = goodService.CustomerUpdate(input);

//        }


//        [TestMethod]
//        public void D_CustomerSelectByIdTest()
//        {
//            // Using the object constructor
//            var input = new CustomerByIdInput(customerId);

//            // Alternatively setting properties
//            input = new CustomerByIdInput
//            {
//                CustomerId = customerId
//            };

//            // This is pointless in the "good" schema since there are no validation tags on the parameters.
//            Assert.IsTrue(input.IsValid());

//            var output = goodService.CustomerById(input);

//            var customer = output.ResultData!;

//            Assert.IsTrue(customer.CustomerId == customerId!.Value);

//            //  TODO: Add addition checks to customer properties. They should match the values from the update.

//        }

//        private string RandomEmail()
//        {
//            return $"Email{DateTime.Now.Ticks}@any.where";
//        }
//    }
//}