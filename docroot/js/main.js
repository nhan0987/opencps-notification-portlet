AUI.add(
	'liferay-plugin-dockbar-notifications',
	function(A) {
		var DockbarNotifications = A.Component.create(
			{
				AUGMENTS: [Liferay.PortletBase],

				EXTENDS: A.Base,

				NAME: 'dockbarnotifications',

				prototype: {
					initializer: function(config) {
						var instance = this;

						instance._actionableNotificationsList = config.actionableNotificationsList;
						instance._baseActionURL = config.baseActionURL;
						instance._baseResourceURL = config.baseResourceURL;
						instance._nonActionableNotificationsList = config.nonActionableNotificationsList;
						instance._portletKey = config.portletKey;

						var userNotifications = A.one('.dockbar-user-notifications');

						userNotifications.on(
							'click',
							function(event) {
								var target = event.target;

								if (target.ancestor('.dockbar-user-notifications-container')) {
									return;
								}

								instance._setDelivered();

								var currentTarget = event.currentTarget;

								var container = currentTarget.one('.dockbar-user-notifications-container');
								
								container.toggleClass('open');

								var menuOpen = container.hasClass('open');
								

								if (menuOpen) {
									currentTarget.on(
										'clickoutside',
										function(event) {
											container.removeClass('open');
										}
									);

									instance._nonActionableNotificationsList.render();
									/*instance._actionableNotificationsList.render();*/
								}
							}
						);
						
						var userNotificationsClose = A.one('.user-notification-close');
						
						userNotificationsClose.on('click',function(event){
							
							var target = event.target;
							
							if (target.ancestor('.dockbar-user-notifications-container')) {
								
				

								var container = target.ancestor('.dockbar-user-notifications-container');
								
								console.log("container:"+container);

								var menuOpen = container.hasClass('open');

								if (menuOpen) {
									
									container.removeClass('open');
										
									

									instance._nonActionableNotificationsList.render();
									/*instance._actionableNotificationsList.render();*/
								}
							}
							
						});

						A.on(
							'domready',
							function() {
								Liferay.Poller.addListener(instance._portletKey, instance._onPollerUpdate, instance);
							}
						);

						Liferay.on('updateNotificationsCount', instance._getNotificationsCount, instance);
					},

					_getNotificationsCount: function() {
						var instance = this;

						var portletURL = new Liferay.PortletURL.createURL(instance._baseResourceURL);

						portletURL.setResourceId('getNotificationsCount');

						A.io.request(
							portletURL.toString(),
							{
								dataType: 'JSON',
								on: {
									success: function() {
										var response = this.get('responseData');

										if (response) {
											var newUserNotificationsCount = response.newUserNotificationsCount;
											var timestamp = response.timestamp;
											var unreadUserNotificationsCount = response.unreadUserNotificationsCount;

											instance._updateDockbarNotificationsCount(newUserNotificationsCount, timestamp, unreadUserNotificationsCount);
										}
									}
								}
							}
						);
					},

					_onPollerUpdate: function(response) {
						var instance = this;

						instance._updateDockbarNotificationsCount(response.newUserNotificationsCount, response.timestamp, response.unreadUserNotificationsCount);
					},

					_setDelivered: function() {
						
					},

					_updateDockbarNotificationsCount: function(newUserNotificationsCount, timestamp, unreadUserNotificationsCount) {
						var instance = this;

						if (!instance._previousTimestamp || (instance._previousTimestamp < timestamp)) {
							instance._previousTimestamp = timestamp;

							var dockbarUserNotificationsCount = A.one('.dockbar-user-notifications .user-notifications-count');

							if (dockbarUserNotificationsCount) {
								dockbarUserNotificationsCount.toggleClass('alert', (newUserNotificationsCount > 0));

								dockbarUserNotificationsCount.setHTML(unreadUserNotificationsCount);
							}
						}
					}
				}
			}
		);

		Liferay.DockbarNotifications = DockbarNotifications;
	},
	'',
	{
		requires: ['aui-base', 'aui-io', 'liferay-poller', 'liferay-portlet-base', 'liferay-portlet-url']
	}

);

