
-- create island
local island = easyEdit.island:add("Watchtower")

island.name = "Watchtower"

-- appends all assets in the path relative to mod's resource path
island:appendAssets("img/island/")

-- see the easyEdit wiki for details on everything below
island.shift = Point(17,13)--(14,13)
island.magic = Point(145,102)

island.regionData = {
	RegionInfo(Point(14,220), 	Point(40,-35),		150),
	RegionInfo(Point(84,76), 	Point(0,20),		100),
	RegionInfo(Point(139,194), 	Point(12,-35),		100),
	RegionInfo(Point(191,109), 	Point(-25,-25),		100),
	RegionInfo(Point(191,24), 	Point(25,-30),	 	100),
	RegionInfo(Point(260,92), 	Point(-5,-55),	 	100),
	RegionInfo(Point(246,222), 	Point(30,-65),		300),
	RegionInfo(Point(216,194), 	Point(-14,-60),	 	100)
}

island.network = {
	{1,2},
	{0,2,3,4},
	{0,1,3,7},
	{1,2,4,5,7},
	{1,3,5},
	{4,3,7,6},
	{5,7},
	{2,3,5,6}
}
