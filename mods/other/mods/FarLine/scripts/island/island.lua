
-- create island
local island = easyEdit.island:add("FarLine")

island.name = "Far Line"

-- appends all assets in the path relative to mod's resource path
island:appendAssets("img/island/")

-- see the easyEdit wiki for details on everything below
island.shift = Point(17,13)
island.magic = Point(145,102)

island.regionData = {
	RegionInfo(Point(20,150), 	Point(-20,-35),		150),
	RegionInfo(Point(70,74), 	Point(-60,-5),		150),
	RegionInfo(Point(136,91), 	Point(-18,15),		100),
	RegionInfo(Point(241,36), 	Point(-5,0),		100),
	RegionInfo(Point(246,103), 	Point(-55,0),	 	300),
	RegionInfo(Point(238,183), 	Point(10,-10),	 	300),
	RegionInfo(Point(339,20), 	Point(-20,-15),		100),
	RegionInfo(Point(387,68), 	Point(-14,-45),	 	100)
}

island.network = {
	{1,2},
	{0,2,3},
	{0,1,3,4},
	{1,2,4,6},
	{2,3,5,7},
	{4,7},
	{3,7},
	{4,5,6}
}
