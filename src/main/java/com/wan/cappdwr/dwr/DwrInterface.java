package com.wan.cappdwr.dwr;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.directwebremoting.WebContext;
import org.directwebremoting.WebContextFactory;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;

import com.wan.cappdwr.model.MyObject;

@RemoteProxy(name="DwrInterface")
public class DwrInterface 
{
	private static final String SESSION_NAME = "CAPPDWR";
	private static final String CUSTOM_SESSION_ATTR_NAME = "custom attr name";
	private static final Map<Integer,String> colors = new HashMap<Integer,String>();
	
	static 
	{
		colors.put(0, "red");
		colors.put(1, "green");
		colors.put(2, "blue");
		colors.put(3, "yellow");
		colors.put(4, "purple");
	}
		
	public DwrInterface(){}
	
	@RemoteMethod
	public MyObject myObject() 
	{
		MyObject obj = new MyObject();
		
		obj.setaString("Hello World!");
		obj.setColor(colors.get(new Random().nextInt(5)));
		obj.setNow(Calendar.getInstance().getTime());
		
		return obj;
	}
	
	@RemoteMethod
	public String servletContext() 
	{
		WebContext wctx = WebContextFactory.get();
		
		if (wctx != null) {
			HttpServletRequest req = wctx.getHttpServletRequest();
			
			if (req != null) {
				return 
					"HttpServletRequest:\n" +
					"Server Name = " + req.getServerName() + "\n" +
					"Server Port = " + req.getServerPort() + "\n" +
					"Servlet Path = " + req.getServletPath() + "\n" +
					"Remote Host = " + req.getRemoteHost() + "\n" +
					"Remote Address = " + req.getRemoteAddr() + "\n" + 
					"Remote Port = " + req.getRemotePort() + "\n" +
					"Remote User = " + req.getRemoteUser() + "\n" +
					"Session = " + req.getSession() + "\n" +
					"Session Id = " + (req.getSession() != null ? req.getSession().getId() : null) + "\n" +
					"Session Attribute Value of CAPPDWR = " + (req.getSession() != null ? req.getSession().getAttribute(SESSION_NAME) : null) + "\n" +
					"Session Attribute Value of " + req.getSession().getAttribute(CUSTOM_SESSION_ATTR_NAME) + " = " + 
						(req.getSession() != null ? 
								(req.getSession().getAttribute(CUSTOM_SESSION_ATTR_NAME) != null ? 
										req.getSession().getAttribute(req.getSession().getAttribute(CUSTOM_SESSION_ATTR_NAME).toString()) : null) : null);
			}
		}
		
		return null;
	}
	
	@RemoteMethod
	public void setSessionAttributeValue(String sessionValue)
	{
		WebContext wctx = WebContextFactory.get();
		
		if (wctx != null) {
			HttpSession s = wctx.getSession();
			if (s != null) {
				s.setAttribute(SESSION_NAME, sessionValue);
			}
		}
	}
	
	@RemoteMethod
	public String setSessionAttributeNameAndValue(String attrName, String attrValue) {
		WebContext wctx = WebContextFactory.get();
		
		if (wctx != null) {
			HttpSession s = wctx.getSession();
			
			if (s != null) {
				s.setAttribute(CUSTOM_SESSION_ATTR_NAME, attrName);
				s.setAttribute(attrName, attrValue);
				return "Session value was set successfully!";
			}
		}
		return null;
	}
	
	@RemoteMethod
	public void invalidateSession()
	{
		WebContext wctx = WebContextFactory.get();
		
		if (wctx != null) {
			HttpSession s = wctx.getSession();
			
			if (s != null) {
				s.invalidate();
			}
		}
	}
}
