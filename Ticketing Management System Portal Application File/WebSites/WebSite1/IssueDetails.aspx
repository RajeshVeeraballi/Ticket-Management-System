<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeFile="IssueDetails.aspx.cs" Inherits="IssueDetails" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">


     <div class="jumbotron">
        <h1>Close or Reassign ticket.</h1>

    <div class="form-horizontal">
        <hr />
        <div class="form-group">
            <asp:Label runat="server" CssClass="col-md-2 control-label">Reassign Ticket</asp:Label>
            <div class="col-md-10">
                <asp:DropDownList ID="ddlDepartment" runat="server"></asp:DropDownList>
            </div>
        </div>
        <div class="form-group">
            <div class="col-md-offset-2 col-md-10">
                <asp:Button runat="server" OnClick="Reassign_Click" Text="Reassign Ticket" CssClass="btn btn-primary btn-lg" />
            </div>
        </div>
    </div>
             </div>

    <div class="jumbotron">
        <h4>If you think the issue has been resolved just click here to close the ticket.</h4>
            <div class="col-md-offset-2 col-md-10">
                <asp:Button runat="server" OnClick="Close_Click" Text="close" CssClass="btn btn-primary btn-lg" />
            </div>
        <br />
        </div>


</asp:Content>
