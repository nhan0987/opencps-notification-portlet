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

package org.opencps.notification.dockbarnotifications.poller;

import com.liferay.portal.kernel.poller.BasePollerProcessor;
import com.liferay.portal.kernel.poller.PollerRequest;
import com.liferay.portal.kernel.poller.PollerResponse;
import com.liferay.portal.service.UserNotificationEventLocalServiceUtil;

/**
 * @author nhanhoang
 */
public class DockbarNotificationsPollerProcessor extends BasePollerProcessor {


	protected void doReceive(
			PollerRequest pollerRequest, PollerResponse pollerResponse)
		throws Exception {

		setUserNotificationsCount(pollerRequest, pollerResponse);
	}


	protected void doSend(PollerRequest pollerRequest) throws Exception {
	}

	protected void setUserNotificationsCount(
			PollerRequest pollerRequest, PollerResponse pollerResponse)
		throws Exception {

		pollerResponse.setParameter(
			"timestamp", String.valueOf(System.currentTimeMillis()));

		int unreadUserNotificationsCount =
			UserNotificationEventLocalServiceUtil.
				getArchivedUserNotificationEventsCount(
					pollerRequest.getUserId(), false);

		pollerResponse.setParameter(
			"unreadUserNotificationsCount",
			String.valueOf(unreadUserNotificationsCount));
	}

}