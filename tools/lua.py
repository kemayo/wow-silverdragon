#!/usr/bin/python

def serialize(v):
    if v == None:
        return 'nil'
    t = type(v)
    if t == str:
        return '"' + v.replace('"', '\\"') + '"'
    if t in (list, tuple, set):
        return '{' + ','.join(map(serialize, v)) + '}'
    if t == dict:
        out = ['{']
        for k in v:
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
