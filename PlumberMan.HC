 Cd(__DIR__);
#include "Collisions.HC";
#define MAP_WIDTH 27
#define MAP_HEIGHT 20
#define ACCEL	 1.1
#define FRICTION 1.2
#define GRAVITY 1


CDC *tex_brick = GRRead("Sprites/Brick.GR.Z"); 
CDC *tex_tile = GRRead("Sprites/Tile.GR.Z");
CDC *tex_pow = GRRead("Sprites/PowBlock.GR.Z");

I64 map[MAP_HEIGHT][MAP_WIDTH] = {
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,2,2,2,2,2,2,2,2,2,2,2,0,0,0,2,2,2,2,2,2,2,2,2,2,2,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,2,2,0,0,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,0,0,2,2,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,1},
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
      }else if(tile == 2)
      {
	NewCollider(x * 24, y * 24, 24, 24 , 3);
      }else if(tile == 3)
      {
        NewCollider(x * 24, y * 24, 24 ,24 , 4);
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
      }else if(tile == 2)
      {
	GrBlot(dc, x * 24, y * 24, tex_tile);
      }else if(tile == 3)
      {
	GrBlot(dc, x * 24, y * 24, tex_pow);
      }

    }
  }
}



class Keys
{
  Bool up,down,left,right,actionA,actionB,startB;
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
  keys.actionB = FALSE;
  keys.startB = FALSE;
  QueInit(&collider_que);

  plr.myCollider = NewCollider(48, 48, 12, 24, 1);
  InitMapColliders;    

}

Bool g_Running = TRUE;

U0 MovePlayer()
{


  if(keys.right) plr.velocity.x += ACCEL;
  if(keys.left) plr.velocity.x -= ACCEL;

  plr.velocity.x /= FRICTION;

  if(Abs(plr.velocity.x) >= 5)
  {
    if(plr.velocity.x > 0)
    {
      plr.velocity.x = 5;
    }else
    {
      plr.velocity.x = -5;
    }
  }

  plr.myCollider->position.x += plr.velocity.x;

  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    if(temp != plr.myCollider && isColliding(plr.myCollider, temp))
    {
      if(temp->type == 2 || temp->type == 3)
      {
        if(plr.velocity.x > 0)
        {
          plr.myCollider->position.x = temp->position.x - 1 - plr.myCollider->size.x;
        }
        else
        {
          plr.myCollider->position.x = temp->position.x + 1 + temp->size.x;
        }
      }
    }
    temp = next;
  }

  plr.velocity.y += GRAVITY;

  F64 dy = plr.velocity.y;
  plr.myCollider->position.y += dy;

  if(plr.velocity.y > 10)
  {
    plr.velocity.y = 10;
  }

  temp = collider_que.next;
  while(temp != &collider_que)
  {
    next = temp->next;
    if(temp != plr.myCollider && isColliding(plr.myCollider, temp))
    {
      if(temp->type == 2 || temp->type == 3)
      {
        plr.myCollider->position.y -= dy;
        if(plr.velocity.y > 0)
        {
          plr.myCollider->position.y = temp->position.y - 1 - temp->size.y;
  	  plr.grounded = TRUE;
        }else{
          plr.myCollider->position.y = temp->position.y + 1 + temp->size.y;
        }
        plr.velocity.y = 0;
      }
    }
    temp = next;
  }

  if(plr.velocity.y != 0)
  {
    plr.grounded = FALSE;
  }

  if(keys.up && plr.grounded)
  {
    plr.velocity.y = -16;
    plr.grounded = FALSE;
  }
  
}

U0 DrawIt(CTask *task, CDC *dc)
{
  DCFill(dc, BLACK);
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