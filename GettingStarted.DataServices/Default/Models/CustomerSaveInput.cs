// --------------------------------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by the SQL PLUS Code Generation Utility.
//     Changes to this file may cause incorrect behavior and will be lost if the code is regenerated.
//     Underlying Routine: CustomerSave
//     Last Modified On: 4/2/2023 3:48:53 PM
//     Written By: alan@sqlplus.net
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
    /// Input object for the CustomerSave service.
    /// </summary>
    public partial class CustomerSaveInput : ValidInput
    {
        #region Constructors

        /// <summary>
        /// Empty constructor for CustomerSaveInput.
        /// </summary>
        public CustomerSaveInput() { }

        /// <summary>
        /// Parameterized constructor for CustomerSaveInput.
        /// </summary>
        /// <param name="CustomerId">Set to 0 for an insert, existing customer id for an update</param>
        /// <param name="CustomerTypeId">Set to one of the CustomerTypes, foreign key check</param>
        /// <param name="FirstName">Customers first (given) name</param>
        /// <param name="LastName">Customers last (family) name</param>
        /// <param name="Email">Customers primary email address</param>
        public CustomerSaveInput(int? CustomerId, byte? CustomerTypeId, string? FirstName, string? LastName, string? Email)
        {
            this.CustomerId = CustomerId;
            this.CustomerTypeId = CustomerTypeId;
            this.FirstName = FirstName;
            this.LastName = LastName;
            this.Email = Email;
        }

        #endregion Constructors

        #region Fields

        private int? _CustomerId = 0;
        /// <summary>
        /// Set to 0 for an insert, existing customer id for an update
        /// </summary>
        [Required]
        public int? CustomerId
        {
            get => _CustomerId;
            set => _CustomerId = value;
        }

        private byte? _CustomerTypeId;
        /// <summary>
        /// Set to one of the CustomerTypes, foreign key check
        /// </summary>
        [Required]
        [Display(Name = "Customer Type", Description = "Description")]
        public byte? CustomerTypeId
        {
            get => _CustomerTypeId;
            set => _CustomerTypeId = value;
        }

        private string? _FirstName;
        /// <summary>
        /// Customers first (given) name
        /// </summary>
        [MaxLength(64)]
        [Required]
        [Display(Name = "First Name", Description = "Description")]
        public string? FirstName
        {
            get => _FirstName;
            set => _FirstName = value;
        }

        private string? _LastName;
        /// <summary>
        /// Customers last (family) name
        /// </summary>
        [MaxLength(64)]
        [Required]
        [Display(Name = "Last Name", Description = "Description")]
        public string? LastName
        {
            get => _LastName;
            set => _LastName = value;
        }

        private string? _Email;
        /// <summary>
        /// Customers primary email address
        /// </summary>
        [MaxLength(256)]
        [Required]
        [EmailAddress]
        public string? Email
        {
            get => _Email;
            set => _Email = value;
        }

        #endregion

    }
}