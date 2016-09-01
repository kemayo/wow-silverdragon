#!/usr/bin/env python3

import re
import requests

from npc.zones import zoneid_to_mapid


def build_zone_map():
    page = requests.get("http://wow.zamimg.com/js/locale_enus.js?1472515060")
    if not page:
        return
    match = re.search(r"g_zones\s*=\s*({[^}]+});", page.text)
    if not match:
        return
    zone_map = {}
    for id, name in re.findall(r'"(\d+)":"([^"]+)"', match.group(1)):
        zone_map[int(id)] = name
    return zone_map

if __name__ == '__main__':
    items = list(build_zone_map().items())
    items.sort()
    missing = []
    for zid, name in items:
        mapid = zoneid_to_mapid.get(zid, False)
        if mapid:
            print("%d: %d,  # %s" % (zid, mapid, name))
        else:
            missing.append((zid, name))

    if missing:
        print("# Missing:")
        for data in missing:
            print("%d: False,  # %s" % data)
