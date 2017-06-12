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

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>

<%@page import="org.opencps.notification.utils.PortletPropsValues"%>
<%@page import="org.opencps.notification.utils.PortletKeys"%>

<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState" %>
<%@page import="com.liferay.portal.kernel.util.FastDateFormatFactoryUtil" %>
<%@page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@page import="com.liferay.portal.kernel.util.StringPool" %><%@page import="com.liferay.portal.model.Group" %>
<%@page import="com.liferay.portal.model.GroupConstants" %>
<%@page import="com.liferay.portal.model.LayoutConstants" %>
<%@page import="com.liferay.portal.model.UserNotificationDelivery" %>
<%@page import="com.liferay.portal.service.GroupLocalServiceUtil" %>
<%@page import="com.liferay.portal.service.UserNotificationDeliveryLocalServiceUtil" %>
<%@page import="com.liferay.portal.service.UserNotificationEventLocalServiceUtil" %>
<%@page import="com.liferay.portal.util.PortalUtil" %>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil" %>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringUtil"%>

<%@page import="com.liferay.portal.service.UserNotificationEventLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.dao.search.SearchContainer"%>
<%@page import="com.liferay.portal.model.UserNotificationEvent"%>

<%@page import="org.opencps.notification.utils.UserNotificationEventBean"%>

<%@page import="javax.portlet.PortletURL"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="java.text.Format" %>
<%@ page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.TreeMap" %>

<%@ page import="javax.portlet.PortletRequest" %>

<portlet:defineObjects />

<liferay-theme:defineObjects />
