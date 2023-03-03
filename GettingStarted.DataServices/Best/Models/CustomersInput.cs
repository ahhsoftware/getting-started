// --------------------------------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by the SQL PLUS Code Generation Utility.
//     Changes to this file may cause incorrect behavior and will be lost if the code is regenerated.
//     Underlying Routine: Customers
//     Last Modified On: 3/2/2023 12:48:35 PM
//     Written By: Alan@SQLPlus.net
//     Visit https://www.SQLPLUS.net for more information about the SQL PLUS build time ORM.
// </auto-generated>
// --------------------------------------------------------------------------------------------------------
namespace GettingStarted.DataServices.Best.Models
{
    #nullable enable

    #region usings

    using SqlPlusBase;
    using System.ComponentModel.DataAnnotations;

    #endregion usings

    /// <summary>
    /// Input object for the Customers service.
    /// </summary>
    public partial class CustomersInput : ValidInput
    {
        #region Constructors

        /// <summary>
        /// Empty constructor for CustomersInput.
        /// </summary>
        public CustomersInput() { }

        /// <summary>
        /// Parameterized constructor for CustomersInput.
        /// </summary>
        /// <param name="PageSize">Maps to parameter @PageSize.</param>
        /// <param name="PageNumber">Maps to parameter @PageNumber.</param>
        public CustomersInput(int? PageSize, int? PageNumber)
        {
            this.PageSize = PageSize;
            this.PageNumber = PageNumber;
        }

        #endregion Constructors

        #region Fields

        private int? _PageSize;
        /// <summary>
        /// Maps to parameter @PageSize.
        /// </summary>
        [Required]
        [Range(typeof(int), "10", "50")]
        public int? PageSize
        {
            get => _PageSize;
            set => _PageSize = value;
        }

        private int? _PageNumber = 10;
        /// <summary>
        /// Maps to parameter @PageNumber.
        /// </summary>
        [Required]
        public int? PageNumber
        {
            get => _PageNumber;
            set => _PageNumber = value;
        }

        #endregion

    }
}