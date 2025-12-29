
-- create island
local island = easyEdit.island:add("Vertex")

island.name = "Vertex"

-- appends all assets in the path relative to mod's resource path
island:appendAssets("img/island/")

-- see the easyEdit wiki for details on everything below
island.shift = Point(17,13)-- transition
island.magic = Point(145,102)

island.regionData = {
	RegionInfo(Point(163,19), 	Point(55,-60),		100),   -- 0  textoffset: > +X   ^ -y
	RegionInfo(Point(259,60), 	Point(25,-55),		100),   -- 1
	RegionInfo(Point(211,153), 	Point(42,-25),		200),   -- 2
	RegionInfo(Point(287,213), 	Point(55,-20),		100),   -- 3
	RegionInfo(Point(148,73), 	Point(25,-30),	 	150),   -- 4
	RegionInfo(Point(18,84), 	Point(78,-75),	 	150),   -- 5
	RegionInfo(Point(20,158), 	Point(65,-45),		150),   -- 6
	RegionInfo(Point(125,158), 	Point(6,-25),	 	100)    -- 7
}

island.network = {
	{1,4},
	{0,2,3},
	{1,3,4},
	{1,2},
	{0,2,5,7},
	{4,6,7},
	{5,7},
	{4,5,6}
}