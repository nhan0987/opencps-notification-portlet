<%@page import="javax.portlet.ActionRequest"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@ include file="../init.jsp" %>
<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>
	<%
	int unreadUserNotificationsCount = UserNotificationEventLocalServiceUtil.getArchivedUserNotificationEventsCount(themeDisplay.getUserId(), false);

	long notificationsPlid = themeDisplay.getPlid();
	

	if (layout.isTypeControlPanel()) {
		notificationsPlid = LayoutLocalServiceUtil.getDefaultPlid(user.getGroupId(), true);

		if (notificationsPlid == LayoutConstants.DEFAULT_PLID) {
			Group guestGroup = GroupLocalServiceUtil.getGroup(user.getCompanyId(), GroupConstants.GUEST);

			notificationsPlid = LayoutLocalServiceUtil.getDefaultPlid(guestGroup.getGroupId(), false);
		}
	}
	%>
	
	<%
	
	PortletURL markAsReadUrl = renderResponse.createActionURL();
	markAsReadUrl.setParameter(ActionRequest.ACTION_NAME, "markAsRead");
	
	List<UserNotificationEvent> userNotificationEvents = new ArrayList<UserNotificationEvent>();
	
	
	int totalSize = 0;
	userNotificationEvents = UserNotificationEventLocalServiceUtil
			.getArchivedUserNotificationEvents(themeDisplay.getUserId(),
					false, 0, 5);

	totalSize = UserNotificationEventLocalServiceUtil
			.getArchivedUserNotificationEventsCount(
					themeDisplay.getUserId(), false);
	
	%>

	<li class="dashboard-user-notifications" id="<portlet:namespace />userNotifications">

		<div class="dashboard-user-notifications-container open">
			<ul class="dashboard-user-notifications-list">
				<div class="dashboard-non-actionable">
					<div class="dashboad-notifications-header">
						
						<liferay-portlet:renderURL plid="<%= notificationsPlid %>" portletName="<%= PortletKeys.MANAGE_NOTIFICATIONS_PORTLET %>" var="viewAllNonActionableNotifications" windowState="<%= LiferayWindowState.MAXIMIZED.toString() %>">
							<portlet:param name="mvcPath" value="/html/portlets/manage_notifications/view.jsp" />
							<portlet:param name="actionable" value="<%= Boolean.FALSE.toString() %>" />
						</liferay-portlet:renderURL>
						
						<aui:row>
							<aui:col width="50">
								<span class="dashboad-header-message"><liferay-ui:message key="unread-notification" /> (<span class="dashboard-count"><%=totalSize %></span>)</span>
							</aui:col>
							<aui:col width="50">
								<span class="dashboad-header-viewAll"><a href="<%= viewAllNonActionableNotifications %>"><liferay-ui:message key="view-all" /></a></span>
							</aui:col>
						</aui:row>

					</div>

					<div class="main-user-notifications">
						<%for(UserNotificationEvent userNotificationEvent:userNotificationEvents){ 
							
							UserNotificationEventBean userNotificationBean = UserNotificationEventBean.getBean(userNotificationEvent, null, renderRequest,themeDisplay.getLocale(),themeDisplay.getTimeZone());
							
							markAsReadUrl.setParameter("userNotificationEventId", String.valueOf(userNotificationEvent.getUserNotificationEventId()));
						%>
							<li class="user-notification">
								<div class="clearfix user-notification-link" data-href="<%=userNotificationBean.getUrl() %>" data-markasreadurl="<%=markAsReadUrl%>">
									<aui:row>
										<aui:col width="50">
											<aui:row>
												<span>
													<%=LanguageUtil.get(locale, "profile") %> :<b><%=userNotificationBean.getReceptionNo().length() >0 ? userNotificationBean.getReceptionNo() : userNotificationBean.getDossierId()%></b>
												</span>
											</aui:row>
											<aui:row>
												<span>
													<%=LanguageUtil.get(locale, "actions") %> : <%=userNotificationBean.getActionName() %>
												</span>
											</aui:row>
											<aui:row>
												<span>
													<%=LanguageUtil.get(locale, "notes") %> : <%=userNotificationBean.getNote() %>
												</span>
											</aui:row>
										</aui:col>
										<aui:col width="50">
											<aui:row>
												<span>
													<%=userNotificationBean.getCreateDate() %>
												</span>
											</aui:row>
										</aui:col>
										
									</aui:row>
								</div>
							</li>
						<% }%>
					</div>
				</div>
			</ul>
			
		</div>

		<aui:script use="aui-base,mark-as-read">
			
			var nonActionableNotificationsList = new Liferay.MarkAsRead(
				{
					notificationsContainer: '.dashboard-non-actionable',
					notificationsNode: '.main-user-notifications',
					notificationsLinkClass :'.user-notification .user-notification-link'
				}
			);
		</aui:script>
	</li>
