MSDwrProxy.j
==========

A [DWR](http://directwebremoting.org) proxy for J2EE-[Cappuccino](http://www.cappuccino.org) app 

## Usage

Import this class:

        @import "MSDwrProxy.j"
          
Say you have an exposed DWR Service class: <code>DwrInterface</code> and method: <code>doSomething</code> 
          
You can call a remote exposed method synchronously:      

        [[MSDwrProxy instance] invokeWithMethod:DwrInterface.doSomething];
        
or with a single parameter:

        [[MSDwrProxy instance] invokeWithMethod:DwrInterface.doSomething parameter:aValue];
        
or with multiple parameters:

        var params = [CPArray array];
        [params addObject:value1];
        [params addObject:value2];
        [params addObject:value3];
        
        [[MSDwrProxy initialize] invokeWithMethod:setSomeValue parameters:params];
        
If you're calling an exposed remote method asynchronously, you must define a local method that acts like javascript callback that will do some action after the remote call is completed, e.g.:

        - (void)someAction:(id)data
        {
        }
        
Then invocation of the local method is like so:

        var dwrProxy = [MSDwrProxy instance];
        [dwrProxy setTarget:self];
        [dwrProxy setAction:@selector(someAction:)];
        [dwrProxy invokeWithMethod:DwrInterface.doSomething];
        
DirectWebRemoting has one nice feature that is able to recognize your Cappuccino Object and accurately map it to your predefined Java Bean Class. As you may have guessed, yes, you're right, it is done by JSON. To utilize the feature, all you have to do is to create a handy Cappuccino class method that converts Cappuccino object into JSON e.g.:

        + (id)JSONFromObject:(Person)p
        {
          var json = {};
          json.personID = [p personID];
          json.firstName = [p firstName];
          json.lastName = [p lastName];
          json.email = [p email];
        
          return json;
        }

## Example
    
This repository contains an example app that demonstrates the integration of [Cappuccino](http://www.cappuccino.org) app with J2EE technologies, namely [Springframework](http://www.springframework.org) and [DWR](http://directwebremoting.org). 
This app also demonstrates how Javascript and Objective-J can co-exist.

There are several files that you should look at to understand how the whole thing works:

    - web.xml
      - Entries added for DWR support.
  
    - applicationContext.xml
      - Entries added for DWR support.
  
    - index.html
      - Added DWR's Javascript dependencies.
  
    - AppController.j
      - An example app.
  
    - MSDwrProxy.j
      - A proxy between Cappuccino app and DWR.

## Note

The necessary files for eclipse and maven user are included.  

## TODO

- add example for integration with Hibernate
