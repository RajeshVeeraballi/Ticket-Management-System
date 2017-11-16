<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeFile="TrackIssueActivity.aspx.cs" Inherits="TrackIssueActivity" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="jumbotron">
        <h4>Enter your ticket Number in the below text box to track activity
            <asp:TextBox ID="txtissue" ssClass="form-control" runat="server"></asp:TextBox></h4>

        <div class="col-md-offset-2 col-md-10">
            <asp:Button runat="server" OnClick="Track_Click" Text="Track" CssClass="btn btn-primary btn-lg" />
        </div>
        <br />
    </div>


    <div class="jumbotron">
        <asp:GridView ID="grdIssues" runat="server" AutoGenerateColumns="false" AllowPaging="true"
            OnPageIndexChanging="OnPageIndexChanging" PageSize="10">
            <Columns>
                <asp:BoundField ItemStyle-Width="150px" DataField="issue_id" HeaderText="Issue Id" />
                <asp:BoundField ItemStyle-Width="150px" DataField="status_type" HeaderText="Issue Status" />
                <asp:BoundField ItemStyle-Width="150px" DataField="date_time" HeaderText="Changed On" />
            </Columns>
        </asp:GridView>
    </div>


</asp:Content>