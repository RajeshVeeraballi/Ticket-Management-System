using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
public partial class TrackIssueActivity : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    private void BindGrid()
    {

        using (SqlConnection con = new SqlConnection(
       System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
        {

            SqlCommand cmd = new SqlCommand();
            DataSet dataset = new DataSet();
            cmd.CommandText = "uspGetIssueActivity";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("IssueId", Convert.ToInt32(txtissue.Text)));
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

    protected void OnPageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdIssues.PageIndex = e.NewPageIndex;
        grdIssues.DataBind();
    }

    protected void Track_Click(object sender, EventArgs args)
    {
        BindGrid();
    }


}