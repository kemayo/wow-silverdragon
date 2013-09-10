import unittest

import npc.wowhead, npc.wowdb

class TestNPC:
    def setUp(self):
        pass

    def test_basics(self):
        self.assertEqual(str(self.npc), "Zandalari Warbringer")
        self.assertEqual(self.npc.data['level'], 92)
        self.assertTrue(self.npc.data['elite'])
        self.assertEqual(self.npc.data['creature_type'], "Humanoid")
        self.assertFalse(self.npc.data['tameable'])

    def test_locations(self):
        self.assertEqual(type(self.npc.data['locations']), dict)
        for zoneid in self.npc.data['locations'].keys():
            self.assertEqual(type(zoneid), int)
            for coord in self.npc.data['locations'][zoneid]:
                self.assertEqual(type(coord), int)
                self.assertTrue(coord > 0)
                self.assertTrue(coord < 100000000)

class TestWowhead(TestNPC, unittest.TestCase):
    def setUp(self):
        self.npc = npc.wowhead.WowheadNPC(69842)

class TestWowdb(TestNPC, unittest.TestCase):
    def setUp(self):
        self.npc = npc.wowdb.WowdbNPC(69842)

if __name__ == '__main__':
    unittest.main()
