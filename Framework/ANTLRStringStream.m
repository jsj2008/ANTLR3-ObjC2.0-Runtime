// [The "BSD licence"]
// Copyright (c) 2006-2007 Kay Roepke 2010 Alan Condit
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. The name of the author may not be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import "ANTLRStringStream.h"

extern NSInteger debug;

@implementation ANTLRStringStream

@synthesize data;
@synthesize n;
@synthesize index;
@synthesize line;
@synthesize charPositionInLine;
@synthesize markDepth;
@synthesize markers;
@synthesize lastMarker;
@synthesize name;
@synthesize charState;

+ newANTLRStringStream
{
    return [[ANTLRStringStream alloc] init];
}

+ newANTLRStringStream:(NSString *)aString;
{
    return [[ANTLRStringStream alloc] initWithString:aString];
}


+ newANTLRStringStream:(char *)myData Count:(NSInteger)numBytes;
{
    return [[ANTLRStringStream alloc] initWithData:myData Count:numBytes];
}


- (id) init
{
	if ((self = [super init]) != nil) {
        n = 0;
        index = 0;
        line = 1;
        charPositionInLine = 0;
        markDepth = 0;
		markers = [PtrBuffer newPtrBufferWithLen:10];
        [markers addObject:[NSNull null]]; // ANTLR generates code that assumes markers to be 1-based,
        charState = [CharStreamState newCharStreamState];
	}
	return self;
}

- (id) initWithString:(NSString *) theString
{
	if ((self = [super init]) != nil) {
		//[self setData:[NSString stringWithString:theString]];
        data = theString;
        n = [data length];
        index = 0;
        line = 1;
        charPositionInLine = 0;
        markDepth = 0;
		markers = [PtrBuffer newPtrBufferWithLen:10];
        [markers addObject:[NSNull null]]; // ANTLR generates code that assumes markers to be 1-based,
        charState = [CharStreamState newCharStreamState];
	}
	return self;
}

- (id) initWithStringNoCopy:(NSString *) theString
{
	if ((self = [super init]) != nil) {
		//[self setData:theString];
        data = theString;
        n = [data length];
        index = 0;
        line = 1;
        charPositionInLine = 0;
        markDepth = 0;
		markers = [PtrBuffer newPtrBufferWithLen:100];
        [markers addObject:[NSNull null]]; // ANTLR generates code that assumes markers to be 1-based,
        charState = [CharStreamState newCharStreamState];
	}
	return self;
}

- (id) initWithData:(char *)myData Count:(NSInteger)numBytes
{
    if ((self = [super init]) != nil) {
        data = [NSString stringWithCString:myData encoding:NSASCIIStringEncoding];
        n = numBytes;
        index = 0;
        line = 1;
        charPositionInLine = 0;
        markDepth = 0;
		markers = [PtrBuffer newPtrBufferWithLen:100];
        [markers addObject:[NSNull null]]; // ANTLR generates code that assumes markers to be 1-based,
        charState = [CharStreamState newCharStreamState];
    }
    return( self );
}

- (void) dealloc
{
#ifdef DEBUG_DEALLOC
    NSLog( @"called dealloc in ANTLRStringStream" );
#endif
    if ( markers && [markers count] ) {
        [markers removeAllObjects];
        markers = nil;
    }
    if ( data ) {
        data = nil;
    }
}

- (id) copyWithZone:(NSZone *)aZone
{
    ANTLRStringStream *copy;
	
    copy = [[[self class] allocWithZone:aZone] init];
    //    copy = [super copyWithZone:aZone]; // allocation occurs here
    if ( data != nil )
        copy.data = [self.data copyWithZone:aZone];
    copy.n = n;
    copy.index = index;
    copy.line = line;
    copy.charPositionInLine = charPositionInLine;
    copy.markDepth = markDepth;
    if ( markers != nil )
        copy.markers = [markers copyWithZone:nil];
    copy.lastMarker = lastMarker;
    if ( name != nil )
        copy.name = [self.name copyWithZone:aZone];
    return copy;
}

// reset the streams charState
// the streams content is not reset!
- (void) reset
{
	index = 0;
	line = 1;
	charPositionInLine = 0;
	markDepth = 0;
    if ( markers && [markers count] )
        [markers removeAllObjects];
    [markers addObject:[NSNull null]];  // ANTLR generates code that assumes markers to be 1-based,
                                        // thus the initial null in the array!
}

// read one character off the stream, tracking line numbers and character positions
// automatically.
// Override this in subclasses if you want to avoid the overhead of automatic line/pos
// handling. Do not call super in that case.
- (void) consume 
{
	if ( index < n ) {
		charPositionInLine++;
		if ( [data characterAtIndex:index] == '\n' ) {
			line++;
			charPositionInLine=0;
		}
		index++;
	}
}

// implement the lookahead method used in lexers
- (NSInteger) LA:(NSInteger) i 
{
    NSInteger c;
    if ( i == 0 )
        return 0; // undefined
    if ( i < 0 ) {
        i++;
        if ( index+i-1 < 0 ) {
		    return CharStreamEOF;
		}
	}
    if ( (index+i-1) >= n ) {
		return CharStreamEOF;
	}
    c = [data characterAtIndex:index+i-1];
	return (NSInteger)c;
}

- (NSInteger) LT:(NSInteger)i
{
    return [self LA:i];
}

- (NSInteger) size 
{
	return n;
}

