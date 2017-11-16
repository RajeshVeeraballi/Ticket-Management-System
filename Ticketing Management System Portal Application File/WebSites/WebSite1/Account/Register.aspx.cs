using Microsoft.AspNet.Identity;
using System;
using System.Linq;
using System.Web.UI;
using System.Data;
using System.Data.SqlClient;

public partial class Account_Register : Page
{
    protected void CreateUser_Click(object sender, EventArgs e)
    {
        if (IsValid)
        {
            using (SqlConnection con = new SqlConnection(
            System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
            {

                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "uspCreateUser";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("UserName", UserName.Text);
                cmd.Parameters.AddWithValue("FirstName", txtFirstName.Text);
                cmd.Parameters.AddWithValue("LastName", txtLastName.Text);
                cmd.Parameters.AddWithValue("Password", Password.Text);
                cmd.Parameters.AddWithValue("Email", txtEmail.Text);
                cmd.Parameters.AddWithValue("Phone", txtphone.Text);
                var returnParameter = cmd.Parameters.Add("@UserId", SqlDbType.Int);
                returnParameter.Direction = ParameterDirection.ReturnValue;
                cmd.Connection = con;
                con.Open();
                cmd.ExecuteNonQuery();
                var result = returnParameter.Value;

                if (Session["UserId"] == null)
                    Session["UserId"] = result;
                else
                {
                    Session.Remove("UserId");
                    Session["UserId"] = result;

                }

                if (Session["UserName"] == null)
                    Session["UserName"] = UserName.Text;
                else
                {
                    Session.Remove("UserName");
                    Session["UserName"] = UserName.Text;

                }

                Response.Redirect("~/MyTickets.aspx");


            }
        }
    }
}