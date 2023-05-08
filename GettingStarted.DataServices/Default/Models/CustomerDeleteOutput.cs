// --------------------------------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by the SQL  Code Generation Utility.
//     Changes to this file may cause incorrect behavior and will be lost if the code is regenerated.
//     Underlying Routine: CustomerDelete
//     Last Modified On: 5/1/2023 1:25:39 AM
//     Written By: alan@sqlplus.net
//     Select Type: NonQuery
//     Visit https://www.SQLPLUS.net for more information about the SQL Plus build time ORM.
// </auto-generated>
// --------------------------------------------------------------------------------------------------------
namespace GettingStarted.DataServices.Default.Models
{
    #nullable enable

    /// <summary>
    /// Output object for CustomerDelete service.
    /// </summary>
    public partial class CustomerDeleteOutput
    {

        #region Return Value Enumerations

        /// <summary>
        /// Enumerated return values based on the ReturnTags in the procedure.
        /// </summary>
        public enum Returns
        {
            /// <summary>
            /// No record was deleted
            /// </summary>
             NotFound = 101,
            /// <summary>
            /// Customer was deleted
            /// </summary>
             OK = 1
        }

        #endregion Return Value Enumerations

        #region Return Value

        /// <summary>
        /// Enumerated return value.
        /// </summary>
        public Returns ReturnValue { set; get; }

        #endregion Return Value
    }









}
