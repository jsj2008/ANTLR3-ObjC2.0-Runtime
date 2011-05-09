/** \file
 *  This OBJC source file was generated by $ANTLR version ${project.version} ${buildNumber}
 *
 *     -  From the grammar source file : Poly.g
 *     -                            On : 2011-05-06 19:17:59
 *     -                 for the lexer : PolyLexerLexer
 *
 * Editing it, at least manually, is not wise.
 *
 * ObjC language generator and runtime by Alan Condit, acondit|hereisanat|ipns|dotgoeshere|com.
 *
 *
*/
// $ANTLR ${project.version} ${buildNumber} Poly.g 2011-05-06 19:17:59


/* -----------------------------------------
 * Include the ANTLR3 generated header file.
 */
#import "PolyLexer.h"
/* ----------------------------------------- */


/* ============================================================================= */
/* =============================================================================
 * Start of recognizer
 */

/** As per Terence: No returns for lexer rules! */
@implementation PolyLexer // line 330

+ (void) initialize
{
    [ANTLRBaseRecognizer setGrammarFileName:@"Poly.g"];
}

+ (NSString *) tokenNameForType:(NSInteger)aTokenType
{
    return [[self getTokenNames] objectAtIndex:aTokenType];
}

+ (PolyLexer *)newPolyLexerWithCharStream:(id<ANTLRCharStream>)anInput
{
    return [[PolyLexer alloc] initWithCharStream:anInput];
}

