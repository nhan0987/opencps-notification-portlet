/**
 * OpenCPS is the open source Core Public Services software
 * Copyright (C) 2016-present OpenCPS community

 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>
 */

package org.opencps.notification.portlet;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletPreferences;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.ConfigurationAction;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portlet.PortletPreferencesFactoryUtil;

public class ConfigurationActionImpl implements ConfigurationAction {

	@Override
	public void processAction(PortletConfig portletConfig,
			ActionRequest actionRequest, ActionResponse actionResponse)

	throws Exception {

		String portletResource = ParamUtil.getString(actionRequest,
				"portletResource");

		PortletPreferences prefs = PortletPreferencesFactoryUtil
				.getPortletSetup(actionRequest, portletResource);

		String duongThuyGroupCode = ParamUtil.getString(actionRequest,
				"duongThuyGroupCode");
		String duongSatGroupCode = ParamUtil.getString(actionRequest,
				"duongSatGroupCode");
		String dangKiemGroupCode = ParamUtil.getString(actionRequest,
				"dangKiemGroupCode");
		String hangKhongGroupCode = ParamUtil.getString(actionRequest,
				"hangKhongGroupCode");

		prefs.setValue("duongThuyGroupCode", duongThuyGroupCode);

		prefs.setValue("duongSatGroupCode", duongSatGroupCode);

		prefs.setValue("dangKiemGroupCode", dangKiemGroupCode);

		prefs.setValue("hangKhongGroupCode", hangKhongGroupCode);

		prefs.store();

		SessionMessages.add(actionRequest, "config-stored");

		SessionMessages.add(actionRequest, portletConfig.getPortletName()
				+ SessionMessages.KEY_SUFFIX_REFRESH_PORTLET, portletResource);

	}

	@Override
	public String render(PortletConfig portletConfig,
			RenderRequest renderRequest, RenderResponse renderResponse)
			throws Exception {
		return "/html/portlets/redirect_notification/configuration.jsp";
	}

	private static Log _log = LogFactoryUtil
			.getLog(ConfigurationActionImpl.class);
}
