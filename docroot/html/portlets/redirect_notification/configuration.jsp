
<%
/**
 * OpenCPS is the open source Core Public Services software
 * Copyright (C) 2016-present OpenCPS community
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
%>
<%@ include file="../init.jsp"%>
<%  

%>
<liferay-portlet:actionURL portletConfiguration="true" var="configurationURL">
</liferay-portlet:actionURL>


<aui:form action="<%= configurationURL.toString() %>" method="post"
	name="fm">


	<aui:input name="duongThuyGroupCode" type="textarea"  label="duong-thuy-page" value="<%=duongThuyGroupCode %>"/>
	<aui:input name="duongSatGroupCode" type="textarea" label="duong-sat-page" value="<%=duongSatGroupCode %>"/>
	<aui:input name="dangKiemGroupCode" type="textarea" label="dang-kiem-page" value="<%=dangKiemGroupCode %>"/>
	<aui:input name="hangKhongGroupCode" type="textarea" label="hang-khong-page" value="<%=hangKhongGroupCode %>"/>
	<aui:button type="submit" name="save" value="save" />

	
</aui:form>

<aui:script>
	
</aui:script>
