/*
 *  This file was generated by the SOM Compiler and Emitter Framework.
 *  Generated using template emitter:
 *      SOM Emitter emitxtm: 2.23.1.9
 */

#ifndef SOM_Module_hello_Source
#define SOM_Module_hello_Source
#endif
#define Hello_Class_Source

#include "hello.xih"

#include <stdio.h>

/*
 * This method outputs the string "Hello, World!".
 */

SOM_Scope void  SOMLINK sayHello(Hello *somSelf,  Environment *ev)
{
    /* HelloData *somThis = HelloGetData(somSelf); */
    HelloMethodDebug("Hello","sayHello");

    printf( "Hello, World from SOM (C++ version)\n" );
}

