<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MyTickets.aspx.cs" MasterPageFile="~/Site.master" Inherits="MyTickets" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <asp:GridView ID="grdIssues" runat="server" onrowdatabound="GridView1_RowDataBound" AutoGenerateColumns="false" AllowPaging="true"
            OnPageIndexChanging="OnPageIndexChanging" PageSize="10">
            <Columns>
                <asp:TemplateField HeaderText="Issue Id" ItemStyle-HorizontalAlign="Center" FooterStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:HyperLink ID="link" runat="server" Text='<%# Eval("issue_id") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField ItemStyle-Width="150px" DataField="issue_type" HeaderText="Issue Type" />
                <asp:BoundField ItemStyle-Width="150px" DataField="status_type" HeaderText="Issue Status" />
                <asp:BoundField ItemStyle-Width="150px" DataField="Description" HeaderText="Description" />
                <asp:BoundField ItemStyle-Width="150px" DataField="CreatedBy" HeaderText="Issued To" />
                <asp:BoundField ItemStyle-Width="150px" DataField="date" HeaderText="Created On" />
            </Columns>
        </asp:GridView>
    </div>


</asp:Content>
