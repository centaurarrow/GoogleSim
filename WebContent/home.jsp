<%@page session="true" %>
<%@ taglib uri="/struts-tags" prefix="s" %>

<s:if test="%{#session['isLoggedIN']}">
	<s:include value="includes/header.jsp"></s:include>
        <div id="wrapper">
            <div id="content">
                <div id="box">
                   	<h3 id="adduser">Welcome</h3>
                   	<div id="contentbody">
                   		This is a home page
                   	</div>
                </div>
             </div>
        </div>
	<s:include value="includes/footer.jsp"></s:include>
</s:if>
<s:else>
	<jsp:forward page="login.jsp"/>
</s:else> 
