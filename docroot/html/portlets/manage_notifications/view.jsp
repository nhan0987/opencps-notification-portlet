<%@page import="javax.portlet.ActionRequest"%>
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
	
	PortletURL markAsReadUrl = renderResponse.createActionURL();
	markAsReadUrl.setParameter(ActionRequest.ACTION_NAME, "markAsRead");

%>

<liferay-ui:header backURL="<%=previousPageUrl %>" title=""/>

<div class="opencps-searchcontainer-wrapper">
	<aui:row>
		<div class="opcs-serviceinfo-list-label">
			<div class="title_box">
				<p class="file_manage_title"><liferay-ui:message key="user-notification-list"/></p>
				<p class="count"></p>
			</div>
		</div>
	</aui:row>
		<%
		
		SearchContainer searchContainer = new SearchContainer(renderRequest, null, null, SearchContainer.DEFAULT_CUR_PARAM, 5, iteratorURL, null, "");
		
		List<UserNotificationEvent> userNotificationEvents = new ArrayList<UserNotificationEvent>();
		
		int totalSize = 0;
		
		userNotificationEvents = UserNotificationEventLocalServiceUtil
				.getUserNotificationEvents(themeDisplay.getUserId(), searchContainer.getStart(),searchContainer.getEnd());

		totalSize = UserNotificationEventLocalServiceUtil
				.getUserNotificationEventsCount(themeDisplay.getUserId());
		searchContainer.setResults(userNotificationEvents);
		searchContainer.setTotal(totalSize);

		%>
		<c:choose>
			<c:when test="<%=userNotificationEvents.size() > 0 %>">
				<div class="manage-non-actionable">
						
					<aui:row>
						<aui:col span="3" cssClass="bold-label"><liferay-ui:message key="dossier"/></aui:col>
						<aui:col span="3" cssClass="bold-label"><liferay-ui:message key="action-name"/></aui:col>
						<aui:col span="3" cssClass="bold-label"><liferay-ui:message key="notes"/></aui:col>
						<aui:col span="3" cssClass="bold-label"><liferay-ui:message key="notification-date"/></aui:col>
					</aui:row>
						
						
					<aui:row cssClass="manage-main-user-notifications">
						
						<%for(UserNotificationEvent userNotificationEvent:userNotificationEvents){
							
							UserNotificationEventBean userNotificationBean = UserNotificationEventBean
									.getBean(userNotificationEvent, null, renderRequest,themeDisplay.getLocale(),themeDisplay.getTimeZone());
							
							markAsReadUrl.setParameter("userNotificationEventId", String.valueOf(userNotificationEvent.getUserNotificationEventId()));
							
							String boldLabel = "bold-label";
							if(userNotificationBean.isArchived()){
								
								boldLabel= StringPool.BLANK;
								
							}
						%>
							<div class="manage-user-notification">
								<div data-href="<%=userNotificationBean.getUrl()%>" class="manage-user-notification-link click-able " data-markasreadurl="<%=markAsReadUrl%>">
									<aui:col span="3" cssClass="<%=boldLabel%>">
										<span >
											<%=userNotificationBean.getReceptionNo().length() > 0 ? userNotificationBean.getReceptionNo() : userNotificationBean.getDossierId() %>
										</span>
									</aui:col>
									<aui:col span="3" cssClass="<%=boldLabel%>">
										<span >
											<%=userNotificationBean.getActionName() %>
										</span>
									</aui:col>
									<aui:col span="3" cssClass="<%=boldLabel%>">
										<span >
											<%=userNotificationBean.getNote() %>
										</span>
									</aui:col>
									<aui:col span="3" cssClass="<%=boldLabel%>">
										<span >
											<%=userNotificationBean.getCreateDate() %>
										</span>
									</aui:col>
								</div>
							</div>
						<%} %>
						
					</aui:row>
					
					<aui:row>
						<liferay-ui:search-paginator searchContainer="<%= searchContainer %>" type="opencs_page_iterator"/>
					</aui:row>	
				</div>
				
				
			</c:when>
			<c:otherwise>
				<div class="alert alert-info">
					<liferay-ui:message key="no-user-notification-event-where-found" />
				</div>
			</c:otherwise>
		</c:choose>
		
			
	
</div>

<aui:script use="aui-base,mark-as-read">		
	var nonActionableNotificationsList = new Liferay.MarkAsRead(
		{
			notificationsContainer: '.manage-non-actionable',
			notificationsNode: '.manage-main-user-notifications',
			notificationsLinkClass :'.manage-user-notification .manage-user-notification-link'
		}
	);
</aui:script>