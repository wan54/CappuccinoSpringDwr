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

- (id)initWithDelegate:(id)aDelegate
{
	_delegate = nil;

	self = [super init];

	if (self) {
		_delegate = aDelegate;
	}

	return self;
}

- (void)invokeWithMethod:(id)aMethod performAction:(SEL)aSelector
{
	[self invokeWithMethod:aMethod parameters:nil performAction:aSelector];
}

- (void)invokeWithMethod:(id)aMethod parameters:(CPArray)params performAction:(SEL)aSelector
{
  if (aSelector != nil) {
    var callback = function(data) {
      [_delegate performSelector:aSelector withObject:data];

      [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
    };
    
    [params addObject:callback];

    if (params && [params count] > 0) {
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

- (id)delegate
{
	return _delegate;
}

+ (void)invokeWithMethod:(id)aMethod delegate:(id)aDelegate performAction:(SEL)aSelector
{
	[[[self alloc] initWithDelegate:aDelegate] invokeWithMethod:aMethod parameters:nil performAction:aSelector];
}

+ (void)invokeWithMethod:(id)aMethod delegate:(id)aDelegate performAction:(SEL)aSelector parameter:(id)aParam
{
	[[[self alloc] initWithDelegate:aDelegate] invokeWithMethod:aMethod parameters:[CPArray arrayWithObject:aParam] performAction:aSelector];
}

+ (void)invokeWithMethod:(id)aMethod delegate:(id)aDelegate performAction:(SEL)aSelector parameters:(CPArray)params
{
	[[[self alloc] initWithDelegate:aDelegate] invokeWithMethod:aMethod parameters:params performAction:aSelector];
}

+ (void)invokeWithMethod:(id)aMethod
{
	[[[self alloc] initWithDelegate:nil] invokeWithMethod:aMethod parameters:nil performAction:nil];
}

+ (void)invokeWithMethod:(id)aMethod parameter:(id)aParam
{
	[[[self alloc] initWithDelegate:nil] invokeWithMethod:aMethod parameters:[CPArray arrayWithObject:aParam] performAction:nil];
}

+ (void)invokeWithMethod:(id)aMethod parameters:(CPArray)params
{
  [[[self alloc] initWithDelegate:nil] invokeWithMethod:aMethod parameters:params performAction:nil];
}

@end
