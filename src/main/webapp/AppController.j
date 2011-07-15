/*
 * AppController.j
 * Example for Cappuccino integration with Springframework and Directwebremoting
 * by utilizing MSDwrProxy.j
 * 
 * Created by Muliawan Sjarif on June 3, 2010.
 * Copyright 2010, Muliawan Sjarif.
 */

@import <Foundation/CPObject.j>
@import "MSDwrProxy.j"

var _textShadowColor = "#ccc";
var _textShadowOffset = CGSizeMake(0, 1);

@implementation AppController : CPObject
{
	CPTextField label1, label2, label3;
	CPTextField sessionAttrValue, sessionAttrName, sessionAttrValue2;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
      contentView = [theWindow contentView];

  [theWindow setBackgroundColor:[CPColor lightGrayColor]];

  var strButton = [[CPButton alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
  [strButton setTitle:@"Fetch Server Data"];
  [strButton sizeToFit];
  [strButton setTarget:self];
  [strButton setAction:@selector(fetchData:)];

  label1 = [[CPTextField alloc] initWithFrame:CGRectMake(10, CGRectGetHeight([strButton bounds])+20, 200, 100)];
  [label1 setTextShadowColor:_textShadowColor];
  [label1 setTextShadowOffset:_textShadowOffset];

  label2 = [[CPTextField alloc] initWithFrame:CGRectMake(10, CGRectGetHeight([strButton bounds])+40, 0, 0)];
  [label2 setTextShadowColor:_textShadowColor];
  [label2 setTextShadowOffset:_textShadowOffset];

  label3 = [[CPTextField alloc] initWithFrame:CGRectMake(10, CGRectGetHeight([strButton bounds])+60, 0, 0)];
  [label3 setTextShadowColor:_textShadowColor];
  [label3 setTextShadowOffset:_textShadowOffset];

  sessionAttrValue = [[CPTextField alloc] initWithFrame:CGRectMake(10, CGRectGetHeight([strButton bounds])+240, 200, 30)];
  [sessionAttrValue setEditable:YES];
  [sessionAttrValue setEnabled:YES];
  [sessionAttrValue setBezeled:YES];
  [sessionAttrValue setBezelStyle:CPTextFieldRoundedBezel];
  [sessionAttrValue setPlaceholderString:@"Enter a session attribute value"];
  
  var strButton2 = [[CPButton alloc] initWithFrame:CGRectMake(CGRectGetWidth([sessionAttrValue bounds])+10, CGRectGetHeight([strButton bounds])+242.5, 0, 0)];
  [strButton2 setTitle:@"Set Session Attribute Value"];
  [strButton2 sizeToFit];
  [strButton2 setTarget:self];
  [strButton2 setAction:@selector(setSessionAttributeValue:)];

  sessionAttrName = [[CPTextField alloc] initWithFrame:CGRectMake(10, CGRectGetHeight([strButton bounds])+290, 200, 30)];
  [sessionAttrName setEditable:YES];
  [sessionAttrName setEnabled:YES];
  [sessionAttrName setBezeled:YES];
  [sessionAttrName setBezelStyle:CPTextFieldRoundedBezel];
  [sessionAttrName setPlaceholderString:@"Enter a session attribute name"];
  
  sessionAttrValue2 = [[CPTextField alloc] initWithFrame:CGRectMake(CGRectGetWidth([sessionAttrName bounds])+10, CGRectGetHeight([strButton bounds])+290, 200, 30)];
  [sessionAttrValue2 setEditable:YES];
  [sessionAttrValue2 setEnabled:YES];
  [sessionAttrValue2 setBezeled:YES];
  [sessionAttrValue2 setBezelStyle:CPTextFieldRoundedBezel];
  [sessionAttrValue2 setPlaceholderString:@"Enter a session attribute value"];
  
  var strButton3 = [[CPButton alloc] initWithFrame:CGRectMake(CGRectGetWidth([sessionAttrName bounds])+CGRectGetWidth([sessionAttrValue2 bounds])+10, CGRectGetHeight([strButton bounds])+292.5, 0, 0)];
  [strButton3 setTitle:@"Set Session Attribute Name And Value"];
  [strButton3 sizeToFit];
  [strButton3 setTarget:self];
  [strButton3 setAction:@selector(setSessionAttributeNameAndValue:)];

  var strButton4 = [[CPButton alloc] initWithFrame:CGRectMake(10, CGRectGetHeight([sessionAttrValue bounds])+345, 0, 0)];
  [strButton4 setTitle:@"Invalidate Session"];
  [strButton4 sizeToFit];
  [strButton4 setTarget:self];
  [strButton4 setAction:@selector(invalidateSession:)];

  [contentView addSubview:strButton];
  [contentView addSubview:label1];
  [contentView addSubview:label2];
  [contentView addSubview:label3];
  [contentView addSubview:sessionAttrValue];
  [contentView addSubview:strButton2];
  [contentView addSubview:sessionAttrName];
  [contentView addSubview:sessionAttrValue2];
  [contentView addSubview:strButton3];
  [contentView addSubview:strButton4];

	[theWindow orderFront:self];

    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

- (void)fetchData:(id)sender
{
  // call DWR method asynchronously and perform some action after a response is received
	var p = [MSDwrProxy instance];

	[p setTarget:self];

  [p setAction:@selector(myObjectResponse:)];
	[p invokeWithMethod:DwrInterface.myObject];

	[p setAction:@selector(servletContextResponse:)];
	[p invokeWithMethod:DwrInterface.servletContext];
}

- (void)myObjectResponse:(id)data
{
	if (data) {
		[label1 setStringValue:data.aString];
		[label1 setTextColor:data.color];
		[label1 sizeToFit];	

		[label2 setStringValue:"Now is " + data.now];
		[label2 setTextColor:data.color];
		[label2 sizeToFit];
	}	
}

- (void)servletContextResponse:(id)data
{
	if (data) {	
		[label3 setStringValue:data];
		[label3 sizeToFit];
	}
}

- (void)invalidateSession:(id)sender
{
  // call DWR method synchronously
	[[MSDwrProxy instance] invokeWithMethod:DwrInterface.invalidateSession];
}

- (void)setSessionAttributeValue:(id)sender
{
  // call DWR method synchronously with parameter
	[[MSDwrProxy instance] invokeWithMethod:DwrInterface.setSessionAttributeValue parameter:[sessionAttrValue stringValue]];
}

- (void)setSessionAttributeNameAndValue:(id)sender
{
  // call DWR method asynchronously with multiple parameters and perform some action after a response is received
  var params = [CPArray array];
  [params addObject:[sessionAttrName stringValue]];
  [params addObject:[sessionAttrValue2 stringValue]];
  
  [[MSDwrProxy instance] invokeWithMethod:DwrInterface.setSessionAttributeNameAndValue parameters:params target:self action:@selector(responseReceived:)];
}

- (void)responseReceived:(id)data
{
	alert(data);
}

@end
