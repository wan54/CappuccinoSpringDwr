MSDwrProxy.j
==========

This repository contains an example app that demonstrates the integration of [Cappuccino](http://www.cappuccino.org) app with [Springframework](http://www.springframework.org) and [DWR](http://directwebremoting.org). 
This app also demonstrates how Javascript and Objective-J can co-exist.

## Usage

Import this class:

        @import "MSDwrProxy.j"
          
Say you have an exposed DWR Service class: <code>DwrInterface</code> and method: <code>doSomething</code> 
          
You can call a DWR exposed method synchronously:      

        [[MSDwrProxy initialize] invokeWithMethod:DwrInterface.doSomething];
        
or with a single parameter:

        [[MSDwrProxy initialize] invokeWithMethod:DwrInterface.doSomething parameter:aValue];
        
or with multiple parameters:

        var params = [CPArray array];
        [params addObject:value1];
        [params addObject:value2];
        [params addObject:value3];
        
        [[MSDwrProxy initialize] invokeWithMethod:setSomeValue parameters:params];
        
If you're calling an exposed method asynchronously, you must define a method that acts like javascript callback that will do some action after the call is completed, e.g.:

        - (void)someAction:(id)data
        {
        }
        
Then you can call the method like so:

        var dwrProxy = [MSDwrProxy initialize];
        [dwrProxy setTarget:self];
        [dwrProxy setAction:@selector(someAction:)];
        [dwrProxy invokeWithMethod:DwrInterface.doSomething];
        
## Example
    
There are several files that you should look at to understand how the whole thing works:

- web.xml
  Entries added for DWR support.
  
- applicationContext.xml
  Entries added for DWR support.
  
- index.html
  Added DWR's Javascript dependencies.
  
- AppController.j
  An example app.
  
- MSDwrProxy.j
  A proxy between Cappuccino app and DWR.

## Note

The necessary files for eclipse and maven user are included.  

## TODO

- add example for integration with Hibernate
