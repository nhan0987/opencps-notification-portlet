<%@page import="com.liferay.portlet.PortletURLUtil"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayPortletURL"%>
<%@ include file="../init.jsp" %>

<%
	String dossierId = ParamUtil.getString(request, "dossierId");
	String isEditDossier = ParamUtil.getString(request, "isEditDossier");
	String govAgencyCode = ParamUtil.getString(request, "govAgencyCode");
	String redirectPath = ParamUtil.getString(request, "redirectPath");
	String plName = ParamUtil.getString(request, "plName");
	
	String viewURL = StringPool.BLANK;
	
	System.out.println("+++dossierId:"+dossierId);
	System.out.println("+++isEditDossier:"+isEditDossier);
	System.out.println("+++govAgencyCode:"+govAgencyCode);
	System.out.println("+++redirectPath:"+redirectPath);
	System.out.println("+++plName:"+plName);
	System.out.println("+++duongSatGroupCode:"+duongSatGroupCode);
	System.out.println("+++duongThuyGroupCode:"+duongThuyGroupCode);
	System.out.println("+++dangKiemGroupCode:"+dangKiemGroupCode);
	System.out.println("+++hangKhongGroupCode:"+hangKhongGroupCode);
	
	long plId = 0;
	
	if(duongSatGroupCode.contains(govAgencyCode) && govAgencyCode.trim().length() > 0){
		
		plId = LayoutLocalServiceUtil.getFriendlyURLLayout(20182, true, "/duong-sat").getPlid();
	
	}else if(duongThuyGroupCode.contains(govAgencyCode) && govAgencyCode.trim().length() > 0){
		
		plId = LayoutLocalServiceUtil.getFriendlyURLLayout(20182, true, "/duong-thuy").getPlid();
	
	}else if(dangKiemGroupCode.contains(govAgencyCode) && govAgencyCode.trim().length() > 0){
	
		plId = LayoutLocalServiceUtil.getFriendlyURLLayout(20182, true, "/dang-kiem").getPlid();
	
	}else if(hangKhongGroupCode.contains(govAgencyCode) && govAgencyCode.trim().length() > 0){
	
		plId = LayoutLocalServiceUtil.getFriendlyURLLayout(20182, true, "/hang-khong").getPlid();
	
	}
%>

<liferay-portlet:renderURL plid="<%=plId %>" var="redirectUrl" portletName="<%=plName %>">
	<liferay-portlet:param name="mvcPath" value="<%=redirectPath %>"/>
	<liferay-portlet:param name="dossierId" value="<%=dossierId %>"/>
	<liferay-portlet:param name="isEditDossier" value="<%=isEditDossier %>"/>
</liferay-portlet:renderURL>

<%
	if(plId > 0){
		viewURL = redirectUrl;
	}

	System.out.println("plId:"+plId);
	System.out.println("viewURL:"+viewURL.length());
%>

<script type="text/javascript">
	var url = "<%=viewURL.toString()%>";
	
	console.log("url:"+url);
	
	if(url.length > 0){
		window.location.href= url;
		setTimeout('',10000);
	}
	
</script>

