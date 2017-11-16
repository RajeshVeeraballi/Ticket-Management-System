<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" MasterPageFile="~/Site.master" Inherits="Login" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <fieldset style="width: 200px;">
            <legend>Login page </legend>
            <asp:TextBox ID="txtusername" placeholder="username" runat="server"
                Width="180px"></asp:TextBox>
            <br />
            <br />
            <asp:TextBox ID="txtpassword" placeholder="password" runat="server"
                Width="180px" TextMode="Password"></asp:TextBox>
            <br />
            <br />
            <asp:Button ID="btnsubmit" runat="server" Text="Submit"
                Width="81px" OnClick="btnsubmit_Click" />
            <br />

        </fieldset>
    </div>


</asp:Content>

