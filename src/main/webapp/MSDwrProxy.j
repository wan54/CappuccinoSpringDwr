/*
 * MSDwrProxy.j
 *
 * Created by Muliawan Sjarif on June 4, 2010.
 * Copyright 2010, Muliawan Sjarif.
 *
 * MSDwrProxy.j is provided under LGPL License from Free software foundation 
 * (a copy is included in this distribution).
 * This library is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 * See the GNU Lesser General Public License for more details.
 */

@import <Foundation/CPObject.j>

var _dwrJSON = {};

@implementation MSDwrProxy : CPObject
{
	id _target;
	SEL _selector;
}

- (id)init
{
  if (self = [super init])
	{
	  _target = nil;
	  _selector = nil;
	  _dwrJSON.callback = nil;
		
	  _dwrJSON.warningHandler = 
			function(errorMessage) {
	    
	      var wa = [[CPAlert alloc] init];
	      [wa setDelegate:self];
	      [wa setAlertStyle:CPCriticalAlertStyle];
	      [wa setMessageText:@"Warning occurred when invoking server method."];
	      if (errorMessage === "No data received from server") {
	        errorMessage = "There is no communication to server or server is down";
	        [wa setMessageText:@"Error occurred when invoking server method."];
	      }
	      [wa setInformativeText:errorMessage];
	      [wa addButtonWithTitle:@"Close"];
	      [wa runModal];
	      [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
	  
	    };
			
	  _dwrJSON.exceptionHandler = 
			function(errorMessage, exception) {
	    
	      var exa = [[CPAlert alloc] init];
	      [exa setDelegate:self];
	      [exa setAlertStyle:CPCriticalAlertStyle];
	      [exa setMessageText:@"Exception occurred when invoking server method."];
	      [exa setInformativeText:errorMessage + '\n' + exception];
	      [exa addButtonWithTitle:@"Close"];
	      [exa runModal];
	      [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
	      
	    };
		
	  _dwrJSON.errorHandler = 
			function(errorMessage, exception) {
	    
	      var ea = [[CPAlert alloc] init];
	      [ea setDelegate:self];
	      [ea setAlertStyle:CPCriticalAlertStyle];
	      [ea setMessageText:@"Error occurred when invoking server method."];
	      [ea setInformativeText:errorMessage + '\n' + exception];
	      [ea addButtonWithTitle:@"Close"];
	      [ea runModal];
	      [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
	  
	    };   
	}	
	return self;
}

+ (id)instance
{
	return [[MSDwrProxy alloc] init];
}

- (void)invokeWithMethod:(id)aMethod
{
	if (self) [self invokeWithMethod:aMethod parameters:nil target:[self target] action:[self action]];
}

- (void)invokeWithMethod:(id)aMethod parameter:(id)aParam
{
	if (self) [self invokeWithMethod:aMethod parameters:[CPArray arrayWithObject:aParam] target:[self target] action:[self action]];
}

- (void)invokeWithMethod:(id)aMethod parameter:(id)aParam target:(id)aTarget action:(SEL)aSelector
{
	if (self) [self invokeWithMethod:aMethod parameters:[CPArray arrayWithObject:aParam] target:aTarget action:aSelector];
}

- (void)invokeWithMethod:(id)aMethod parameters:(CPArray)params
{
	if (self) [self invokeWithMethod:aMethod parameters:params target:[self target] action:[self action]];
}

- (void)invokeWithMethod:(id)aMethod target:(id)aTarget action:(SEL)aSelector
{
	if (self) [self invokeWithMethod:aMethod parameters:nil target:aTarget action:aSelector];
}

- (void)invokeWithMethod:(id)aMethod parameters:(CPArray)params target:(id)aTarget action:(SEL)aSelector
{
  if (self) {
    var signature = [self methodSignatureForSelector:aSelector];
    var myInvocation = [CPInvocation invocationWithMethodSignature:signature];

    [myInvocation setSelector:aSelector];
    
    [self invokeWithMethod:aMethod parameters:params target:aTarget invocation:myInvocation];
  }
}

- (void)invokeWithMethod:(id)aMethod parameter:(id)aParam target:(id)aTarget invocation:(CPInvocation)anInvocation
{
	if (self) [self invokeWithMethod:aMethod parameters:[CPArray arrayWithObject:aParam] target:aTarget invocation:anInvocation];
}

- (void)invokeWithMethod:(id)aMethod parameters:(CPArray)params target:(id)aTarget invocation:(CPInvocation)anInvocation
{
  if (!params) {
    params = [CPArray array];
  }
  
  if (aTarget && anInvocation) {
		_target = aTarget;
  
    var callback = function(data) {
    
      [anInvocation setArgument:data atIndex:2];
      [anInvocation invokeWithTarget:aTarget];

      [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
      
    };

    _dwrJSON.callback = callback;
	}

  [params addObject:_dwrJSON];
  
  aMethod.apply(this, params);

}

- (void)setTarget:(id)aTarget
{
	_target = aTarget;
}

- (void)setAction:(SEL)aSelector
{
	_selector = aSelector;
}

- (id)target
{
	return _target;
}

- (SEL)action
{
	return _selector;
}

/* 
 * Feedback to the user screen when the call to the server method return an error/exception.
 * The user must implement 'dwrCallDidReturnError' to receive the server feedback
 */
- (void)alertDidEnd:(CPAlert)anAlert returnCode:(int)code
{
	var messageText = [anAlert messageText];
	if ([messageText hasPrefix:@"Error"] == YES || [messageText hasPrefix:@"Exception"] == YES)
		if (_target && [_target respondsToSelector:@selector(dwrCallDidReturnError)])
			[_target dwrCallDidReturnError];
}

@end
