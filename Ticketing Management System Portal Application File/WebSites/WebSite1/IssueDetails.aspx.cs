using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class IssueDetails : System.Web.UI.Page
{
    protected void Reassign_Click(object sender, EventArgs e)
    {

        using (SqlConnection con = new SqlConnection(
        System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
        {

            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "uspReassignTicket";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("deptId", ddlDepartment.SelectedValue);
            cmd.Parameters.AddWithValue("IssueId", Request.QueryString["id"]);
            cmd.Connection = con;
            con.Open();
            cmd.ExecuteNonQuery();


        }
    }
    protected void Close_Click(object sender, EventArgs e)
    {

        using (SqlConnection con = new SqlConnection(
        System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
        {

            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "uspCloseTicket";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IssueId", Request.QueryString["id"]);
            cmd.Connection = con;
            con.Open();
            cmd.ExecuteNonQuery();

            Response.Redirect("~/CreateTicket.aspx");


        }
    }
    protected override void OnLoadComplete(EventArgs e)
    {
        base.OnLoadComplete(e);
        if (!IsPostBack)
        {
            using (SqlConnection con = new SqlConnection(
            System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
            {

                using (SqlCommand command = new SqlCommand("select * from  [Departments]", con))
                {

                    con.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    ddlDepartment.Items.Add(new ListItem("Select a Department", "0"));
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