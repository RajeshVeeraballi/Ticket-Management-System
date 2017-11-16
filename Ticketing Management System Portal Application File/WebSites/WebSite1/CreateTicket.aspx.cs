using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class CreateTicket : System.Web.UI.Page
{
    protected void CreateTicket_Click(object sender, EventArgs e)
    {
        using (SqlConnection con = new SqlConnection(
         System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
        {

            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "uspCreateTicket";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IssueType", ddlIssueType.SelectedValue);
            cmd.Parameters.AddWithValue("@DeptId", ddlDepartment.SelectedValue);
            cmd.Parameters.AddWithValue("@UserId", Session["UserId"]);
            cmd.Parameters.AddWithValue("@Description", txtIssue.Text);
            cmd.Connection = con;
            con.Open();


            cmd.ExecuteNonQuery();

        }
    }

    protected override void OnInitComplete(EventArgs e)
    {
        base.OnInitComplete(e);

        if(!Page.IsPostBack)
        {
            using (SqlConnection con = new SqlConnection(
            System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
            {

                using (SqlCommand command = new SqlCommand("select * from  issue_types", con))
                {

                    con.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    ddlIssueType.Items.Add(new ListItem("Select a Issue Type", "0"));
                    while (reader.Read())
                    {
                        ListItem newItem = new ListItem();
                        newItem.Value = reader["issue_type_id"].ToString();
                        newItem.Text = reader["issue_type"].ToString();
                        ddlIssueType.Items.Add(newItem);
                    }
                    reader.Close();

                }

                using (SqlCommand command = new SqlCommand("select * from  [dbo].[Departments]", con))
                {

                    SqlDataReader reader = command.ExecuteReader();

                    ddlDepartment.Items.Add(new ListItem("Select a Department Type", "0"));
                    while (reader.Read())
                    {
                        ListItem newItem = new ListItem();
                        newItem.Value = reader["dept_id"].ToString();
                        newItem.Text = reader["dept_name"].ToString();
                        ddlDepartment.Items.Add(newItem);
                    }
                    reader.Close();

                }
            }
        }
    }

}