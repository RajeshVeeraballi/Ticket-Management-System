using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;
using System;
using System.Web;
using System.Web.UI;
using WebSite1;
using System.Data.SqlClient;
using System.Data;
public partial class Account_Login : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        RegisterHyperLink.NavigateUrl = "Register";
    }

    protected void LogIn(object sender, EventArgs e)
    {
        if (IsValid)
        {


            using (SqlConnection con = new SqlConnection(
            System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
            {


         //       using (SqlCommand command = new SqlCommand(
         //"INSERT INTO user_info VALUES (@user_id, @ur_id , @password , @role_id ,  @firstname ,  @lastname ,  @email ,  @phone_number ,  @date)", con))
         //       {
         //           command.Parameters.Add(new SqlParameter("user_id", 1));
         //           command.Parameters.Add(new SqlParameter("ur_id", "123"));

         //           command.Parameters.Add(new SqlParameter("password", "xyz"));

         //           command.Parameters.Add(new SqlParameter("role_id", 1));
         //           command.Parameters.Add(new SqlParameter("firstname", UserName.Text));
         //           command.Parameters.Add(new SqlParameter("lastname", UserName.Text));
         //           command.Parameters.Add(new SqlParameter("email", "abc@gmail.com"));
         //           command.Parameters.Add(new SqlParameter("phone_number", 832));
         //           command.Parameters.Add(new SqlParameter("date", DateTime.Now));
         //           command.ExecuteNonQuery();
         //       }

                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "uspCheckIfUserExists";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("Name", UserName.Text);
                cmd.Parameters.AddWithValue("Password", Password.Text);
                var returnParameter = cmd.Parameters.Add("@Exists", SqlDbType.Int);
                returnParameter.Direction = ParameterDirection.ReturnValue;

                cmd.Connection = con;

                con.Open();


                cmd.ExecuteNonQuery();
                var result = returnParameter.Value;

                if(Convert.ToInt32(result)==0)
                {
                    Response.Redirect("~/Account/Register.aspx");

                }
                else
                {
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
                con.Close();
            }
        }
    }
}