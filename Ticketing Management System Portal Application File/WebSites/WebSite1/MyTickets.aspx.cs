using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class MyTickets : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!this.IsPostBack)
        {
            BindGrid();
        }
    }
    private void BindGrid()
    {
        
        using (SqlConnection con = new SqlConnection(
       System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
        {

            SqlCommand cmd = new SqlCommand();
            DataSet dataset = new DataSet();
            cmd.CommandText = "uspGetIssues";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("UserId", Session["UserId"]));
            cmd.Connection = con;
            con.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            using (DataTable dt = new DataTable())
            {
                adapter.Fill(dt);
                grdIssues.DataSource = dt;
                grdIssues.DataBind();
            }
        }
    }
    protected void OnPaging(object sender, GridViewPageEventArgs e)
    {
        grdIssues.PageIndex = e.NewPageIndex;
        grdIssues.DataBind();
    }
    protected void OnPageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdIssues.PageIndex = e.NewPageIndex;
        grdIssues.DataBind();
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            HyperLink hl = (HyperLink)e.Row.FindControl("link");
            if (hl != null)
            {
                DataRowView drv = (DataRowView)e.Row.DataItem;
                string id = drv["issue_id"].ToString();
                hl.NavigateUrl = "~/IssueDetails.aspx?id=" + id;
            }
        }
    }

}