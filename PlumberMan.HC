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

class Turtle : CQue
{
  I8 state;
  I8 stunTime;
  Bool direction;
  Bool grounded;
  Vector2 velocity;
  Collider *myCollider;
};

Turtle turtle_que;


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
  new->myCollider = NewCollider(x, y, 24, 12, 9);
  QueIns(new, turtle_que.last);
  return new;  
}


U0 DeleteTurtle(Turtle *a)
{
  DeleteCollider(a->myCollider);
  QueRem(a);
  Free(a);
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
    if(!tex_turtleWalk1->r)
    {
      DCMat4x4Set(tex_turtleWalk1, Mat4x4IdentNew);
    }
    GrBlot3(dc,
    temp->myCollider->position.x,
    temp->myCollider->position.y - 12, 1,
    tex_turtleWalk1);
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
      NewTurtle(567, 96, FALSE);
    }
    g_turtleSpawnTimer = 60;
  }else{
    g_turtleSpawnTimer--;
  }
}



Bool g_Running = TRUE;



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

  if(keys.up && plr.grounded)
  {
    plr.velocity.y = -16;
    plr.grounded = FALSE;
  }
  
}

U0 DrawIt(CTask *task, CDC *dc)
{
  DCFill(dc, BLACK);
  DrawColliders(dc);
  DrawMap(dc);
  TurtleLogic;
  DrawTurtles(dc);
  MovePlayer;
  GameLoop;
  dc->color = WHITE;
  GrPrint(dc, 0, 0, "Velocity: %f Sprinting: %d",plr.myCollider->position.x, plr.sprinting);
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