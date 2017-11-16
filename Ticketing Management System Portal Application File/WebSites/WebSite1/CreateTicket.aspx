<%@ Page Title="Create Ticket" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="CreateTicket.aspx.cs" Inherits="CreateTicket" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <h2><%: Title %>.</h2>
    <p class="text-danger">
        <asp:Literal runat="server" ID="ErrorMessage" />
    </p>

    <div class="form-horizontal">
        <hr />
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="ddlIssueType" CssClass="col-md-2 control-label">Issue Type</asp:Label>
            <div class="col-md-10">
                <asp:DropDownList ID="ddlIssueType" CssClass="form-control" runat="server">
                </asp:DropDownList>
            </div>
        </div>
                <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="ddlDepartment" CssClass="col-md-2 control-label">Select Department</asp:Label>
            <div class="col-md-10">
                <asp:DropDownList ID="ddlDepartment" CssClass="form-control" runat="server">
                </asp:DropDownList>
            </div>
        </div>

        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="txtIssue" CssClass="col-md-2 control-label">Issue Description</asp:Label>
            <div class="col-md-10">
                <asp:TextBox Columns="30" Rows="5" CssClass="form-control" TextMode="multiline" ID="txtIssue" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtIssue"
                    CssClass="text-danger" ErrorMessage="The description field is required." />
            </div>
        </div>

        <div class="form-group">
            <div class="col-md-offset-2 col-md-10">
                <asp:Button runat="server" OnClick="CreateTicket_Click" Text="Create Ticket" CssClass="btn btn-default" />
            </div>
        </div>
    </div>
</asp:Content>

