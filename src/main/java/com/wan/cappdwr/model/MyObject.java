package com.wan.cappdwr.model;

import java.io.Serializable;
import java.util.Date;

import org.directwebremoting.annotations.DataTransferObject;
import org.directwebremoting.annotations.RemoteProperty;
import org.directwebremoting.convert.BeanConverter;

@DataTransferObject(converter=BeanConverter.class)
public class MyObject implements Serializable 
{
	
	private static final long serialVersionUID = 3193154758975148036L;

	@RemoteProperty
	private String aString;
	
	@RemoteProperty
	private String color;
	
	@RemoteProperty
	private Date now;
	
	public MyObject(){}

	public String getaString()
	{
		return aString;
	}

	public void setaString(String aString)
	{
		this.aString = aString;
	}

	public String getColor()
	{
		return color;
	}

	public void setColor(String color)
	{
		this.color = color;
	}

	public Date getNow()
	{
		return now;
	}

	public void setNow(Date now)
	{
		this.now = now;
	}
	
}
