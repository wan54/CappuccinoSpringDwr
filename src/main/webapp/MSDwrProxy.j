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

@implementation MSDwrProxy : CPObject
{
	id _target;
	SEL _selector;
}

- (id)init
{
	self = [super init];
	_target = nil;
	_selector = nil;
	return self;
}

- (void)invokeWithMethod:(id)aMethod
{
	if (self) [self invokeWithMethod:aMethod parameters:nil target:[self target] action:[self action]];
}

- (void)invokeWithMethod:(id)aMethod parameter:(id)aParam
{
	if (self) [self invokeWithMethod:aMethod parameters:[CPArray arrayWithObject:aParam] target:[self target] action:[self action]];
}

- (void)invokeWithMethod:(id)aMethod parameters:(CPArray)params
{
	if (self) [self invokeWithMethod:aMethod parameters:params target:[self target] action:[self action]];
}

- (void)invokeWithMethod:(id)aMethod parameters:(CPArray)params target:(id)aTarget action:(SEL)aSelector
{
  if (aTarget != nil && aSelector != nil) {
    var callback = function(data) {
      [aTarget performSelector:aSelector withObject:data];

      [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
    };

    if (params && [params count] > 0) {
      [params addObject:callback];
      aMethod.apply(this, params);
    } else {
      aMethod(callback);
    }
  } else {
    if (params && [params count] > 0) {
      aMethod.apply(this, params);
    } else {
      aMethod();
    }
  }
}

+ (id)initialize
{
	return [[self alloc] init];
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
