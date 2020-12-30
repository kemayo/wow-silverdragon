#!/usr/bin/python

from . import luaparse


def serialize(v, key=str):
    """Serialize a lua table to a string
    
    Keyword arguments:
    key - function to pass to `sorted` when deciding the order to output table keys
    """
    if v is None:
        return "nil"
    t = type(v)
    if t == str:
        return '"' + v.replace('"', '\\"') + '"'
    if t in (list, tuple, set):
        return "{" + ",".join(map(serialize, v)) + "}"
    if t == dict:
        out = ["{"]
        lastindex = None
        for k in sorted(v.keys(), key=key):
            vk = serialize(v[k])
            k = str(k)
            if lastindex:
                out.append(',')
            if k.isnumeric():
                # If we've got mixed numeric and string keys, and the numeric
                # keys start at 1, leave out showing those keys while they're
                # in sequence.
                # TODO: could verify that *all* numeric keys are in sequence?
                if lastindex and lastindex.isnumeric() and int(lastindex) == int(k) - 1:
                    pass
                elif not lastindex and k == "1":
                    pass
                else:
                    out.extend(("[", k, "]="))
            elif not k.isalnum():
                out.extend(('["', k, '"]='))
            else:
                out.extend((k, '='))
            out.append(vk)
            lastindex = k
        out.append("}")
        return "".join(out)
    if t == bool:
        return v and "true" or "false"
    return str(v)


def loadtable(s):
    return luaparse.parse(s.strip())