- (id) initWithCharStream:(id<ANTLRCharStream>)anInput
{
    self = [super initWithCharStream:anInput State:[[ANTLRRecognizerSharedState newANTLRRecognizerSharedStateWithRuleLen:6+1] retain]];
    if ( self != nil ) {
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

/* ObjC Start of actions.lexer.methods */
/* ObjC end of actions.lexer.methods */
/* ObjC start methods() */
/* ObjC end methods() */

/* Start of Rules */
// $ANTLR start "T__8"
- (void) mT__8
{
    //
    /* my ruleScopeSetUp */
    /* Terence's stuff */

    @try {
        NSInteger _type = T__8;
        NSInteger _channel = ANTLRTokenChannelDefault;
        // Poly.g:7:6: ( '+' ) // ruleBlockSingleAlt
        // Poly.g:7:8: '+' // alt
        {
        [self matchChar:'+']; 


        }

        // token+rule list labels

        state.type = _type;
        state.channel = _channel;
    }
    @finally {
        //
        /* Terence's stuff */

    }
    return;
}
/* $ANTLR end "T__8" */

// $ANTLR start "T__9"
- (void) mT__9
{
    //
    /* my ruleScopeSetUp */
    /* Terence's stuff */

    @try {
        NSInteger _type = T__9;
        NSInteger _channel = ANTLRTokenChannelDefault;
        // Poly.g:8:6: ( '^' ) // ruleBlockSingleAlt
        // Poly.g:8:8: '^' // alt
        {
        [self matchChar:'^']; 


        }

        // token+rule list labels

        state.type = _type;
        state.channel = _channel;
    }
    @finally {
        //
        /* Terence's stuff */

    }
    return;
}
/* $ANTLR end "T__9" */

// $ANTLR start "ID"
- (void) mID
{
    //
    /* my ruleScopeSetUp */
    /* Terence's stuff */

    NSString * value = nil ;


    @try {
        NSInteger _type = ID;
        NSInteger _channel = ANTLRTokenChannelDefault;
        // Poly.g:22:5: ( ( 'a' .. 'z' )+ ) // ruleBlockSingleAlt
        // Poly.g:22:7: ( 'a' .. 'z' )+ // alt
        {
        // Poly.g:22:7: ( 'a' .. 'z' )+ // positiveClosureBlock
        NSInteger cnt1 = 0;
        do {
            NSInteger alt1 = 2;
            NSInteger LA1_0 = [input LA:1];
            if ( ((LA1_0 >= 'a' && LA1_0 <= 'z')) ) {
                alt1=1;
            }


            switch (alt1) {
                case 1 : ;
                    // Poly.g: // alt
                    {
                    if ((([input LA:1] >= 'a') && ([input LA:1] <= 'z'))) {
                        [input consume];
                    } else {
                        ANTLRMismatchedSetException *mse = [ANTLRMismatchedSetException newException:nil stream:input];
                        [self recover:mse];
                        @throw mse;
                    }


                    }
                    break;

                default :
                    if ( cnt1 >= 1 )
                        goto loop1;
                    ANTLREarlyExitException *eee =
                        [ANTLREarlyExitException newException:input decisionNumber:1];
                    @throw eee;
            }
            cnt1++;
        } while (YES);
        loop1: ;


        }

        // token+rule list labels

        state.type = _type;
        state.channel = _channel;
    }
    @finally {
        //
        /* Terence's stuff */

    }
    return;
}
/* $ANTLR end "ID" */

// $ANTLR start "INT"
- (void) mINT
{
    //
    /* my ruleScopeSetUp */
    /* Terence's stuff */

    NSString * value = nil ;


    @try {
        NSInteger _type = INT;
        NSInteger _channel = ANTLRTokenChannelDefault;
        // Poly.g:25:5: ( ( '0' .. '9' )+ ) // ruleBlockSingleAlt
        // Poly.g:25:7: ( '0' .. '9' )+ // alt
        {
        // Poly.g:25:7: ( '0' .. '9' )+ // positiveClosureBlock
        NSInteger cnt2 = 0;
        do {
            NSInteger alt2 = 2;
            NSInteger LA2_0 = [input LA:1];
            if ( ((LA2_0 >= '0' && LA2_0 <= '9')) ) {
                alt2=1;
            }


            switch (alt2) {
                case 1 : ;
                    // Poly.g: // alt
                    {
                    if ((([input LA:1] >= '0') && ([input LA:1] <= '9'))) {
                        [input consume];
                    } else {
                        ANTLRMismatchedSetException *mse = [ANTLRMismatchedSetException newException:nil stream:input];
                        [self recover:mse];
                        @throw mse;
                    }


                    }
                    break;

                default :
                    if ( cnt2 >= 1 )
                        goto loop2;
                    ANTLREarlyExitException *eee =
                        [ANTLREarlyExitException newException:input decisionNumber:2];
                    @throw eee;
            }
            cnt2++;
        } while (YES);
        loop2: ;


        }

        // token+rule list labels

        state.type = _type;
        state.channel = _channel;
    }
    @finally {
        //
        /* Terence's stuff */

    }
    return;
}
/* $ANTLR end "INT" */

// $ANTLR start "WS"
- (void) mWS
{
    //
    /* my ruleScopeSetUp */
    /* Terence's stuff */

    @try {
        NSInteger _type = WS;
        NSInteger _channel = ANTLRTokenChannelDefault;
        // Poly.g:27:4: ( ( ' ' | '\\t' | '\\r' | '\\n' )+ ) // ruleBlockSingleAlt
        // Poly.g:27:6: ( ' ' | '\\t' | '\\r' | '\\n' )+ // alt
        {
        // Poly.g:27:6: ( ' ' | '\\t' | '\\r' | '\\n' )+ // positiveClosureBlock
        NSInteger cnt3 = 0;
        do {
            NSInteger alt3 = 2;
            NSInteger LA3_0 = [input LA:1];
            if ( ((LA3_0 >= '\t' && LA3_0 <= '\n')||LA3_0=='\r'||LA3_0==' ') ) {
                alt3=1;
            }


            switch (alt3) {
                case 1 : ;
                    // Poly.g: // alt
                    {
                    if ((([input LA:1] >= '\t') && ([input LA:1] <= '\n'))||[input LA:1] == '\r'||[input LA:1] == ' ') {
                        [input consume];
                    } else {
                        ANTLRMismatchedSetException *mse = [ANTLRMismatchedSetException newException:nil stream:input];
                        [self recover:mse];
                        @throw mse;
                    }


                    }
                    break;

                default :
                    if ( cnt3 >= 1 )
                        goto loop3;
                    ANTLREarlyExitException *eee =
                        [ANTLREarlyExitException newException:input decisionNumber:3];
                    @throw eee;
            }
            cnt3++;
        } while (YES);
        loop3: ;


         _channel=HIDDEN; 


        }

        // token+rule list labels

        state.type = _type;
        state.channel = _channel;
    }
    @finally {
        //
        /* Terence's stuff */

    }
    return;
}
/* $ANTLR end "WS" */

- (void) mTokens
{
    // Poly.g:1:8: ( T__8 | T__9 | ID | INT | WS ) //ruleblock
    NSInteger alt4=5;
    unichar charLA4 = [input LA:1];
    switch (charLA4) {
        case '+': ;
            {
            alt4=1;
            }
            break;
        case '^': ;
            {
            alt4=2;
            }
            break;
        case 'a': ;
        case 'b': ;
        case 'c': ;
        case 'd': ;
        case 'e': ;
        case 'f': ;
        case 'g': ;
        case 'h': ;
        case 'i': ;
        case 'j': ;
        case 'k': ;
        case 'l': ;
        case 'm': ;
        case 'n': ;
        case 'o': ;
        case 'p': ;
        case 'q': ;
        case 'r': ;
        case 's': ;
        case 't': ;
        case 'u': ;
        case 'v': ;
        case 'w': ;
        case 'x': ;
        case 'y': ;
        case 'z': ;
            {
            alt4=3;
            }
            break;
        case '0': ;
        case '1': ;
        case '2': ;
        case '3': ;
        case '4': ;
        case '5': ;
        case '6': ;
        case '7': ;
        case '8': ;
        case '9': ;
            {
            alt4=4;
            }
            break;
        case '\t': ;
        case '\n': ;
        case '\r': ;
        case ' ': ;
            {
            alt4=5;
            }
            break;

    default: ;
        ANTLRNoViableAltException *nvae = [ANTLRNoViableAltException newException:4 state:0 stream:input];
        nvae.c = charLA4;
        @throw nvae;

    }

    switch (alt4) {
        case 1 : ;
            // Poly.g:1:10: T__8 // alt
            {
            [self mT__8]; 



            }
            break;
        case 2 : ;
            // Poly.g:1:15: T__9 // alt
            {
            [self mT__9]; 



            }
            break;
        case 3 : ;
            // Poly.g:1:20: ID // alt
            {
            [self mID]; 



            }
            break;
        case 4 : ;
            // Poly.g:1:23: INT // alt
            {
            [self mINT]; 



            }
            break;
        case 5 : ;
            // Poly.g:1:27: WS // alt
            {
            [self mWS]; 



            }
            break;

    }

}

@end /* end of PolyLexer implementation line 397 */