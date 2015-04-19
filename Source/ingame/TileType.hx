	enum TileType 
	{
	  Floor;
	  Flooded;
	  Wall;
	  Hole;
	  CorpseStart;
	  WoundedStart;
	  BoardsStart;
	  PlayerStart;
	  CannisterStart;
	  Exit;
	  DoorSwitch(circuit : UInt);
	  Door(circuit : UInt);
	}