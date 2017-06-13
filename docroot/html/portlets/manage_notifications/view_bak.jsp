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
<%@ include file="../init.jsp" %>
<script src="http://cdn.alloyui.com/3.0.1/aui/aui-min.js"></script>
<link href="http://cdn.alloyui.com/3.0.1/aui-css/css/bootstrap.min.css" rel="stylesheet"></link>

<%

	PortletURL iteratorURL = renderResponse.createRenderURL();
	iteratorURL.setParameter("mvcPath",  "/html/portlets/manage_notifications/view.jsp");
	
	List<String> headerNames = new ArrayList<String>();
	
	headerNames.add("dossier");
	headerNames.add("action-name");
	headerNames.add("notes");
	headerNames.add("notification-date");
	
	String headers = StringUtil.merge(headerNames, StringPool.COMMA);
	
	String previousPageUrl = "javascript:history.go(-1);";

%>

<liferay-ui:header backURL="<%=previousPageUrl %>" title=""/>

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
			
			String boldLabel = "bold-label";
			if(userNotificationBean.isArchived()){
				
				boldLabel= StringPool.BLANK;
				
			}
			
			%>
				<liferay-util:buffer var="dossier">
					<a href="<%=userNotificationBean.getUrl()%>">
						<div class="span12 <%=boldLabel%>">
							<%=userNotificationBean.getReceptionNo().length() > 0 ? userNotificationBean.getReceptionNo() : userNotificationBean.getDossierId() %>
						</div>
					</a>
				</liferay-util:buffer>
				
				<liferay-util:buffer var="actionNname">
					<a href="<%=userNotificationBean.getUrl()%>">
						
						<div class="span12 <%=boldLabel%>">
							<%=userNotificationBean.getActionName() %>
						</div>
					</a>
				</liferay-util:buffer>
				
				<liferay-util:buffer var="notes">
					<a href="<%=userNotificationBean.getUrl()%>">
						<div class="span12 <%=boldLabel%>">
							<%=userNotificationBean.getNote() %>
						</div>
					</a>
				</liferay-util:buffer>
				
				<liferay-util:buffer var="notificationDate">
					<a href="<%=userNotificationBean.getUrl()%>">
						<div class="span12 <%=boldLabel%>">
							<%=userNotificationBean.getCreateDate() %>
						</div>
					</a>
				
				</liferay-util:buffer>
				<%
					row.setClassName("opencps-searchcontainer-row");
					row.addText(dossier);
					row.addText(actionNname);
					row.addText(notes);
					row.addText(notificationDate);
					
				%>

			</liferay-ui:search-container-row>
			<liferay-ui:search-iterator type="opencs_page_iterator"/>
	</liferay-ui:search-container>
	
</div>

<aui:script use="aui-base,mark-as-read">		
// 	var nonActionableNotificationsList = new Liferay.MarkAsRead(
// 		{
// 			notificationsContainer: '.dashboard-non-actionable',
// 			notificationsNode: '.main-user-notifications',
// 		}
// 	);
</aui:script>