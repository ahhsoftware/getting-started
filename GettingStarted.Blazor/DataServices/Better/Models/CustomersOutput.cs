// --------------------------------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by the SQL  Code Generation Utility.
//     Changes to this file may cause incorrect behavior and will be lost if the code is regenerated.
//     Underlying Routine: Customers
//     Last Modified On: 3/2/2023 10:15:04 AM
//     Written By: Alan@SQLPlus.net
//     Select Type: MultiRow
//     Visit https://www.SQLPLUS.net for more information about the SQL Plus build time ORM.
// </auto-generated>
// --------------------------------------------------------------------------------------------------------
namespace GettingStarted.DataServices.Better.Models
{
    #nullable enable


    #region usings

    using System.Collections.Generic;

    #endregion usings

    /// <summary>
    /// Output object for Customers service.
    /// </summary>
    public partial class CustomersOutput
    {

        #region Return Value

        /// <summary>
        /// Actual return value for the routine.
        /// </summary>
        public int? ReturnValue { set; get; }

        #endregion Return Value

        #region Result Data

        /// <summary>
        /// List of CustomersResult.
        /// </summary>
        public List<CustomersResult>? ResultData { set; get; }

        #endregion Result Data
    }



    #region Result Set Objects

    /// <summary>
    /// Result object for Customers service.
    /// </summary>




    public partial class CustomersResult
	{
        /// <summary>
        /// Result set object for Customers.
        /// </summary>
        /// <param name="CustomerId">Maps to table value column CustomerId.</param>
        /// <param name="FirstName">Maps to table value column FirstName.</param>
        /// <param name="LastName">Maps to table value column LastName.</param>
        /// <param name="Email">Maps to table value column Email.</param>
        public CustomersResult(int CustomerId, string FirstName, string LastName, string Email)
        {
             this.CustomerId = CustomerId;
             this.FirstName = FirstName;
             this.LastName = LastName;
             this.Email = Email;
        }


        /// <summary>
        /// Maps to table value column CustomerId.
        /// </summary>
        public int CustomerId { set; get; }

        /// <summary>
        /// Maps to table value column FirstName.
        /// </summary>
        public string FirstName { set; get; }

        /// <summary>
        /// Maps to table value column LastName.
        /// </summary>
        public string LastName { set; get; }

        /// <summary>
        /// Maps to table value column Email.
        /// </summary>
        public string Email { set; get; }
    }


    #endregion Result Set Objects

}