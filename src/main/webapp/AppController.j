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
	CPTextField sessionValue;
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

		sessionValue = [[CPTextField alloc] initWithFrame:CGRectMake(10, CGRectGetHeight([strButton bounds])+240, 100, 30)];
		[sessionValue setEditable:YES];
		[sessionValue setEnabled:YES];
		[sessionValue setBezeled:YES];
		[sessionValue setBezelStyle:CPTextFieldRoundedBezel];
		
		var strButton2 = [[CPButton alloc] initWithFrame:CGRectMake(CGRectGetWidth([sessionValue bounds])+10, CGRectGetHeight([sessionValue bounds])+240, 0, 0)];
		[strButton2 setTitle:@"Set Session Attribute"];
		[strButton2 sizeToFit];
		[strButton2 setTarget:self];
		[strButton2 setAction:@selector(setServerSession:)];

		var strButton3 = [[CPButton alloc] initWithFrame:CGRectMake(10, CGRectGetHeight([sessionValue bounds])+295, 0, 0)];
		[strButton3 setTitle:@"Invalidate Session"];
		[strButton3 sizeToFit];
		[strButton3 setTarget:self];
		[strButton3 setAction:@selector(invalidateSession:)];

		[contentView addSubview:strButton];
		[contentView addSubview:label1];
		[contentView addSubview:label2];
		[contentView addSubview:label3];

		[contentView addSubview:sessionValue];
 		[contentView addSubview:strButton2];
		[contentView addSubview:strButton3];

	[theWindow orderFront:self];

    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

- (void)fetchData:(id)sender
{
	var p = [[MSDwrProxy alloc] initWithDelegate:self];

	[p invokeWithMethod:DwrInterface.myObject performAction:@selector(myObjectResponse:)];
	[p invokeWithMethod:DwrInterface.servletContext performAction:@selector(servletContextResponse:)];
}

- (void)myObjectResponse:(id)data
{
	if (data) {
		[label1 setStringValue:data.aString];
		[label1 setTextColor:data.color];
		[label1 sizeToFit];	

		[label2 setStringValue:"Now isisis " + data.now];
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
	[MSDwrProxy invokeWithMethod:DwrInterface.invalidateSession];
}

- (void)setServerSession:(id)sender
{
	[MSDwrProxy invokeWithMethod:DwrInterface.setServerSession parameter:[sessionValue stringValue]];
}

@end
