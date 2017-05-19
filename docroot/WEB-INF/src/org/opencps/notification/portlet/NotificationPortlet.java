package org.opencps.notification.portlet;

import java.text.Format;
import java.util.ArrayList;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.PortletURL;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.portlet.WindowState;

import org.opencps.notification.utils.PortletKeys;
import org.opencps.notification.utils.PortletPropsValues;

import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.notifications.UserNotificationFeedEntry;
import com.liferay.portal.kernel.notifications.UserNotificationManagerUtil;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.util.FastDateFormatFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Time;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.UserNotificationEvent;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.portal.service.UserNotificationEventLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.util.ContentUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

public class NotificationPortlet extends MVCPortlet {

	public void processAction(ActionRequest actionRequest,
			ActionResponse actionResponse) throws PortletException {

		ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest
				.getAttribute(WebKeys.THEME_DISPLAY);

		if (!themeDisplay.isSignedIn()) {
			return;
		}

		try {
			String actionName = ParamUtil.getString(actionRequest,
					ActionRequest.ACTION_NAME);

			if (actionName.equals("markAsRead")) {
				markAsRead(actionRequest, actionResponse);
			}

			else {
				super.processAction(actionRequest, actionResponse);
			}
		} catch (Exception e) {
			throw new PortletException(e);
		}
	}

	public void markAsRead(ActionRequest actionRequest,
			ActionResponse actionResponse) throws Exception {

		long userNotificationEventId = ParamUtil.getLong(actionRequest,
				"userNotificationEventId");

		JSONObject jsonObject = JSONFactoryUtil.createJSONObject();

		try {
			updateArchived(userNotificationEventId);

			jsonObject.put("success", Boolean.TRUE);
		} catch (Exception e) {
			jsonObject.put("success", Boolean.FALSE);
		}

		writeJSON(actionRequest, actionResponse, jsonObject);
	}

	protected void updateArchived(long userNotificationEventId)
			throws Exception {

		com.liferay.portal.model.UserNotificationEvent userNotificationEvent = UserNotificationEventLocalServiceUtil
				.getUserNotificationEvent(userNotificationEventId);

		userNotificationEvent.setArchived(true);

		UserNotificationEventLocalServiceUtil
				.updateUserNotificationEvent(userNotificationEvent);
	}

	public void serveResource(ResourceRequest resourceRequest,
			ResourceResponse resourceResponse) throws PortletException {

		try {
			String resourceID = resourceRequest.getResourceID();

			if (resourceID.equals("getNotificationsCount")) {
				getNotificationsCount(resourceRequest, resourceResponse);
			} else if (resourceID.equals("getUserNotificationEvents")) {
				getUserNotificationEvents(resourceRequest, resourceResponse);
			}
		} catch (Exception e) {
			throw new PortletException(e);
		}
	}

	protected void getNotificationsCount(ResourceRequest resourceRequest,
			ResourceResponse resourceResponse) throws Exception {

		ThemeDisplay themeDisplay = (ThemeDisplay) resourceRequest
				.getAttribute(WebKeys.THEME_DISPLAY);

		JSONObject jsonObject = JSONFactoryUtil.createJSONObject();

		try {
			int newUserNotificationsCount = UserNotificationEventLocalServiceUtil
					.getArchivedUserNotificationEventsCount(
							themeDisplay.getUserId(), false);

			jsonObject.put("timestamp",
					String.valueOf(System.currentTimeMillis()));

			jsonObject.put("unreadUserNotificationsCount",
					newUserNotificationsCount);

			jsonObject.put("success", Boolean.TRUE);
		} catch (Exception e) {
			jsonObject.put("success", Boolean.FALSE);
		}

		writeJSON(resourceRequest, resourceResponse, jsonObject);
	}

