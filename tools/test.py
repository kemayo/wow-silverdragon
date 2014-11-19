import unittest

import npc.wowhead, npc.wowdb

class TestNPC:
    def setUp(self):
        pass

    def test_basics(self):
        npc = self.getNPC(69842)
        self.assertEqual(str(npc), "Zandalari Warbringer")
        self.assertTrue(type(npc.data['level']) is int)
        self.assertTrue(npc.data['elite'])
        self.assertEqual(npc.data['creature_type'], "Humanoid")
        self.assertFalse(npc.data['tameable'])

    def test_locations(self):
        npc = self.getNPC(69842)
        self.assertEqual(type(npc.data['locations']), dict)
        for zoneid in npc.data['locations'].keys():
            self.assertEqual(type(zoneid), int)
            for coord in npc.data['locations'][zoneid]:
                self.assertEqual(type(coord), int)
                self.assertTrue(coord > 0)
                self.assertTrue(coord < 100000000)

    def test_quests(self):
        npc = self.getNPC(77085)  # Dark Emanation
        self.assertEqual(npc.data['quest'], 33064)

        npc = self.getNPC(84810)  # Kalos the Bloodbathed
        self.assertEqual(npc.data['quest'], 36268)


class TestWowhead(TestNPC, unittest.TestCase):
    def getNPC(self, id):
        return npc.wowhead.WowheadNPC(id)

    def test_quests(self):
        TestNPC.test_quests(self)

        npc = self.getNPC(85264)  # Rolkor
        self.assertEqual(npc.data['quest'], 36393)


class TestWowdb(TestNPC, unittest.TestCase):
    def getNPC(self, id):
        return npc.wowdb.WowdbNPC(id)

    def test_vignettes(self):
        npc = self.getNPC(77085)  # Dark Emanation
        self.assertEqual(npc.data['vignette'], "Shadowmoon Cultist Ritual")


class TestInteractions(unittest.TestCase):
    def test_extend(self):
        kalos_wowdb = npc.wowdb.WowdbNPC(84810)
        kalos_wowhead = npc.wowhead.WowheadNPC(84810)
        kalos_wowhead.extend(kalos_wowdb)
        self.assertEqual(kalos_wowhead.data['quest'], 36268)

if __name__ == '__main__':
    unittest.main()
