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
 * along with this program. If not, see <http://www.gnu.org/licenses/>
 */

package org.opencps.notification.utils;

import javax.portlet.RenderRequest;
import javax.portlet.WindowState;
import javax.portlet.WindowStateException;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.json.JSONException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.portlet.LiferayPortletURL;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.model.UserNotificationEvent;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;

/**
 * @author nhanhoang
 */

public class NotificationUtils {

	private static Log _log = LogFactoryUtil.getLog(NotificationUtils.class);


	
	public static String getLink(UserNotificationEvent userNotificationEvent,
			ServiceContext serviceContext, RenderRequest renderRequest)
			throws JSONException, WindowStateException {

		String pattern = StringPool.BLANK;
		long processOrderId = 0;
		long dossierId = 0;
		long paymentFileId = 0;

		LiferayPortletResponse liferayPortletResponse = null;

		LiferayPortletURL viewURL = null;

		try {

			if (Validator.isNotNull(renderRequest)
					&& Validator.isNull(serviceContext)) {
				
				try{

				serviceContext = ServiceContextFactory
						.getInstance(renderRequest);
				}catch(PortalException e){
					_log.error(e);
				}

			}

			liferayPortletResponse = serviceContext
					.getLiferayPortletResponse();
			

			JSONObject jsonObject = JSONFactoryUtil
					.createJSONObject(userNotificationEvent.getPayload());

			dossierId = jsonObject.getLong("dossierId");
			paymentFileId = jsonObject.getLong("paymentFileId");
			processOrderId = jsonObject.getLong("processOrderId");
			pattern = jsonObject.getString("patternConfig");

			long plId = jsonObject.getString("plId").trim().length() > 0 ? Long
					.parseLong(jsonObject.getString("plId")) : 0;

			if (pattern.toUpperCase().contains(PortletKeys.EMPLOYEE)
					&& paymentFileId <= 0 && processOrderId > 0) {

				if (Validator.isNull(viewURL)) {

					viewURL = liferayPortletResponse
							.createRenderURL(WebKeys.PROCESS_ORDER_PORTLET);
				}

				viewURL.setParameter("mvcPath",
						"/html/portlets/processmgt/processorder/process_order_detail.jsp");
				viewURL.setParameter("processOrderId",
						String.valueOf(processOrderId));
				viewURL.setPlid(plId);
				viewURL.setWindowState(WindowState.NORMAL);

			} else if (pattern.toUpperCase().contains(PortletKeys.CITIZEN)
					&& paymentFileId <= 0 && dossierId > 0) {

				if (Validator.isNull(viewURL)) {

					viewURL = liferayPortletResponse
							.createRenderURL(WebKeys.DOSSIER_MGT_PORTLET);
				}

				viewURL.setParameter("mvcPath",
						"/html/portlets/dossiermgt/frontoffice/edit_dossier.jsp");
				viewURL.setParameter("dossierId",
						String.valueOf(dossierId));
				viewURL.setParameter("isEditDossier", String.valueOf(false));
				viewURL.setPlid(plId);
				viewURL.setWindowState(WindowState.NORMAL);

			} else if (pattern.toUpperCase().contains(PortletKeys.EMPLOYEE)
					&& paymentFileId > 0) {

				if (Validator.isNull(viewURL)) {
					viewURL = liferayPortletResponse
							.createRenderURL(WebKeys.PAYMENT_MANAGER_PORTLET);
				}

				viewURL.setParameter("mvcPath",
						"/html/portlets/paymentmgt/backoffice/backofficepaymentdetail.jsp");
				viewURL.setParameter("paymentFileId",
						String.valueOf(paymentFileId));
				viewURL.setPlid(plId);
				viewURL.setWindowState(WindowState.NORMAL);

			} else if (pattern.toUpperCase().contains(PortletKeys.CITIZEN)
					&& paymentFileId > 0) {

				if (Validator.isNull(viewURL)) {
					viewURL = liferayPortletResponse
							.createRenderURL(WebKeys.PAYMENT_MGT_PORTLET);
				}

				viewURL.setParameter("mvcPath",
						"/html/portlets/paymentmgt/frontoffice/frontofficepaymentdetail.jsp");
				viewURL.setParameter("paymentFileId",
						String.valueOf(paymentFileId));
				viewURL.setPlid(plId);
				viewURL.setWindowState(WindowState.NORMAL);

			}

		} catch (Exception e) {
			_log.error(e);
		}
		
		
		return Validator.isNotNull(viewURL) ? viewURL.toString()
				: StringPool.BLANK;
	}
}
