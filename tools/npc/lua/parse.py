import ply.yacc as yacc
import ply.lex as lex

""" Lua table syntax parser

Important reference: http://www.lua.org/manual/5.1/manual.html#8

This is incomplete. It parses enough of Lua's syntax to handle non-fancy
tables. In the official grammar provided in the manual, it uses "exp" as its
entry point but doesn't handle function definitions. It has limited support for
complicated expressions, but doesn't attempt to make sense of them.

"""


class Literal:
    """This exists to wrap content that's not really handled by this parser
    but which should be preserved literally for output

    e.g. it wraps around all variable names
    """
    def __init__(self, content):
        self.content = [content]
    def __repr__(self):
        return ''.join(self.content)
    def extend(self, content):
        self.content.extend(content)


class BinOp:
    def __init__(self, left, op, right):
        self.left = left
        self.right = right
        self.op = op
    def __repr__(self):
        # repr is needed on the values to preserve strings
        return f'{repr(self.left)} {self.op} {repr(self.right)}'


class UnOp:
    def __init__(self, op, exp):
        self.exp = exp
        self.op = op
    def __repr__(self):
        return f'{self.op} {repr(self.exp)}'


class FunctionCall:
    def __init__(self, name, args):
        self.name = name
        self.args = args
    def __repr__(self):
        return repr(self.name) + "(" + repr(self.args) + ")"


# Lexer

reserved = {
    # "if" : "IF",
    # "then" : "THEN",
    # "else" : "ELSE",
    # "while" : "WHILE",
    # "for" : "FOR",
    # "return" : "RETURN"
    "and" : "AND",
    "or" : "OR",
    "not" : "NOT",
}
tokens = [
    "OPBRACE",
    "CLBRACE",
    "OPBRAK",
    "CLBRAK",
    "OPPAREN",
    "CLPAREN",
    "STRING",
    "NAME",
    "NUMBER",
    "EQUALS",
    "DOT",
    "COMMA",
    "COLON",
    "SEMICOLON",
    "BOOL",
    "NIL",
    "NEWLINE",
    "COMPARISON",
    "OPERATOR",
    "OPERATOR_MINUS",
    "DOTDOT",
    "HASH",
] + list(reserved.values())
t_OPBRACE = r"{"
t_CLBRACE = r"}"
t_OPBRAK = r"\["
t_CLBRAK = r"\]"
t_OPPAREN = r"\("
t_CLPAREN = r"\)"
t_COMPARISON = r"(?:<=|<|>=|>|==|~=)"
t_OPERATOR = r"(?:\+|\*|\^|%)"
t_OPERATOR_MINUS = r"-"
t_HASH = r"\#"
t_EQUALS = r"="
t_DOTDOT = r"\.\."
t_DOT = r"\."
t_COMMA = r","
t_COLON = r":"
t_SEMICOLON = r";"

t_ignore = r" "


def t_NAME(t):
    r"[A-Za-z_][A-Za-z_0-9]*"
    t.type = reserved.get(t.value, 'NAME')  # check for reserved words
    return t

# a string is quotes around a sequence of anything that's not-quotes-or-backslashes, or backslash+char
def t_STRING(t):
    r'"(?:[^"\\]|\\.)*?"|\'(?:[^\'\\]|\\.)*?\''
    t.value = t.value[1:-1].replace(r"\"", '"')
    return t


def t_NUMBER(t):
    r"\-?\d+(?:\.\d+)?"
    if "." in t.value:
        t.value = float(t.value)
    else:
        t.value = int(t.value)
    return t


def t_BOOL(t):
    r"true|false"
    t.value = t.value == "true"
    return t


def t_NIL(t):
    r"nil"
    t.value = None
    return t


def t_NEWLINE(t):
    r"\n+"
    t.lexer.lineno += t.value.count("\n")
    return t


def t_error(t):
    raise SyntaxError(
        "Error parsing, illegal character '%s' @ line %d" % (t.value[0], t.lineno)
    )
    # t.lexer.skip(1)


lexer = lex.lex()


# Parser


