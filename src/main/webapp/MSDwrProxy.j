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
	id _delegate;
}

- (id)init
{
	self = [super init];
	return self;
}

- (void)invokeWithMethod:(id)aMethod performAction:(SEL)aSelector
{
	if (self) [self invokeWithMethod:aMethod parameters:nil performAction:aSelector delegate:[self delegate]];
}

- (void)invokeWithMethod:(id)aMethod performAction:(SEL)aSelector delegate:(id)aDelegate
{
	if (self) [self invokeWithMethod:aMethod parameters:nil performAction:aSelector delegate:aDelegate];
}

- (void)invokeWithMethod:(id)aMethod parameter:(id)aParam performAction:(SEL)aSelector
{
	if (self) [self invokeWithMethod:aMethod parameters:[CPArray arrayWithObject:aParam] performAction:aSelector delegate:[self delegate]];
}

- (void)invokeWithMethod:(id)aMethod parameter:(id)aParam performAction:(SEL)aSelector delegate:(id)aDelegate
{
	if (self) [self invokeWithMethod:aMethod parameters:[CPArray arrayWithObject:aParam] performAction:aSelector delegate:aDelegate];
}

- (void)invokeWithMethod:(id)aMethod parameters:(CPArray)params performAction:(SEL)aSelector
{
	if (self) [self invokeWithMethod:aMethod parameters:params performAction:aSelector delegate:[self delegate]];
}

- (void)invokeWithMethod:(id)aMethod parameters:(CPArray)params performAction:(SEL)aSelector delegate:(id)aDelegate
{
  if (aDelegate != nil && aSelector != nil) {
    var callback = function(data) {
      [aDelegate performSelector:aSelector withObject:data];

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

+ (void)invokeWithMethod:(id)aMethod
{
	[[[self alloc] init] invokeWithMethod:aMethod parameters:nil performAction:nil delegate:nil];
}

+ (void)invokeWithMethod:(id)aMethod parameter:(id)aParam
{
	[[[self alloc] init] invokeWithMethod:aMethod parameters:[CPArray arrayWithObject:aParam] performAction:nil delegate:nil];
}

+ (void)invokeWithMethod:(id)aMethod parameters:(CPArray)params
{
  [[[self alloc] init] invokeWithMethod:aMethod parameters:params performAction:nil delegate:nil];
}

- (void)setDelegate:(id)aDelegate
{
	_delegate = aDelegate;
}

- (id)delegate
{
	return _delegate;
}

@end