AUI.add(
	'liferay-plugin-notifications-list',
	function(A) {
		var Lang = A.Lang;

		var NotificationsList = A.Component.create(
			{
				AUGMENTS: [Liferay.PortletBase],

				EXTENDS: A.Base,

				NAME: 'notificationslist',

				prototype: {
					initializer: function(config) {
						var instance = this;

						instance._actionable = config.actionable;
						instance._baseActionURL = config.baseActionURL;
						instance._baseRenderURL = config.baseRenderURL;
						instance._baseResourceURL = config.baseResourceURL;
						instance._namespace = config.namespace;
						instance._notificationsContainer = config.notificationsContainer;
						instance._unreadNotificationsCount = config.unreadNotificationsCount;
						instance._notificationsNode = config.notificationsNode;
						instance._portletKey = config.portletKey;
						
						instance._delta = config.delta;
						instance._end = config.start + config.delta;
						instance._start = config.start;
						instance._paginationInfoNode = config.paginationInfoNode;
						instance._previousPageNode = config.previousPageNode;
						instance._nextPageNode = config.nextPageNode;
						instance._fullView = config.fullView;
						instance._markAllAsReadNode = config.markAllAsReadNode;

						instance._bindUI();
					},

					getStart: function() {
						
					},

					render: function() {
						var instance = this;

						var notificationsContainer = A.one(instance._notificationsContainer);

						var notificationsNode = notificationsContainer.one(instance._notificationsNode);

						notificationsNode.plug(A.LoadingMask);

						notificationsNode.loadingmask.show();

						var portletURL = new Liferay.PortletURL.createURL(instance._baseResourceURL);

						portletURL.setResourceId('getUserNotificationEvents');

						A.io.request(
							portletURL.toString(),
							{
								dataType: 'JSON',
								on: {
									success: function() {
										var response = this.get('responseData');

										if (response) {
											var total = response.total;

											var notificationsCountNode = notificationsContainer.one(instance._unreadNotificationsCount);

											if (notificationsCountNode) {
												notificationsCountNode.setHTML(total);
											}

											var entries = [];

											var entriesJSONArray = response.entries;

											if (entriesJSONArray) {
												for (var i = 0; i < entriesJSONArray.length; i++) {
													entries.push(entriesJSONArray[i]);
												}

												entries = entries.join('');
											}

											var hasEntries = (entriesJSONArray.length > 0);

											if (!hasEntries) {
												var message = Liferay.Language.get('you-do-not-have-any-notifications');

												notificationsNode.setHTML('<div class=\"message\">' + message + '</div>');

												
											}
											else {
												notificationsNode.setHTML(entries);

												
											}

											instance._unreadUserNotificationEventIds = response.unreadUserNotificationEventIds;

											notificationsNode.loadingmask.hide();
										}
									}
								}
							}
						);

						Liferay.fire('updateNotificationsCount');
					},

					setActionable: function(actionable) {
						
					},

					setUnreadNotificationsCount: function(unreadNotificationsCount) {
						var instance = this;

						instance._unreadNotificationsCount = unreadNotificationsCount;
					},

					setStart: function(start) {
						
					},

					_bindMarkAllAsRead: function() {

					},

					_bindMarkAsRead: function() {
						var instance = this;

						var notificationsContainer = A.one(instance._notificationsContainer);

						var notificationsNode = notificationsContainer.one(instance._notificationsNode);

						if (notificationsNode) {
							notificationsNode.delegate(
								'click',
								function(event) {
									var currentTarget = event.currentTarget;

									var currentRow = currentTarget.ancestor('.user-notification');

									currentRow.plug(A.LoadingMask);

									currentRow.loadingmask.show();

									var userNotificationLink = currentRow.one('.user-notification-link');

									var markAsReadURL = userNotificationLink.attr('data-markAsReadURL');

									if (markAsReadURL) {
										A.io.request(
											markAsReadURL,
											{
												after: {
													success: function() {
														var responseData = this.get('responseData');

														if (responseData.success) {
															currentRow.loadingmask.hide();

															instance.render();
														}
													}
												},
												dataType: 'JSON'
											}
										);
									}
								},
								'.user-notification .mark-as-read'
							);
						}
					},

					_bindNextPageNotifications: function() {
						
					},

					_bindNotificationsAction: function() {
						
					},

					_bindPreviousPageNotifications: function() {
						
					},

					_bindUI: function() {
						var instance = this;
						
//						console.log("run _bindUI()");

//						instance._bindMarkAllAsRead();
//						instance._bindMarkAsRead();
//						instance._bindNotificationsAction();
//						instance._bindNextPageNotifications();
//						instance._bindPreviousPageNotifications();
						instance._bindViewNotification();
					},

					_bindViewNotification: function() {
						var instance = this;
						
//						console.log("run _bindViewNotification()");

						var notificationsContainer = A.one(instance._notificationsContainer);
						
//						console.log("+++notificationsContainer:"+notificationsContainer);

						var notificationsNode = notificationsContainer.one(instance._notificationsNode);
						
//						console.log("+++notificationsNode:"+notificationsNode);

						if (notificationsNode) {
							notificationsNode.delegate(
								'click',
								function(event) {
									var currentTarget = event.currentTarget;
									
//									console.log("+++currentTarget:"+currentTarget);

									var target = event.target;
									
//									console.log("+++currentTarget:"+target);
//									
//									console.log("+++target.hasClass('.mark-as-read'):"+target.hasClass('.mark-as-read'));
//									
//									console.log("+++target.ancestor('.mark-as-read'):"+target.ancestor('.mark-as-read'));
//									
//									console.log("+++target._node.tagName == 'A':"+target._node.tagName == 'A');

//									if (target.hasClass('.mark-as-read') || target.ancestor('.mark-as-read') || (target._node.tagName == 'A')) {
//										return;
//									}

									var uri = currentTarget.attr('data-href');
									
//									console.log("+++uri:"+uri);

									var markAsReadURL = currentTarget.attr('data-markAsReadURL');
									
//									console.log("+++markAsReadURL:"+markAsReadURL);

									if (markAsReadURL) {
										A.io.request(
											markAsReadURL,
											{
												after: {
													success: function() {
														var responseData = this.get('responseData');
														
//														console.log("+++responseData:"+responseData);

														if (responseData.success) {
															instance._redirect(uri);
														}
													}
												},
												dataType: 'JSON'
											}
										);
									}
									else {
										instance._redirect(uri);
									}
								},
								'.user-notification .user-notification-link'
							);
						}
					},

					_openWindow: function(uri) {
						return /p_p_state=(maximized|pop_up|exclusive)/.test(uri);
					},

					_redirect: function(uri) {
						var instance = this;
						
						console.log("uri:"+uri);
						if (uri) {
							if (instance._openWindow(uri)) {
								Liferay.Util.openWindow(
									{
										id: 'notificationsWindow',
										uri: uri
									}
								);
							}
							else {
								var topWindow = Liferay.Util.getTop();

								topWindow.location.href = uri;
							}
						}
					}
				}
			}
		);

		Liferay.NotificationsList = NotificationsList;
	},
	'',
	{
		requires: ['aui-base', 'aui-io', 'aui-loading-mask-deprecated', 'liferay-poller', 'liferay-portlet-base', 'liferay-portlet-url']
	}
);