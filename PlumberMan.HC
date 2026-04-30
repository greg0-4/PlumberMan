Cd(__DIR__);;
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

CDC *tex_turtleWalk1 = GRRead("Sprites/Turtle_Left1.GR.Z");
CDC *tex_turtleWalk2 = GRRead("Sprites/Turtle_Left2.GR.Z");
CDC *tex_turtleWalk3 = GRRead("Sprites/Turtle_Right1.GR.Z");
CDC *tex_turtleWalk4 = GRRead("Sprites/Turtle_Right2.GR.Z");

CDC *tex_turtleShell1 = GRRead("Sprites/Turtle_Shell1.GR.Z");
CDC *tex_turtleShell2 = GRRead("Sprites/Turtle_Shell2.GR.Z");


I64 map[MAP_HEIGHT][MAP_WIDTH] = {
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,1,1},
  {1,1,2,2,2,2,2,2,2,2,2,2,0,0,0,2,2,2,2,2,2,2,2,2,2,1,1},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {2,2,2,0,0,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,0,0,2,2,2},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {1,1,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
};

U16 RandU16Range(U16 min, U16 max)
{
  U16 number = min + RandU16() % (max - min + 1);
  return number;
}

F64 Lerp(F64 a, F64 b, F64 t)
{
  return a + t * (b - a);
}

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

class Turtle : CQue
{
  I8 state;
  I8 stunTime;
  I8 animTime;
  I8 animFrame;
  Bool direction;
  Bool grounded;
  CDC *mySprite;
  Vector2 velocity;
  Collider *myCollider;
};

class TurtlePop : CQue
{
  Vector2 position;
  Vector2 velocity;
};


class Game 
{
  U64 spawnRate;
};

Turtle turtle_que;

TurtlePop turtlePop_que;


// Global Vars

Keys keys;

Player plr;

Collider *topLeftPassage;
Collider *topRightPassage;



Turtle NewTurtle(F64 x, F64 y, Bool dir)
{
  Turtle *new = CAlloc(sizeof(Turtle));
  new->stunTime = 4 * 30;
  new->direction = dir;
  new->velocity.x = 0;
  new->velocity.y = 0;
  new->state = 1;
  new->animFrame = 1;
  new->animTime = 15;
  new->myCollider = NewCollider(x, y, 24, 12, 9);
  if(!dir)
  {
    new->mySprite = tex_turtleWalk1;
  }else{
    new->mySprite = tex_turtleWalk3;
  }
  QueIns(new, turtle_que.last);
  return new;  
}


U0 DeleteTurtle(Turtle *a)
{
  DeleteCollider(a->myCollider);
  QueRem(a);
  Free(a);
}

U0 AnimateTurtle(Turtle *a)
{
  I64 frameLimit = 2;
  if(a->animFrame > 2)
  {
    a->animFrame = 1;
  }

  if(a->animTime > 0)
  {
    a->animTime--; 
  }

  if(a->animTime <= 0)
  {
    a->animFrame++;
    a->animTime = 15;
  }
}

U0 NewTurtlePop(Vector2 *position)
{
  TurtlePop *new = CAlloc(sizeof(TurtlePop));
  new->position.x = position->x;
  new->position.y = position->y;

  U16 randDir = RandU16 % 2;

  if(randDir == 1)
  {
    new->velocity.x = 6;
  }
  else
  {
    new->velocity.x = -6;
  }

  new->velocity.y = -4;
  QueIns(new, turtlePop_que.last);

}

U0 DeleteTurtlePop(TurtlePop *a)
{
  QueRem(a);
  Free(a);
}

U0 UpdateTurtlePops()
{
  TurtlePop *temp = turtlePop_que.next;
  while(temp != &turtlePop_que)
  {
    TurtlePop *next = temp->next;
    temp->velocity.y += GRAVITY;
    temp->position.y += temp->velocity.y;
    temp->position.x += temp->velocity.x;
    if(temp->position.y >= 500)
    {
      DeleteTurtlePop(temp);
    }
    temp = next;
    
  }
}


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
  QueInit(&turtle_que);
  QueInit(&turtlePop_que);

  // Turtle *testTurtle = NewTurtle(50, 48, 1);
  plr.myCollider = NewCollider(48, 48, 12, 24, 1);
  topLeftPassage = NewCollider(0, 0, 24, 480, 7);
  topRightPassage =NewCollider(624, 0, 24, 480, 8);
  InitMapColliders;    

}

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

    }
    temp = next;
  } 
}