	protected void getUserNotificationEvents(ResourceRequest resourceRequest,
			ResourceResponse resourceResponse) throws Exception {

		ThemeDisplay themeDisplay = (ThemeDisplay) resourceRequest
				.getAttribute(WebKeys.THEME_DISPLAY);

		int start = ParamUtil.getInteger(resourceRequest, "start",
				QueryUtil.ALL_POS);
		int end = ParamUtil.getInteger(resourceRequest, "end",
				QueryUtil.ALL_POS);

		List<UserNotificationEvent> unreadUserNotificationEvents = new ArrayList<UserNotificationEvent>();
		int total = 0;

		unreadUserNotificationEvents = UserNotificationEventLocalServiceUtil
				.getArchivedUserNotificationEvents(themeDisplay.getUserId(),
						false, start, end);

		total = UserNotificationEventLocalServiceUtil
				.getArchivedUserNotificationEventsCount(
						themeDisplay.getUserId(), false);

		JSONArray jsonArray = JSONFactoryUtil.createJSONArray();

		List<Long> unreadUserNotificationEventIds = new ArrayList<Long>();

		for (UserNotificationEvent unreadUserNotificationEvent : unreadUserNotificationEvents) {

			String entry = renderEntry(resourceRequest, resourceResponse,
					unreadUserNotificationEvent);

			if (Validator.isNotNull(entry)) {
				jsonArray.put(entry);

				if (!unreadUserNotificationEvent.isArchived()) {
					unreadUserNotificationEventIds.add(unreadUserNotificationEvent
							.getUserNotificationEventId());
				}
			}
		}

		JSONObject jsonObject = JSONFactoryUtil.createJSONObject();

		jsonObject.put("entries", jsonArray);

		jsonObject.put("unreadTotalUserNotificationEventsCount",
				unreadUserNotificationEvents.size());

		jsonObject.put("unreadUserNotificationEventIds",
				StringUtil.merge(unreadUserNotificationEventIds));

		jsonObject.put("total", total);

		writeJSON(resourceRequest, resourceResponse, jsonObject);
	}

	protected String renderEntry(ResourceRequest resourceRequest,
			ResourceResponse resourceResponse,
			UserNotificationEvent portalUserNotificationEvent) throws Exception {

		ThemeDisplay themeDisplay = (ThemeDisplay) resourceRequest
				.getAttribute(WebKeys.THEME_DISPLAY);

		if (Validator.isNotNull(portalUserNotificationEvent)) {

			UserNotificationFeedEntry userNotificationFeedEntry = UserNotificationManagerUtil
					.interpret(StringPool.BLANK, portalUserNotificationEvent,
							ServiceContextFactory.getInstance(resourceRequest));

			if (Validator.isNull(userNotificationFeedEntry)) {

				return StringPool.BLANK;
			}

			LiferayPortletResponse liferayPortletResponse = (LiferayPortletResponse) resourceResponse;

			PortletURL actionURL = liferayPortletResponse
					.createActionURL(PortletKeys.NOTIFICATIONS);

			actionURL.setParameter("userNotificationEventId", String
					.valueOf(portalUserNotificationEvent
							.getUserNotificationEventId()));

			actionURL.setWindowState(WindowState.NORMAL);
			actionURL.setParameter(ActionRequest.ACTION_NAME, "markAsRead");

			String actionDiv = StringPool.BLANK;

			actionDiv = StringUtil
					.replace(_MARK_AS_READ_DIV, new String[] { "[$LINK$]",
							"[$MARK_AS_READ_URL$]" },
							new String[] { userNotificationFeedEntry.getLink(),
									actionURL.toString() });

			Format simpleDateFormat = FastDateFormatFactoryUtil
					.getSimpleDateFormat("EEEE, MMMMM dd, yyyy 'at' h:mm a",
							themeDisplay.getLocale(),
							themeDisplay.getTimeZone());

			return StringUtil
					.replace(
							ContentUtil
									.get(PortletPropsValues.USER_NOTIFICATION_ENTRY),
							new String[] { "[$ACTION_DIV$]", "[$BODY$]",
									"[$TIMESTAMP$]" },
							new String[] {
									actionDiv,
									userNotificationFeedEntry.getBody(),
									Time.getRelativeTimeDescription(
											portalUserNotificationEvent
													.getTimestamp(),
											themeDisplay.getLocale(),
											themeDisplay.getTimeZone()),
									simpleDateFormat
											.format(portalUserNotificationEvent
													.getTimestamp()), });
		}

		return StringPool.BLANK;
	}

	private static final String _DELETE_DIV = "<div class=\"clearfix user-notification-delete\" data-deleteURL=\""
			+ "[$DELETE_URL$]\">";

	private static final String _MARK_AS_READ_DIV = "<div class=\"clearfix user-notification-link\" data-href=\""
			+ "[$LINK$]\" data-markAsReadURL=\"[$MARK_AS_READ_URL$]\">";

	private static final String _MARK_AS_READ_ICON = "<div class=\"mark-as-read\" \"><i class=\""
			+ "icon-remove\"></i></div>";
}