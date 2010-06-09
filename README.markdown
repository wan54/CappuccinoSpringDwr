MSDwrProxy.j
==========

This repository contains an example app that demonstrates the integration of [Cappuccino](http://www.cappuccino.org) app with [Springframework](http://www.springframework.org) and [DWR](http://directwebremoting.org). 
This app also demonstrates how Javascript and Objective-J can co-exist.

## Usage

Import this class:

        @import "MSDwrProxy.j"
          
Say you have an exposed DWR Service class: <code>DwrInterface</code> and method: <code>doSomething</code> 
          
Call a DWR exposed method this way:      

        [MSDwrProxy invokeWithMethod:DwrInterface.doSomething];
        
or:

        [MSDwrProxy invokeWithMethod:DwrInterface.doSomething parameter:aValue];
        
or:

        var params = [CPArray array];
        [params addObject:value1];
        [params addObject:value2];
        [params addObject:value3];
        
        [MSDwrProxy invokeWithMethod:setSomeValue parameters:params];
        
If you expect a returned value from the server you have to implement a method that handles the returned value. The method will only expect one parameter which is the returned value, e.g.:

        - (void)responseReceived:(id)data
        {
        }
        
Then you can call the method like so:

        var dwrProxy = [MSDwrProxy initialize];
        [dwrProxy invokeWithMethod:DwrInterface.doSomething target:self action:@selector(responseReceived:)];
        
or:

        var dwrProxy = [MSDwrProxy initialize];
        [dwrProxy invokeWithMethod:DwrInterface.setSomeValue parameter:aValue target:self action:@selector(responseReceived:)];                        

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
