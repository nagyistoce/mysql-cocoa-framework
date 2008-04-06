//
//  CLI_Test application
//
//  Created by serge cohen (serge.cohen@m4x.org) on Sat Dec 08 2001.
//  Copyright (c) 2001 Serge Cohen.
//
//  This code is free software; you can redistribute it and/or modify it under
//  the terms of the GNU General Public License as published by the Free
//  Software Foundation; either version 2 of the License, or any later version.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT ANY
//  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
//  FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
//  details.
//
//  For a copy of the GNU General Public License, visit <http://www.gnu.org/> or
//  write to the Free Software Foundation, Inc., 59 Temple Place--Suite 330,
//  Boston, MA 02111-1307, USA.
//
//  More info at <http://mysql-cocoa.sourceforge.net/>
//
//

/* This is a simple application to test the framework : SMySQL.
*	this application needs a server to exist on the localhost,
*	user : ObjC password : MySQL_class
*
*	The program select the database : test_mysqlclass
*	Then display the content of table : test1.
*/

#import <Foundation/Foundation.h>
#import <SMySQL_static/SMySQL_static.h>

int main (int argc, const char * argv[]) {
	NSAutoreleasePool		*pool = [[NSAutoreleasePool alloc] init];
	MCPConnection			*connection/*, *connect2*/;
	MCPResult				*result;
	NSArray					*names, *types;
	NSDictionary			*row;
	unsigned int			count, i;
   char                 *aBigIntegerAsString = "18446744073709551612";
//   char                 *aBigIntegerAsString = "184467440737095516";

    // insert code here...
   NSLog(@"A big integer (64b required) : string : %s, as integer (using strtoull) : %llu, NSNumber :%@", aBigIntegerAsString, strtoull(aBigIntegerAsString, NULL, 0), [MCPNumber numberWithUnsignedLongLong:strtoull(aBigIntegerAsString, NULL, 0)]);
   printf("The value of the strtoull functions is : %llu\n\n", strtoull(aBigIntegerAsString, NULL, 0));
   printf("The value of the strtoll functions is : %lli\n\n", strtoll(aBigIntegerAsString, NULL, 0));
   NSLog(@"And now, the NSNumber again, but this time asking for the unsigned value : %llu", [[MCPNumber numberWithUnsignedLongLong:strtoull(aBigIntegerAsString, NULL, 0)] unsignedLongLongValue]);
	connection = [[MCPConnection alloc] initToHost:@"localhost" withLogin:@"ObjC" password:@"MySQL_class" usingPort:3306];
	[connection selectDB:@"test_mysqlclass"];

	result = [connection queryString:@"select * from test1"];
	count = [result numOfFields];
	names = [result fetchFieldsName];
	types = [result fetchTypesAsArray];
	for (i=0; i<count; i++) {
		NSLog(@" Column : %d of type : %@ has for name : %@\n", (i+1), [types objectAtIndex:i], [names objectAtIndex:i]);
	}
	while (row = [result fetchRowAsDictionary]) {
		for (i=0; i<count; i++) {
			NSString	*name = [names objectAtIndex:i];
			NSLog(@"%@ : %@\n", name, [row objectForKey:name]);
			if ([result isBlobAtIndex:i]) {
				NSString	*theString = [result stringWithCString:[[row objectForKey:name] bytes]];
				NSLog(@"	as string : %@\n",theString);
			}
		}
	}
	NSLog (@"Here is the NSLog of a MCPResult : \n%@", result);

	result = [connection queryString:@"select test1_id, test1_name from test1 where test1_id=1"];
// The explicit call to fetchFieldsName is not of any use, it is done automaticaly if needed by the MCPResult object.
//	[result fetchFieldsName];
	NSLog (@"Here is theNSLog of a MCPResult  %@", result);    

	result = [connection listFieldsFromTable:@"test1" like:nil];
	NSLog (@"Here is theNSLog of a MCPResult (listFields:nil forTable:test1) %@", result);

	result = [connection listFieldsFromTable:@"test1"];
	NSLog (@"Here is theNSLog of a MCPResult (listFields:nil forTable:test1) %@", result);

	result = [connection listDBs];
	NSLog (@"Here is the NSLog of a MCPResult (listDBs) : \n%@", result);

	result = [connection listDBsLike:@"test\\_%%"];
	NSLog (@"Here is the NSLog of a MCPResult (listDBs:test\\_%%) : \n%@", result);

	result = [connection listTables];
	NSLog (@"Here is the NSLog of a MCPResult (listTables) : \n%@", result);

	NSLog (@"Here comes the server information : %@\n", [connection serverInfo]);

	NSLog (@"Making an error by issuing the SQL query : select blablabla error. (Which is obviously invalid)");
	[connection queryString:@"select blablabla error"];
	NSLog (@"Here comes the last error information : %@\n", [connection getLastErrorMessage]);

	[connection release];

// Test of the init first, then connect (after having some option setted):
///*
//   connect2 = [[MCPConnection alloc] init];
 //  [connect2 setConnectionOption:CLIENT_SSL toValue:YES];
//   [connect2 connectWithLogin:@"ObjC" password:@"MySQL_class" host:@"localhost" port:0 socket:nil];
 //  [connect2 connectWithLogin:@"ObjC" password:@"MySQL_class" host:@"balsa.local" port:3306 socket:nil];
//   [connect2 selectDB:@"test_mysqlclass"];
//   result = [connect2 listTables];
//   NSLog (@"Using connect2 : Here is the NSLog of a MCPResult (listTables) : \n%@", result);
//   result = [connect2 queryString:@"select * from test1"];
//   NSLog (@"Using connect2 : content of table test1 : \n%@", result);
//   NSLog (@"Here comes the last error information : %@\n", [connect2 getLastErrorMessage]);
//*/
//   [connect2 release];
	[pool release];
	return 0;
}