// push the current charState of the stream onto a stack
// returns the depth of the stack, to be used as a marker to rewind the stream.
// Note: markers are 1-based!
- (NSInteger) mark 
{
    if (debug > 1) NSLog(@"mark entry -- markers=%x, markDepth=%ld\n", (int)markers, markDepth);
    if ( markers == nil ) {
        markers = [PtrBuffer newPtrBufferWithLen:100];
		[markers addObject:[NSNull null]]; // ANTLR generates code that assumes markers to be 1-based,
        markDepth = markers.ptr;
    }
    markDepth++;
	CharStreamState *State = nil;
	if ( (markDepth) >= [markers count] ) {
        if ( markDepth > 1 ) {
            State = [CharStreamState newCharStreamState];
        }
        if ( markDepth == 1 )
            State = charState;
		[markers insertObject:State atIndex:markDepth];
        if (debug > 1) NSLog(@"mark save State %lx at %ld, index=%ld, line=%ld, charPositionInLine=%ld\n", (NSUInteger)State, markDepth, State.index, State.line, State.charPositionInLine);
	}
	else {
        if (debug > 1) NSLog(@"mark retrieve markers=%lx markDepth=%ld\n", (NSUInteger)markers, markDepth);
        State = [markers objectAtIndex:markDepth];
        State = (CharStreamState *)[markers objectAtIndex:markDepth];
        if (debug > 1) NSLog(@"mark retrieve charState %lx from %ld, index=%ld, line=%ld, charPositionInLine=%ld\n", (NSUInteger)State, markDepth, State.index, State.line, State.charPositionInLine);
	}
    State.index = index;
	State.line = line;
	State.charPositionInLine = charPositionInLine;
	lastMarker = markDepth;
    if (debug > 1) NSLog(@"mark exit -- markers=%lx, charState=%lx, index=%ld, line=%ld, charPositionInLine=%ld\n", (NSUInteger)markers, (NSUInteger)State, State.index, State.line, State.charPositionInLine);
	return markDepth;
}

- (void) rewind:(NSInteger) marker 
{
    CharStreamState *State;
    if (debug > 1) NSLog(@"rewind entry -- markers=%lx marker=%ld\n", (NSUInteger)markers, marker);
    if ( marker == 1 )
        State = charState;
    else
        State = (CharStreamState *)[markers objectAtIndex:marker];
    if (debug > 1) NSLog(@"rewind entry -- marker=%ld charState=%lx, index=%ld, line=%ld, charPositionInLine=%ld\n", marker, (NSUInteger)charState, charState.index, charState.line, charState.charPositionInLine);
	// restore stream charState
	[self seek:State.index];
	line = State.line;
	charPositionInLine = charState.charPositionInLine;
	[self release:marker];
    if (debug > 1) NSLog(@"rewind exit -- marker=%ld charState=%lx, index=%ld, line=%ld, charPositionInLine=%ld\n", marker, (NSUInteger)charState, charState.index, charState.line, charState.charPositionInLine);
}

- (void) rewind
{
	[self rewind:lastMarker];
}

// remove stream states on top of 'marker' from the marker stack
// returns the new markDepth of the stack.
// Note: unfortunate naming for Objective-C, but to keep close to the Java target this is named release:
- (void) release:(NSInteger) marker 
{
	// unwind any other markers made after marker and release marker
	markDepth = marker;
	markDepth--;
    if (debug > 1) NSLog(@"release:marker= %ld, markDepth = %ld\n", marker, markDepth);
}

// when seeking forward we must handle character position and line numbers.
// seeking backward already has the correct line information on the markers stack, 
// so we just take it from there.
- (void) seek:(NSInteger) anIndex 
{
    if (debug > 1) NSLog(@"seek entry -- seekIndex=%ld index=%ld\n", anIndex, index);
	if ( anIndex <= index ) {
		index = anIndex; // just jump; don't update stream charState (line, ...)
        if (debug > 1) NSLog(@"seek exit return -- index=%ld index=%ld\n", anIndex, index);
		return;
	}
	// seek forward, consume until index hits anIndex
	while ( index < anIndex ) {
		[self consume];
	}
    if (debug > 1) NSLog(@"seek exit end -- index=%ld index=%ld\n", anIndex, index);
}

// get a substring from our raw data.
- (NSString *) substring:(NSInteger)startIndex To:(NSInteger)stopIndex 
{
    NSRange theRange = NSMakeRange(startIndex, stopIndex-startIndex);
	return [data substringWithRange:theRange];
}

// get a substring from our raw data.
- (NSString *) substringWithRange:(NSRange) theRange 
{
	return [data substringWithRange:theRange];
}


- (NSUInteger) getLine
{
    return line;
}

- (NSUInteger) getCharPositionInLine
{
    return charPositionInLine;
}

- (void) setLine:(NSUInteger) aLine
{
    line = aLine;
}

- (void) setCharPositionInLine:(NSUInteger) pos
{
    charPositionInLine = pos;
}

- (PtrBuffer *)getMarkers
{
    return markers;
}

- (void) setMarkers:(PtrBuffer *)aMarkerList
{
    markers = aMarkerList;
}

- (NSString *)getSourceName
{
    return name;
}

- (void) setSourceName:(NSString *)aName
{
    if ( name != aName ) {
        name = aName;
    }
}


- (CharStreamState *)getCharState
{
    return charState;
}

- (void) setCharState:(CharStreamState *)aCharState
{
    charState = aCharState;
}

- (NSString *)description
{
    return (data != nil) ? [NSString stringWithString:data] : @"";
}

//---------------------------------------------------------- 
//  data 
//---------------------------------------------------------- 
- (NSString *) getData
{
    return data; 
}

- (void) setData: (NSString *) aData
{
    if (data != aData) {
        data = [NSString stringWithString:aData];
    }
}

@end
