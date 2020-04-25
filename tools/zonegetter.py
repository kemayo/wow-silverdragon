#!/usr/bin/env python3

import csv
import re
import requests
import sys

from npc.zones import zoneid_to_mapid


def fetch_zone_map():
    # page = requests.get("http://wow.zamimg.com/js/locale/enus.js?1530549634")
    page = requests.get("http://wow.zamimg.com/js/locale/built/beta.js?1530549631")
    if not page:
        return
    match = re.search(r"g_zones\s*=\s*({[^}]+});", page.text)
    if not match:
        return
    zone_map = {}
    for id, name in re.findall(r'"(\-?\d+)":"([^"]+)"', match.group(1)):
        zone_map[int(id)] = name
    return zone_map


def output_zone_map(zone_map, current_data):
    items = list(zone_map.items())
    items.sort()
    missing = []
    for zid, name in items:
        mapid = current_data.get(zid, False)
        if mapid:
            print("%d: %d,  # %s" % (zid, mapid, name))
        else:
            missing.append((zid, name))

    if missing:
        print("# Missing:")
        for data in missing:
            print("%d: False,  # %s" % data)


def update_zone_map_from_csv(current_data, filename):
    """Assumes the CSV file from Blizzard_Deprecated"""
    with open(filename, newline="") as csvfile:
        reader = csv.DictReader(csvfile)
        zonemap = {}
        for row in reader:
            if not row["DungeonMapID"] or row["DungeonFloor"] == "1":
                zonemap[int(row["WorldMapAreaID"])] = int(row["UiMapID"])

    new_data = {}
    for zoneid, mapid in current_data.items():
        new_data[zoneid] = zonemap.get(mapid)
        if mapid and not zonemap.get(mapid):
            print("FAILED", zoneid, mapid)
    return new_data


if __name__ == "__main__":
    if len(sys.argv) > 1:
        current_data = update_zone_map_from_csv(zoneid_to_mapid, sys.argv[1])
    else:
        current_data = zoneid_to_mapid

    output_zone_map(fetch_zone_map(), current_data)
