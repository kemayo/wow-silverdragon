#!/usr/bin/python

from . import luaparse


def serialize(v):
    if v is None:
        return 'nil'
    t = type(v)
    if t == str:
        return '"' + v.replace('"', '\\"') + '"'
    if t in (list, tuple, set):
        return '{' + ','.join(map(serialize, v)) + '}'
    if t == dict:
        out = ['{']
        # Yeah, this isn't very generic. But I want 'name' to always be first.
        for k in sorted(v.keys(), key=__sort):
            vk = serialize(v[k])
            k = str(k)
            if k.isnumeric():
                out.extend(('[', k, ']'))
            elif not k.isalnum():
                out.extend(('["', k, '"]'))
            else:
                out.append(k)
            out.extend(('=', vk, ','))
        out.append('}')
        return ''.join(out)
    if t == bool:
        return v and 'true' or 'false'
    return str(v)


def __sort(k):
    if k == 'name':
        return 'aaaaaaaaa'
    return k


def loadtable(s):
    return luaparse.parse(s.strip())
