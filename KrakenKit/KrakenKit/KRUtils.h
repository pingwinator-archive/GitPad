//
//  KRUtils.h
//  KrakenKit
//
//  Created by Robert Widmann on 1/21/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

//******************************************************************************
//Taken from EtPanKit, huge thanks to DINH Viet Hoà
//******************************************************************************

#define KRLogOutputFilename @"KRLogOutputFilename"
#define KRLogEnabledFilenames @"KRLogEnabledFilenames"
// In your user defaults, you can set an array of filenames which KRLog messages
// you want to disable.  Do not include path extension (e.g. "KRRequest" to
// disable KRRequest's KRLog messages)

#if defined(KRLOG_DISABLE) || defined (KRLOG_DISABLED)

#define KRLogStack(...)
#define KRLog(...)
#define KRAssert(condition) NSAssert(condition, @#condition)
#define KRCrash() NSAssert(0, @"KRCrash")

#define KRPROPERTY(propName)    @#propName

#define		KRDebugDefaultsBoolForKey( key, placeholder )		( placeholder )
#define		KRDebugDefaultsIntegerForKey( key, placeholder )	( placeholder )
#define		KRDebugDefaultsFloatForKey( key, placeholder )		( placeholder )
#define		KRDebugDefaultsDoubleForKey( key, placeholder )		( placeholder )
#define		KRDebugDefaultsObjectForKey( key, placeholder )		( placeholder )

#else

#define KRLogStack(...) KRLogInternal(__FILE__, __LINE__, 1, __VA_ARGS__)
#define KRLog(...) KRLogInternal(__FILE__, __LINE__, 0, __VA_ARGS__)
#define KRAssert(condition) NSAssert(condition, @#condition)
#define KRCrash() NSAssert(0, @"KRCrash")

//
// Use KRPROPERTY for safer KVC.
// Instead of writing valueForKey(@"keyName"),
// use valueForKey(KRPROPERTY(keyName)).
// To be used with -Wundeclared-selector.
#define KRPROPERTY(propName)    NSStringFromSelector(@selector(propName))

#endif

__BEGIN_DECLS
void KRLogInternal(const char * filename, unsigned int line, int dumpStack, NSString * format, ...);
__END_DECLS
