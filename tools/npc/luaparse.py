import ply.yacc as yacc
import ply.lex as lex

""" Lua table syntax parser

Important reference: http://www.lua.org/manual/5.1/manual.html#8

This is incomplete. It parses enough of Lua's syntax to handle non-fancy
tables. In the official grammar provided in the manual, it starts at
"tableconstructor". It has no support for functions, or for complicated
expressions as table values. (e.g. `t[var]` will just error.)

"""

# Lexer

tokens = (
    'OPBRACE',
    'CLBRACE',
    'OPBRAK',
    'CLBRAK',
    'STRING',
    'NAME',
    'NUMBER',
    'EQUALS',
    'COMMA',
    'SEMICOLON',
    'BOOL',
    'NIL',
    'NEWLINE',
)
t_OPBRACE = r'{'
t_CLBRACE = r'}'
t_OPBRAK = r'\['
t_CLBRAK = r'\]'
t_NAME = r'[A-Za-z_][A-Za-z_0-9]*'
t_EQUALS = r'='
t_COMMA = r','
t_SEMICOLON = r';'

t_ignore = r' '


# a string is quotes around a sequence of anything that's not-quotes-or-backslashes, or backslash+char
def t_STRING(t):
    r'"(?:[^"\\]|\\.)*?"|\'(?:[^\'\\]|\\.)*?\''
    t.value = t.value[1:-1].replace(r'\"', '"')
    return t


def t_NUMBER(t):
    r'\-?\d+(?:\.\d+)?'
    if '.' in t.value:
        t.value = float(t.value)
    else:
        t.value = int(t.value)
    return t


def t_BOOL(t):
    r'true|false'
    t.value = t.value == 'true'
    return t


def t_NIL(t):
    r'nil'
    t.value = None
    return t


def t_NEWLINE(t):
    r'\n+'
    t.lexer.lineno += t.value.count("\n")
    return t


def t_error(t):
    raise SyntaxError("Error parsing, illegal character '%s' @ line %d" % (t.value[0], t.lineno))
    # t.lexer.skip(1)

lexer = lex.lex()


# Parser


def p_tableconstructor(p):
    '''tableconstructor : OPBRACE fieldlist CLBRACE
    '''
    p[0] = p[2]
    # If this is a pure numeric-keys table, turn it into a python list
    # Could argue this shouldn't be done, since it changes the index start
    for i in range(1, len(p[0]) + 1):
        if i not in p[0]:
            return
    items = list(p[0].items())
    items.sort()
    p[0] = [item[1] for item in items]


def p_fieldlist(p):
    '''fieldlist : fieldlist_internal fieldsep
                 | fieldlist_internal
    '''
    p[0] = p[1]


def p_fieldlist_internal(p):
    '''fieldlist_internal : fieldlist_internal fieldsep field
                          | field
    '''
    # Exists to work around allowing multiple trailing commas
    if len(p) == 3:
        p[0] = p[1]
        return
    if len(p) == 4:
        p[0] = p[1]
        val = p[3]
    else:
        p[0] = {}
        val = p[1]

    if val[0] is None:
        for i in range(1, len(p[0]) + 2):
            if i not in p[0]:
                p[0][i] = val[1]
                break
    else:
        p[0][val[0]] = val[1]


def p_fieldsep(p):
    '''fieldsep : COMMA
                | SEMICOLON
    '''
    pass


def p_field(p):
    '''field : OPBRAK exp CLBRAK EQUALS exp
             | NAME EQUALS exp
             | exp
    '''
    # print(len(p), p[:])
    if len(p) == 6:
        p[0] = (p[2], p[5])
    elif len(p) == 4:
        p[0] = (p[1], p[3])
    elif len(p) == 2:
        p[0] = (None, p[1])


def p_exp(p):
    '''exp : NIL
           | BOOL
           | NUMBER
           | STRING
           | tableconstructor
    '''
    # Note: incomplete, both in accepted values and in handling-of-values
    # Most importantly: NAME isn't handled, so this deals solely with literals
    p[0] = p[1]


def p_error(p):
    if not p:
        print("SYNTAX ERROR")

parser = yacc.yacc()


def parse(s):
    parser.error = 0
    p = parser.parse(s)
    if parser.error:
        return None
    return p


if __name__ == '__main__':
    # s = '{23.4, "pony express\\" ri\'de", \'Test\\\'s fun\', 4, "apple", fred=400, ["foo"]=999, [90]="beauty", {1,2}, p={2},}'
    s = r'{[61] = {name="Thuros \"Fred\" Lightfingers",["creature_type"]="Humanoid",level=9,locations={[30]={50408320,50408280},},},}'
    print(s)

    lexer.input(s)
    for token in lexer:
        print(token)

    print(parse(s))
