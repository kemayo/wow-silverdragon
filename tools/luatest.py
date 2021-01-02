from npc.lua import loadtable, serialize

tests = (
    '{name="Crystalfang",locations={[36]={21103290},[32]={32708710},[35]={33401940},},tameable=877478,}',
)

if __name__ == '__main__':
    for test in tests:
        print("Input", test)
        loaded = loadtable(test)
        print("Loaded", loaded)
        print("Serialized", serialize(loaded))
