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
	MSDwrProxy _instance;
}

+ (void)initialize
{
	if (self != MSDwrProxy) return;

	_target = nil;
	_selector = nil;

  var warningHandler = function(errorMessage) {
  
    var a = [[CPAlert alloc] init];
    [a setAlertStyle:CPCriticalAlertStyle];
    [a setMessageText:@"Error occurred when invoking server method."];
    if (errorMessage === "No data received from server") errorMessage = "There is no communication to server or server is down";
    [a setInformativeText:errorMessage];
    [a addButtonWithTitle:@"Close"];
    [a runModal];
    [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];

  };
  
  var errorHandler = function(errorMessage, exception) {
  
    var a = [[CPAlert alloc] init];
    [a setAlertStyle:CPCriticalAlertStyle];
    [a setMessageText:@"Error occurred when invoking server method."];
    [a setInformativeText:errorMessage + '\n' + exception];
    [a addButtonWithTitle:@"Close"];
    [a runModal];
    [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];

  };
  
  var exceptionHandler = function(errorMessage, exception) {
  
    var a = [[CPAlert alloc] init];
    [a setAlertStyle:CPCriticalAlertStyle];
    [a setMessageText:@"Exception occurred when invoking server method."];
    [a setInformativeText:errorMessage + '\n' + exception];
    [a addButtonWithTitle:@"Close"];
    [a runModal];
    [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
    
  };
    
  _dwrJSON.callback = nil;
  _dwrJSON.warningHandler = warningHandler;
  _dwrJSON.exceptionHandler = exceptionHandler;
  _dwrJSON.errorHandler = errorHandler;
  	
	_instance = [self alloc];
	[super init];
}

+ (id)instance
{
	return _instance;
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

  if (params == nil) {
    params = [CPArray array];
  }

  if (aTarget != nil && anInvocation != nil) {
  
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

@end
