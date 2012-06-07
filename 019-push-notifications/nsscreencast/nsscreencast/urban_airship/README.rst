iOS Urban Airship Library
=========================

Overview
--------

Urban Airship's libUArship is a drop-in static library that provides a simple way to
integrate Urban Airship services into your iOS applications. This entire project will
allow you to build the library files and all sample projects. If you just want to
include the library in your app, you can simply download the latest ``libUAirship.zip``
and a sample project. These zips contain a pre-compiled universal arm6/arm7/i386 library.

Working with the Library
------------------------

Copy libUAirship Files
######################

Download and unzip the latest version of libUAirship.  If you are using one of our sample
projects, copy the ``Airship`` directory into the same directory as your project::

    cp -r Airship /SomeDirectory/ (where /SomeDirectory/YourProject/ is your project)

If you are not using a sample project, you'll need to import the source files for the User 
Interface into your project. These are located under /Airship/UI/Default

Required Libraries
##################

The core library requires your application to link against the following Frameworks (sample UIs
have additional linking requirements)::

    libUAirship-1.1.2.a
    CFNetwork.framework
    CoreGraphics.framework
    Foundation.framework
    MobileCoreServices.framework
    Security.framework
    SystemConfiguration.framework
    UIKit.framework
    libz.dylib
    libsqlite3.dylib
    CoreTelephony.framework (Exists in iOS 4+ only, so make it a weak link for 3.x compatibility)
    StoreKit.framework

Build Settings
##############

**Compiler**
    
LLVM 2.1 is the default compiler for all projects and the static library.
     
**Header search path**
                                         
Ensure that your build target's header search path includes the Airship directory.
             
Quickstart
----------

Prerequisite
############

Before getting started you must perform the steps above outlined above.

In addition you'll need to include *UAirship.h* in your source files.

The AirshipConfig File
######################

The library uses a .plist configuration file named `AirshipConfig.plist` to manage your production and development
application profiles. Example copies of this file are available in all of the sample projects. Place this file
in your project and set the following values to the ones in your application at http://go.urbanairship.com

You can also edit the file as plain-text::

        {
         /* NOTE: DO NOT USE THE MASTER SECRET */
		"APP_STORE_OR_AD_HOC_BUILD" = NO; /* set to YES for production builds */
		"DEVELOPMENT_APP_KEY" = "Your development app key";
		"DEVELOPMENT_APP_SECRET" = "Your development app secret";
		"PRODUCTION_APP_KEY" = "Your production app key";
		"PRODUCTION_APP_SECRET" = "Your production app secret";
        }

If you are using development builds and testing using the Apple sandbox set `APP_STORE_OR_AD_HOC_BUILD` to false. For
App Store and Ad-Hoc builds, set it to YES.

Advanced users may add scripting or preprocessing logic to this .plist file to automate the switch from
development to production keys based on the build type.

Third party Package - License - Copyright / Creator 
###################################################

asi-http-request	BSD		Copyright (c) 2007-2010, All-Seeing Interactive.

fmdb	MIT		Copyright (c) 2008 Flying Meat Inc. gus@flyingmeat.com

SBJSON	MIT		Copyright (C) 2007-2010 Stig Brautaset.

Base64	BSD		Copyright 2009-2010 Matt Gallagher.

ZipFile-OC	BSD		Copyright (C) 1998-2005 Gilles Vollant.

GHUnit	Apache 2	Copyright 2007 Google Inc.

Google Toolkit	Apache 2	Copyright 2007 Google Inc.

Reachability	BSD		Copyright (C) 2010 Apple Inc.

MTPopupWindow	MIT		Copyright 2011 Marin Todorov

JRSwizzle MIT Copyright 2012 Jonathan Rentzsch