U0 DrawHitTiles(CDC *dc)
{
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    if(temp->type == 3)
    {
      GrBlot(dc,
      temp->position.x + temp->Soffset.x,
      temp->position.y + temp->Soffset.y,
      tex_tile);
    }
    temp = next;
  }
}

U0 PushHitTile(Collider *a)
{
  
  if(!a->isFalling)
  {
    a->Soffset.y = Lerp(a->Soffset.y, -5.0, 0.3);
    if(a->Soffset.y <= -4.0)
    {
      a->isFalling = TRUE;
    }
  }
  else
  {
    a->Soffset.y = Lerp(a->Soffset.y, 0.0, 0.3);
    if(a->Soffset.y > -0.1)
    {
      a->Soffset.y = 0;
      a->isFalling = FALSE;
    }
  }
}

U0 UpdateTileAnimations()
{
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    if (temp->Soffset.y != 0) 
    {
      PushHitTile(temp);
    }
    temp = temp->next;
  }
}


U0 TurtleLogic()
{
  Turtle *turtle = turtle_que.next;
  Collider *col = collider_que.next;

  I64 pass;
  for(pass=0;pass<3;pass++)
  {
  Turtle *turtle_a = turtle_que.next;
  while(turtle_a != &turtle_que)
  {
    Turtle *turtle_b = turtle_a->next;
    while(turtle_b != &turtle_que)
    {
      if(isColliding(turtle_a->myCollider, turtle_b->myCollider))
      {
        if(turtle_a->state == 2 || turtle_b->state == 2)
        {
	  break;
	}
	if(turtle_a->myCollider->position.x < turtle_b->myCollider->position.x)
        {
	  turtle_a->myCollider->position.x = turtle_b->myCollider->position.x - turtle_a->myCollider->size.x - 1;
	}else{
  	  turtle_b->myCollider->position.x = turtle_a->myCollider->position.x - turtle_b->myCollider->size.x - 1;
	}
        turtle_a->direction = !turtle_a->direction;
        turtle_b->direction = !turtle_b->direction;
      }
      turtle_b = turtle_b->next;
    }
    turtle_a = turtle_a->next;
  }
  }  

  while(turtle != &turtle_que)
  {
    col = collider_que.next;
    Turtle *t_next = turtle->next;

    // Direction moving
    if(turtle->direction)
    {
      turtle->velocity.x = 2;
    }else{
      turtle->velocity.x = -2;
    }


    // Stunned
    if(turtle->state == 2 && turtle->stunTime > 0)
    {
      turtle->velocity.x = 0; 
      turtle->stunTime--;
    }else{
      turtle->state = 1;
    }


    turtle->myCollider->position.x += turtle->velocity.x;
    PassagesCollision(turtle->myCollider);

    // X Axis Collision
    while(col != &collider_que)
    {
      Collider *c_next = col->next;


      if(col != turtle->myCollider && isColliding(turtle->myCollider, col))
      {

	if(col->type == 2 || col->type == 3)
        {
           if(turtle->velocity.x > 0)
           {
	     turtle->myCollider->position.x = col->position.x - 1 - turtle->myCollider->size.x;
	     turtle->direction = !turtle->direction;
           }else{
	     turtle->myCollider->position.x = col->position.x + 1 + col->size.x;
	     turtle->direction = !turtle->direction;
           }
        }
        if(col->type == 6)
        {
	  DeleteTurtle(turtle);
	  break;
        }
      }

      col = c_next;
    }

    turtle->velocity.y += GRAVITY;
    turtle->myCollider->position.y += turtle->velocity.y;

    if(turtle->velocity.y > 10)
    {
      turtle->velocity.y = 10;
    }
    // Y Axis Collision

    col = collider_que.next;
    while(col != &collider_que)
    {
      c_next = col->next;

      if(col != turtle->myCollider && isColliding(turtle->myCollider, col))
      {
	if(col->type == 2 || col->type == 3)
	{
	  turtle->myCollider->position.y -= turtle->velocity.y;
          if(turtle->velocity.y > 0)
          {
	    turtle->myCollider->position.y = col->position.y + 11 - col->size.y;
	    turtle->grounded = TRUE;
          }else{
            turtle->myCollider->position.y = col->position.y - 11 + col->size.y;
          }
          turtle->velocity.y = 0;
	}
      }
      col = c_next;
    }

    if(turtle->velocity.y != 0)
    {
      turtle->grounded = FALSE;
    }

    turtle = t_next;
  }
}

