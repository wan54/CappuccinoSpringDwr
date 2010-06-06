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

+ (void)invokeWithMethod:(id)aMethod delegate:(id)aDelegate performAction:(SEL)aSelector
{
	[[[self alloc] initWithDelegate:aDelegate] invokeWithMethod:aMethod parameter:nil performAction:aSelector];
}

+ (void)invokeWithMethod:(id)aMethod parameter:(id)aParam delegate:(id)aDelegate performAction:(SEL)aSelector
{
	[[[self alloc] initWithDelegate:aDelegate] invokeWithMethod:aMethod parameter:aParam performAction:aSelector];
}

+ (void)invokeWithMethod:(id)aMethod
{
	[[[self alloc] initWithDelegate:nil] invokeWithMethod:aMethod];
}

+ (void)invokeWithMethod:(id)aMethod parameter:(id)aParam
{
	[[[self alloc] initWithDelegate:nil] invokeWithMethod:aMethod parameter:aParam];
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

- (void)invokeWithMethod:(id)aMethod
{
  aMethod();
}

- (void)invokeWithMethod:(id)aMethod parameter:(id)aParam
{
	aMethod(aParam);
}

- (void)invokeWithMethod:(id)aMethod performAction:(SEL)aSelector
{
	[self invokeWithMethod:aMethod parameter:nil performAction:aSelector];
}

- (void)invokeWithMethod:(id)aMethod parameter:(id)aParam performAction:(SEL)aSelector
{
	var callback = function(data) {
		[_delegate performSelector:aSelector withObject:data];

		[[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
	};

	if (aParam != nil) {
		aMethod(aParam, callback);
	} else {
		aMethod(callback);
	}
}

- (id)delegate
{
	return _delegate;
}

@end
