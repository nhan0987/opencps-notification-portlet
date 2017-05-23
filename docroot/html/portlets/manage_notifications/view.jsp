<%@page import="org.opencps.notification.utils.UserNotificationEventBean"%>
<%@page import="com.liferay.portal.kernel.util.StringUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.service.UserNotificationEventLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.dao.search.SearchContainer"%>
<%@page import="com.liferay.portal.model.UserNotificationEvent"%>
<%@page import="javax.portlet.PortletURL"%>
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
<%@ include file="init.jsp" %>

<%

	PortletURL iteratorURL = renderResponse.createRenderURL();
	iteratorURL.setParameter("mvcPath",  "/html/portlets/manage_notifications/view.jsp");
	
	List<String> headerNames = new ArrayList<String>();
	
	headerNames.add("boundcol1");
	headerNames.add("boundcol2");
	
	String headers = StringUtil.merge(headerNames, StringPool.COMMA);

%>
<div class="opencps-searchcontainer-wrapper">

	<div class="opcs-serviceinfo-list-label">
		<div class="title_box">
			<p class="file_manage_title"><liferay-ui:message key="user-notification-list"/></p>
			<p class="count"></p>
		</div>
	</div>

	<liferay-ui:search-container 
			emptyResultsMessage="you-do-not-have-any-new-notifications"
			iteratorURL="<%=iteratorURL %>"
			delta="<%=20 %>"
			deltaConfigurable="true"
			headerNames="<%=headers %>"
			>
			<liferay-ui:search-container-results>
				<%
				
				List<UserNotificationEvent> userNotificationEvents = new ArrayList<UserNotificationEvent>();
				
				int totalSize = 0;
				userNotificationEvents = UserNotificationEventLocalServiceUtil
						.getUserNotificationEvents(themeDisplay.getUserId(), searchContainer.getStart(), searchContainer.getEnd());

				totalSize = UserNotificationEventLocalServiceUtil
						.getUserNotificationEventsCount(themeDisplay.getUserId());

				searchContainer.setResults(userNotificationEvents);
				searchContainer.setTotal(totalSize);
					
					
				%>
			</liferay-ui:search-container-results>
			
			<liferay-ui:search-container-row 
				className="com.liferay.portal.model.UserNotificationEvent" 
				modelVar="userNotificationEvent" 
				keyProperty="userNotificationEventId"
			>
			
			<%
			UserNotificationEventBean userNotificationBean = UserNotificationEventBean.getBean(userNotificationEvent, null, renderRequest,themeDisplay.getLocale(),themeDisplay.getTimeZone());
			
			%>
				<liferay-util:buffer var="boundcol1">
					<a href="<%=userNotificationBean.getUrl()%>">
						<div class="row-fluid">
							<div class="row-fluid">
								<div class="span2 bold-label">
									<liferay-ui:message key="dossier"/>
								</div>
								<div class="span10">
									<%=userNotificationBean.getReceptionNo().length() > 0 ? userNotificationBean.getReceptionNo() : userNotificationBean.getDossierId() %>
								</div>
							</div>
						</div>
						
						<div class="row-fluid">
							
							<div class="span2 bold-label">
								 <liferay-ui:message key="action-name"/>
							</div>
							
							<div class="span10">
								<%=userNotificationBean.getActionName() %>
							</div>
						</div>
						
						<div class="row-fluid">
							
							<div class="span2 bold-label">
								 <liferay-ui:message key="notes"/>
							</div>
							
							<div class="span10">
								<%=userNotificationBean.getNote() %>
							</div>
						</div>
					</a>
				</liferay-util:buffer>
				
				
				<liferay-util:buffer var="boundcol2">
				
				<a href="<%=userNotificationBean.getUrl()%>">
					
					<div class="row-fluid">
						
						<div class="span5 bold-label">
							 <liferay-ui:message key="create-date"/>
						</div>
						
						<div class="span7">
							<%=userNotificationBean.getCreateDate() %>
						</div>
						
					</div>
				</a>
				
				</liferay-util:buffer>
				<%
					row.setClassName("opencps-searchcontainer-row");
					row.addText(boundcol1);
					row.addText(boundcol2);
				%>

			</liferay-ui:search-container-row>
			<liferay-ui:search-iterator type="opencs_page_iterator"/>
	</liferay-ui:search-container>
</div>