U0 DrawTurtles(CDC *dc)
{
  Turtle *temp = turtle_que.next;
  while(temp != &turtle_que)
  {

   
    Turtle *next = temp->next;
    AnimateTurtle(temp);

    if(temp->animFrame == 1 && !temp->direction)
    {
      temp->mySprite = tex_turtleWalk1;
    }else if(temp->animFrame == 2 && !temp->direction)
    {
      temp->mySprite = tex_turtleWalk2;
    }else if(temp->animFrame == 1 && temp->direction)
    {
      temp->mySprite = tex_turtleWalk3;
    }else if(temp->animFrame == 2 && temp->direction)
    {
      temp->mySprite = tex_turtleWalk4;
    }

    if(temp->state == 2)
    {
      temp->mySprite = tex_turtleShell1;
    }

    if(temp->state == 2 && temp->stunTime <= 60)
    {
      temp->mySprite = tex_turtleShell2;
    }
    GrBlot3(dc,
    temp->myCollider->position.x,
    temp->myCollider->position.y - 12, 1,
    temp->mySprite);
    temp = next;
  }
}

I64 g_turtleSpawnTimer = 60;

U0 GameLoop()
{
  if(g_turtleSpawnTimer <= 0)
  {
    g_turtleSpawnTimer = 0;
    I64 pipe = RandU16 % 2;
    "%d\n",pipe;
    if(pipe == 1)
    {
      NewTurtle(72, 96, TRUE);
    }else{
      NewTurtle(567, 96, FALSE);
    }
    g_turtleSpawnTimer = 60;
  }else{
    g_turtleSpawnTimer--;
  }
}

U0 DrawTurtlePop(CDC *dc)
{
  TurtlePop *temp = turtlePop_que.next;
  while(temp != &turtlePop_que)
  {
    TurtlePop *next = temp->next;
    GrBlot3(dc,
      temp->position.x,
      temp->position.y,
      5,
      tex_turtleShell1
    );
    temp = next;
  }
}

Bool g_Running = TRUE;

U0 DrawPlayer(CDC *dc)
{
  dc->color = RED;
  GrRect(dc, 
  plr.myCollider->position.x,
  plr.myCollider->position.y,
  plr.myCollider->size.x + 1,
  plr.myCollider->size.y + 1);
  dc->color = BLACK;
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

  PassagesCollision(plr.myCollider);

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
 
      if(temp->type == 9)
      {
	Turtle *temp_turtle = turtle_que.next;
        while(temp_turtle != &turtle_que)
        {
	  Turtle *turtle_next = temp_turtle->next;

	  if(temp_turtle->myCollider == temp)
          {
            if(temp_turtle->state == 2)
            {
	      NewTurtlePop(&temp_turtle->myCollider->position);
	      DeleteTurtle(temp_turtle);
            }
          }

	  temp_turtle = turtle_next;
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
          if(temp->type == 3)
	  {
            PushHitTile(temp);
            temp_turtle = turtle_que.next;
            while(temp_turtle != &turtle_que)
            {
	      turtle_next = temp_turtle->next;
              Bool turtleAboveBlock = 
                temp_turtle->myCollider->position.y + temp_turtle->myCollider->size.y >= temp->position.y - 2 &&
                temp_turtle->myCollider->position.y + temp_turtle->myCollider->size.y <= temp->position.y + 4 &&
                temp_turtle->myCollider->position.x + temp_turtle->myCollider->size.x > temp->position.x &&
                temp_turtle->myCollider->position.x < temp->position.x + temp->size.x;
		if(turtleAboveBlock)
		{
		  if(temp_turtle->state != 2)
		  {
		    temp_turtle->stunTime = 4 * 30;
		    temp_turtle->state = 2;
		  }
		}

	      temp_turtle = turtle_next;
            }
          }
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

  // Jumping
  if(keys.up && plr.grounded)
  {
    plr.velocity.y = -16;
    plr.grounded = FALSE;
  }

  if(!keys.up && plr.velocity.y < 0)
  {
    plr.velocity.y *= 0.5;
  }
  
}

U0 DrawIt(CTask *task, CDC *dc)
{
  DCFill(dc, BLACK);
  // DrawColliders(dc);
  UpdateTileAnimations;
  DrawMap(dc);
  DrawHitTiles(dc);
  TurtleLogic;
  DrawTurtles(dc);
  DrawPlayer(dc);
  UpdateTurtlePops;
  DrawTurtlePop(dc);
  MovePlayer;
  GameLoop;
  dc->color = WHITE;
  GrPrint(dc, 0, 0, "Velocity: %d Sprinting: %d",QueCnt(&turtlePop_que), plr.sprinting);
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
		case SC_SHIFT: keys.actionA = FALSE; break;
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
	    case 0:

	      switch(input2.u8[0])
	      {
		case SC_SHIFT: keys.actionA = TRUE; break;
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