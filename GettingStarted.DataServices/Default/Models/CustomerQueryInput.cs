// --------------------------------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by the SQL PLUS Code Generation Utility.
//     Changes to this file may cause incorrect behavior and will be lost if the code is regenerated.
//     Underlying Routine: CustomerQuery
//     Last Modified On: 5/1/2023 1:25:39 AM
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
    /// Input object for the CustomerQuery service.
    /// </summary>
    public partial class CustomerQueryInput : ValidInput
    {
        #region Constructors

        /// <summary>
        /// Empty constructor for CustomerQueryInput.
        /// </summary>
        public CustomerQueryInput() { }

        /// <summary>
        /// Parameterized constructor for CustomerQueryInput.
        /// </summary>
        /// <param name="PageSize">Supply a value in the range of 10-50</param>
        /// <param name="PageNumber">The page to return, default is 1</param>
        public CustomerQueryInput(int? PageSize, int? PageNumber)
        {
            this.PageSize = PageSize;
            this.PageNumber = PageNumber;
        }

        #endregion Constructors

        #region Fields

        private int? _PageSize = 10;
        /// <summary>
        /// Supply a value in the range of 10-50
        /// </summary>
        [Required]
        [Range(typeof(int), "10", "50")]
        public int? PageSize
        {
            get => _PageSize;
            set => _PageSize = value;
        }

        private int? _PageNumber = 1;
        /// <summary>
        /// The page to return, default is 1
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