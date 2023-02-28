// --------------------------------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by the SQL PLUS Code Generation Utility.
//     Changes to this file may cause incorrect behavior and will be lost if the code is regenerated.
//     Underlying Routine: CustomerById
//     Last Modified On: 2/27/2023 10:46:31 PM
//     Written By: Alan@SQLPlus.net
//     Visit https://www.SQLPLUS.net for more information about the SQL PLUS build time ORM.
// </auto-generated>
// --------------------------------------------------------------------------------------------------------
namespace GettingStarted.DataServices.Default.Models
{
    #nullable enable

    #region usings

    using SqlPlusBase;
    using System.ComponentModel.DataAnnotations;

    #endregion usings

    /// <summary>
    /// Input object for the CustomerById service.
    /// </summary>
    public partial class CustomerByIdInput : ValidInput
    {
        #region Constructors

        /// <summary>
        /// Empty constructor for CustomerByIdInput.
        /// </summary>
        public CustomerByIdInput() { }

        /// <summary>
        /// Parameterized constructor for CustomerByIdInput.
        /// </summary>
        /// <param name="CustomerId">Maps to parameter @CustomerId.</param>
        public CustomerByIdInput(int? CustomerId)
        {
            this.CustomerId = CustomerId;
        }

        #endregion Constructors

        #region Fields

        private int? _CustomerId;
        /// <summary>
        /// Maps to parameter @CustomerId.
        /// </summary>
        [Required]
        public int? CustomerId
        {
            get => _CustomerId;
            set => _CustomerId = value;
        }

        #endregion

    }
}