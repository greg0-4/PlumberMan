Cd(__DIR__);
#include "Collisions.HC";
#define MAP_WIDTH 27
#define MAP_HEIGHT 20
#define GRAVITY 1


CDC *tex_brick = GRRead("Sprites/Brick.GR.Z"); 
CDC *tex_tile = GRRead("Sprites/Tile.GR.Z");

I64 map[MAP_HEIGHT][MAP_WIDTH] = {
  {0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
};

U0 InitMapColliders()
{
  I64 x,y;
  for(x=0;x<MAP_WIDTH;x++)
  {
    for(y=0;y<MAP_HEIGHT;y++)
    {
      I64 tile = map[y][x];
      if(tile == 1)
      {
	NewCollider(x * 24, y * 24, 24, 24, 2);
      }
    }
  }
}

U0 DrawMap(CDC *dc)
{
  I64 x,y;
  for(x=0;x<MAP_WIDTH;x++)
  {
    for(y=0;y<MAP_HEIGHT;y++)
    {
      I64 tile = map[y][x];
      if(tile == 1)
      {
	GrBlot(dc, x * 24, y * 24, tex_brick);
      }
    }
  }
}



class Keys
{
  Bool up,down,left,right,actionA,startB;
};

class Player
{
  U64 score;
  Bool grounded;
  Vector2 velocity;
  Collider *myCollider;
};

// Global Vars

Keys keys;

Player plr;


U0 Init()
{
  keys.up = FALSE;
  keys.down = FALSE;
  keys.left = FALSE;
  keys.right = FALSE;
  keys.actionA = FALSE;
  keys.startB = FALSE;
  QueInit(&collider_que);

  plr.myCollider = NewCollider(50, 20, 24, 24, 1);
  InitMapColliders;    

}

Bool g_Running = TRUE;

U0 MovePlayer()
{

  plr.velocity.x = 0;

  if(!plr.grounded)
  {
    plr.velocity.y += GRAVITY;
  }
  
  if(keys.up && plr.grounded)
  {
    plr.velocity.y = -15; 
    plr.grounded = FALSE;
  }

  if(plr.velocity.y > 8)
  {
    plr.velocity.y = 8;
  }


  if(keys.down)
  {
    plr.myCollider->position.y++;
  }

  // X Axis
  if(keys.left)
  {
    plr.velocity.x = -4;
  }
  if(keys.right)
  {
    plr.velocity.x = 4;
  }

  plr.myCollider->position.x += plr.velocity.x;

  if(CheckMapCollision(plr.myCollider))
  {
    plr.myCollider->position.x -= plr.velocity.x;
  }

  // Y Axis
  plr.myCollider->position.y += plr.velocity.y;
 
  if(CheckMapCollision(plr.myCollider))
  {
    plr.myCollider->position.y -= plr.velocity.y;
    plr.grounded = TRUE;
    plr.velocity.y = 0;
  }else
  {
    plr.grounded = FALSE;
  }


}

U0 DrawIt(CTask *task, CDC *dc)
{
  MovePlayer;
  DrawColliders(dc);
  DrawMap(dc);
  GrPrint(dc, 0, 0, "Velocity: %f",plr.myCollider->position.x);
}


U0 PlumberMan()
{
  Init;
  I64 input1, input2;
  DocClear;
  SettingsPush;
  DocCursor;
  AutoComplete;
  WinMax;
  WinBorder;

  Fs->draw_it = &DrawIt;
 
  try{
    while(g_Running)
    {
      switch(GetMsg(&input1, &input2, 1<<MSG_KEY_DOWN+1<<MSG_KEY_UP))
      {
	case MSG_KEY_UP:
	  switch(input1)
          {
	    case CH_SHIFT_ESC: g_Running = FALSE; break;
	    case CH_SPACE: keys.actionA = FALSE; break;
	    case 0:

	      switch(input2.u8[0])$IV,0$
	      {
		case SC_CURSOR_UP: keys.up = FALSE; break;
		case SC_CURSOR_DOWN: keys.down = FALSE; break;
		case SC_CURSOR_LEFT: keys.left = FALSE; break;
		case SC_CURSOR_RIGHT: keys.right = FALSE; break;
	      }

	    break;
	  }
	break;

	case MSG_KEY_DOWN:
	  switch(input1)
          {
	    case CH_SPACE: keys.actionA = TRUE; break;
	    case 0:

	      switch(input2.u8[0])
	      {
		case SC_CURSOR_UP: keys.up = TRUE; break;
		case SC_CURSOR_DOWN: keys.down = TRUE; break;
		case SC_CURSOR_LEFT: keys.left = TRUE; break;
		case SC_CURSOR_RIGHT: keys.right = TRUE; break;
	      }

	    break;
	  }
	break;

      }
    }
  }catch{
    SettingsPop;
    PutExcept;
  }
  SettingsPop;
}

PlumberMan;