def p_exp(p):
    """exp : NIL
           | BOOL
           | NUMBER
           | STRING
           | tableconstructor
           | prefixexp
           | exp binop exp
           | unop exp
    """
    # Note: incomplete, both in accepted values and in handling-of-values.
    if len(p) == 3:
        # unop exp
        p[0] = UnOp(p[1], p[2])
    elif len(p) == 4:
        # exp binop exp
        p[0] = BinOp(p[1], p[2], p[3])
    else:
        p[0] = p[1]


def p_binop(p):
    """binop : OPERATOR
             | OPERATOR_MINUS
             | DOTDOT
             | COMPARISON
             | AND
             | OR
    """
    p[0] = Literal(p[1])


def p_unop(p):
    """unop : OPERATOR_MINUS
            | NOT
            | HASH
    """
    p[0] = Literal(p[1])


def p_tableconstructor(p):
    """tableconstructor : OPBRACE fieldlist CLBRACE
                        | OPBRACE CLBRACE
    """
    if len(p) == 3:
        # the empty-table case
        # Arguable whether this should become a dict or a list...
        p[0] = {}
        return
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
    """fieldlist : fieldlist_internal fieldsep
                 | fieldlist_internal
    """
    p[0] = p[1]


def p_fieldlist_internal(p):
    """fieldlist_internal : fieldlist_internal fieldsep field
                          | field
    """
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
    """fieldsep : COMMA
                | SEMICOLON
    """
    pass


def p_field(p):
    """field : OPBRAK exp CLBRAK EQUALS exp
             | NAME EQUALS exp
             | exp
    """
    # print(len(p), p[:])
    if len(p) == 6:
        p[0] = (p[2], p[5])
    elif len(p) == 4:
        p[0] = (p[1], p[3])
    elif len(p) == 2:
        p[0] = (None, p[1])


def p_var(p):
    """var : prefixexp DOT NAME
           | prefixexp OPBRAK exp CLBRAK
           | NAME
    """
    # print(p[1], len(p) > 2 and p[3])
    if len(p) == 2:
        # `name`
        p[0] = Literal(p[1])
    elif p[2] == "[":
        # `prefix[exp]`
        p[0] = Literal(f"{p[1]}[{p[3]}]")
    elif p[2] == ".":
        # `prefix.name`
        p[1].extend(p[2:])
        p[0] = p[1]


def p_prefixexp(p):
    """prefixexp : var
                 | functioncall
                 | OPPAREN exp CLPAREN
    """
    if p[1] == "(":
        p[0] = p[2]
    else:
        p[0] = p[1]


def p_functioncall(p):
    """functioncall : prefixexp args
                    | prefixexp COLON NAME args
    """
    if p[2] == ":":
        p[1].extend((':', p[3]))
        p[0] = FunctionCall(p[1], p[4])
    else:
        p[0] = FunctionCall(p[1], p[2])


def p_args(p):
    """args : OPPAREN explist CLPAREN
            | tableconstructor
            | STRING
    """
    if p[1] == "(":
        p[0] = p[2]
    else:
        p[0] = [p[1]]


def p_explist(p):
    """explist : explist COMMA exp
               | exp
               |
    """
    if len(p) == 1:
        p[0] = []
    if len(p) == 2:
        p[0] = [p[1]]
    if len(p) == 4:
        p[1].append(p[3])
        p[0] = p[1]


def p_error(p):
    if not p:
        print("SYNTAX ERROR")


parser = yacc.yacc()


def parse(s, *args, **kwargs):
    parser.error = 0
    p = parser.parse(s, *args, **kwargs)
    if parser.error:
        # print(parser.error)
        return None
    return p


if __name__ == "__main__":
    # s = '{23.4, "pony express\\" ri\'de", \'Test\\\'s fun\', 4, "apple", fred=400, ["foo"]=999, [90]="beauty", {1,2}, p={2},}'
    # s = r'{[61] = {name="Thuros \"Fred\" Lightfingers",["creature_type"]="Humanoid",level=9,locations={[30]={50408320,50408280},},},loot={},test=Enum.foo.bar}'
    s = r'{a=b.c.d, c[1], d[-e], q={}, qq={1,2,-3}, x=aa.y:frog{z, not zz, not not zzz, "hi".."bye", {a=b(), s=s(1,2, a>=4)}, t=22}}'
    print(s)

    lexer.input(s)
    for token in lexer:
        print(token)

    print(parse(s, debug=False))
