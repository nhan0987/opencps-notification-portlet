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



<%@ include file="../init.jsp" %>


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

	<li class="dockbar-user-notifications dropdown toggle-controls" id="<portlet:namespace />userNotifications">
		<a class="dropdown-toggle user-notification-link" href="javascript:;">
			<span class='user-notifications-count <%= (unreadUserNotificationsCount > 0) ? "alert" : StringPool.BLANK %>' id="<portlet:namespace />userNotificationsCount"><%= unreadUserNotificationsCount %></span>
		</a>

		<div class="dockbar-user-notifications-container">
			<ul class="dropdown-menu pull-right user-notifications-list">
				<div class="non-actionable">
					<div class="user-notifications-header">

<%-- 						<portlet:actionURL var="viewAllNonActionableNotifications"> --%>
<%-- 							<portlet:param name="struts_action" value="/manage_notifications/view" /> --%>
<%-- 						</portlet:actionURL> --%>
						
						<liferay-portlet:renderURL plid="<%= notificationsPlid %>" portletName="<%= PortletKeys.MANAGE_NOTIFICATIONS_PORTLET %>" var="viewAllNonActionableNotifications" windowState="<%= LiferayWindowState.MAXIMIZED.toString() %>">
							<portlet:param name="mvcPath" value="/html/portlets/manage_notifications/view.jsp" />
							<portlet:param name="actionable" value="<%= Boolean.FALSE.toString() %>" />
						</liferay-portlet:renderURL>
						
<%-- 						<span class="header-message"><liferay-ui:message key="notifications" /> (<span class="count"></span>)</span> --%>
						<span class="header-viewAll"><a href="<%= viewAllNonActionableNotifications %>"><liferay-ui:message key="view-all" /></a></span>

<%-- 						<span class="mark-all-as-read"><a class="hide" href="javascript:;"><liferay-ui:message key="mark-as-read" /></a></span> --%>
					</div>

					<div class="user-notifications"></div>
					
					<div class="user-notification-footer">
						<a class="user-notification-close" href="javascript:;" style="color:red;"><liferay-ui:message key="close" /></a>
					</div>
				</div>
			</ul>
			
		</div>

		<aui:script use="aui-base,liferay-plugin-dockbar-notifications,liferay-plugin-notifications-list">
			
			var nonActionableNotificationsList = new Liferay.NotificationsList(
				{
					actionable: <%= false %>,
					baseActionURL: '<%= PortletURLFactoryUtil.create(request, portletDisplay.getId(), themeDisplay.getPlid(), PortletRequest.ACTION_PHASE) %>',
					baseRenderURL: '<%= PortletURLFactoryUtil.create(request, portletDisplay.getId(), themeDisplay.getPlid(), PortletRequest.RENDER_PHASE) %>',
					baseResourceURL: '<%= PortletURLFactoryUtil.create(request, portletDisplay.getId(), themeDisplay.getPlid(), PortletRequest.RESOURCE_PHASE) %>',
					markAllAsReadNode: '',
					namespace: '<portlet:namespace />',
					notificationsContainer: '.dockbar-user-notifications .dockbar-user-notifications-container .user-notifications-list .non-actionable',
					unreadNotificationsCount: null,
					notificationsNode: '.user-notifications',
					portletKey: '<%= portletDisplay.getId() %>'
				}
			);

			new Liferay.DockbarNotifications(
				{
					actionableNotificationsList: null,
					baseActionURL: '<%= PortletURLFactoryUtil.create(request, portletDisplay.getId(), themeDisplay.getPlid(), PortletRequest.ACTION_PHASE) %>',
					baseResourceURL: '<%= PortletURLFactoryUtil.create(request, portletDisplay.getId(), themeDisplay.getPlid(), PortletRequest.RESOURCE_PHASE) %>',
					nonActionableNotificationsList: nonActionableNotificationsList,
					portletKey: '<%= portletDisplay.getId() %>'
				}
			);
		</aui:script>
	</li>
