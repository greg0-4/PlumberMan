 Cd(__DIR__);
#include "Collisions.HC";
#define MAP_WIDTH 27
#define MAP_HEIGHT 20
#define ACCEL	 2.0
#define FRICTION 1.3
#define GRAVITY 1


CDC *tex_brick = GRRead("Sprites/Brick.GR.Z"); 
CDC *tex_tile = GRRead("Sprites/Tile.GR.Z");
CDC *tex_pow = GRRead("Sprites/PowBlock.GR.Z");
CDC *tex_pipeRight = GRRead("Sprites/PipeLeft.GR.Z");
CDC *tex_pipeLeft = GRRead("Sprites/PipeRight.GR.Z");

I64 map[MAP_HEIGHT][MAP_WIDTH] = {
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,1},
  {1,2,2,2,2,2,2,2,2,2,2,2,0,0,0,2,2,2,2,2,2,2,2,2,2,2,1},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {2,2,2,0,0,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,0,0,2,2,2},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,1},
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
      switch(tile)
      {
	case 1: NewCollider(x * 24, y * 24, 24, 24, 2); break;
	case 2: NewCollider(x * 24, y * 24, 24, 24, 3); break;
	case 3: NewCollider(x * 24, y * 24, 24, 24, 4); break;
	case 4: NewCollider(x * 24, y * 24, 24, 24, 5); break;
	case 5: NewCollider(x * 24, y * 24, 24, 24, 5); break;
	case 6: NewCollider(x * 24, y * 24, 24, 24, 6); break;
	case 7: NewCollider(x * 24, y * 24, 24, 24, 6); break;
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
      switch(tile)
      {
	case 1: GrBlot(dc, x * 24, y * 24, tex_brick); break;
	case 2: GrBlot(dc, x * 24, y * 24, tex_tile); break;
	case 3: GrBlot(dc, x * 24, y * 24, tex_pow); break;
        case 4: GrBlot(dc, x * 24, y * 24, tex_pipeLeft); break;
        case 5: GrBlot(dc, x * 24, y * 24, tex_pipeRight); break;
	case 6: GrBlot(dc, x * 24, y * 24, tex_pipeLeft); break;
	case 7: GrBlot(dc, x * 24, y * 24, tex_pipeRight); break;
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
  Bool sprinting;
  Vector2 velocity;
  Collider *myCollider;
};

// Global Vars

Keys keys;

Player plr;

Collider *topLeftPassage;
Collider *bottomLeftPassage;
Collider *topRightPassage;
Collider *bottomRightPassage;




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
  topLeftPassage = NewCollider(0, 168, 24, 72, 7);
  topRightPassage =NewCollider(624, 168, 24, 72, 8);
  bottomLeftPassage = NewCollider(0, 264, 24, 72, 9);
  bottomRightPassage = NewCollider(624, 264, 24, 72, 10); 
  InitMapColliders;    

}

Bool g_Running = TRUE;

U0 PassagesCollision(Collider *a)
{
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    if(temp != a && isColliding(a, temp))
    {
      if(temp == topLeftPassage)
      {
        a->position.x = topRightPassage->position.x - 1 - topRightPassage->size.x;
      }
      if(temp == topRightPassage)
      {
	a->position.x = topLeftPassage->position.x + 1 + topLeftPassage->size.x;
      }

      if(temp == bottomLeftPassage)
      {
	a->position.x = bottomRightPassage->position.x - 1 - bottomRightPassage->size.x;
      }

      if(temp == bottomRightPassage)
      {
	a->position.x = bottomLeftPassage->position.x + 1 + bottomLeftPassage->size.x;
      }
    }
    temp = next;
  } 
}

U0 MovePlayer()
{
  if(keys.actionA)
  {
    plr.sprinting = TRUE;
  }else{
    plr.sprinting = FALSE;
  }
  F64 speedLimit;
  if(plr.sprinting)
  {
    speedLimit = 8; 
  }else{
    speedLimit = 5;
  }

  if(keys.right) plr.velocity.x += ACCEL;
  if(keys.left) plr.velocity.x -= ACCEL;

  plr.velocity.x /= FRICTION;

  if(Abs(plr.velocity.x) >= speedLimit)
  {
    if(plr.velocity.x > 0)
    {
      plr.velocity.x = speedLimit;
    }else
    {
      plr.velocity.x = -speedLimit;
    }
  }

  plr.myCollider->position.x += plr.velocity.x;

  PassagesCollision(plr.myCollider);

  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    if(temp != plr.myCollider && isColliding(plr.myCollider, temp))
    {
      if(temp->type == 2 || temp->type == 3 || temp->type == 5 || temp->type == 6)
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
      if(temp->type == 2 || temp->type == 3 || temp->type == 5 || temp->type == 6)
      {
        plr.myCollider->position.y -= dy;
        if(plr.velocity.y > 0)
        {
          plr.myCollider->position.y = temp->position.y - 1 - temp->size.y;
  	  plr.grounded = TRUE;
        }else{
          plr.myCollider->position.y = temp->position.y + 1 + temp->size.y;
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
  dc->color = WHITE;
  GrPrint(dc, 0, 0, "Velocity: %f Sprinting: %d",plr.velocity.x, plr.sprinting);
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