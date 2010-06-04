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
	CPString _class;
	id _delegate;
}

+ (void)invokeWithClassName:(CPString)aClass methodName:(CPString)aMethod delegate:(id)aDelegate performAction:(SEL)aSelector
{
	[[[self alloc] initWithClassName:aClass delegate:aDelegate] invokeWithMethodName:aMethod performAction:aSelector];
}

+ (void)invokeWithClassName:(CPString)aClass methodName:(CPString)aMethod
{
	[[[self alloc] initWithClassName:aClass delegate:nil] invokeWithMethodName:aMethod];
}

+ (void)invokeWithClassName:(CPString)aClass methodName:(CPString)aMethod parameter:(id)anArg
{
	[[[self alloc] initWithClassName:aClass delegate:nil] invokeWithMethodName:aMethod parameter:anArg];
}

+ (void)invokeWithClassName:(CPString)aClass methodName:(CPString)aMethod parameter:(id)anArg performAction:(SEL)aSelector
{
	[[[self alloc] initWithClassName:aClass delegate:nil] invokeWithMethodName:aMethod parameter:anArg performAction:aSelector];
}

- (id)initWithClassName:(CPString)aClass delegate:(id)aDelegate
{
	_class = nil;
	_delegate = nil;

	self = [super init];

	if (self) {
		_class = aClass;
		_delegate = aDelegate;
	}

	return self;
}

- (void)invokeWithMethodName:(CPString)aMethod
{
	window[_class][aMethod]();
}

- (void)invokeWithMethodName:(CPString)aMethod parameter:(id)anArg
{
	window[_class][aMethod](anArg);
}

- (void)invokeWithMethodName:(CPString)aMethod performAction:(SEL)aSelector
{
	[self invokeWithMethodName:aMethod parameter:nil performAction:aSelector];
}

- (void)invokeWithMethodName:(CPString)aMethod parameter:(id)aParam performAction:(SEL)aSelector
{
//	if (![_delegate respondsToSelector:@selector(aSelector:)]) {
//		[CPException raise:@"MSDwrProxyException" reason:[_delegate className] + " must implement " + aSelector + "(id)data"];
//	}

	var fn = window[_class][aMethod];
	
	var callback = function(data) {
		[_delegate performSelector:aSelector withObject:data];

		[[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
	};

	if (aParam != nil) {
		fn(aParam, callback);
	} else {
		fn(callback);
	}
}

- (id)delegate
{
	return _delegate;
}

@end
