Cd(__DIR__);;
#include "Collisions.HC";
#define MAP_WIDTH 27
#define MAP_HEIGHT 20
#define ACCEL	 2.0
#define FRICTION 1.3
#define GRAVITY 1.5


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

CDC *tex_heart1 = GRRead("Sprites/Heart1.GR.Z");
CDC *tex_heart2 = GRRead("Sprites/Heart2.GR.Z");

CDC *tex_fireball1 = GRRead("Sprites/Fireball1.GR.Z");
CDC *tex_fireball2 = GRRead("Sprites/Fireball2.GR.Z");
CDC *tex_fireball3 = GRRead("Sprites/Fireball3.GR.Z");
CDC *tex_fireball4 = GRRead("Sprites/Fireball4.GR.Z");


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

Collider *powCollider = CAlloc(sizeof(Collider));

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
	case 3: powCollider = NewCollider(x * 24, y * 24, 24, 24, 4); break;
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
	// case 3: GrBlot(dc, x * 24, y * 24, tex_pow); break;
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
  U64 highScore;
  U8 lives;
  Bool grounded;
  Bool invincible;
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
  F64 velocityMultiplier;
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

class ScorePart : CQue
{
  Vector2 position;
  U64 amount;
  I64 dieTime;
};

class FireBall : CQue
{
  Collider *myCollider;
  CDC *currentSprite;
  I8 currentFrame;
  I64 frameTimer;
  I8 frameTime;
};


Bool g_powBlockHit = FALSE;
I8 g_powBlockAmount = 0;


class Game 
{
  U64 spawnRate;
  U64 fireballTimer;
  U64 round;
  Bool intermission;
};

Game game;
game.intermission = TRUE;
game.round = 0;
game.spawnRate = (4 * 30) - (game.round * 4);
game.fireballTimer = RandU16Range(5 * 30, 10 * 30);

Turtle turtle_que;

ScorePart score_que;

TurtlePop turtlePop_que;

FireBall fireball_que;

// Global Vars

Keys keys;

Player plr;

Collider *topLeftPassage;
Collider *topRightPassage;


U0 NewFireBall(Vector2 *position)
{
  FireBall *new = CAlloc(sizeof(FireBall));
  new->myCollider = NewCollider(position->x, position->y, 12, 12, 10);
  new->currentSprite = tex_fireball1;
  new->currentFrame = 1;
  new->frameTimer = 5;
  new->frameTime = 5;
  QueIns(new, fireball_que.last); 
}

U0 DeleteFireBall(FireBall *a)
{
  DeleteCollider(a->myCollider);
  QueRem(a);
  Free(a);
}

U0 AnimateFireBall(FireBall *a)
{

  if(a->currentFrame > 4)
  {
    a->currentFrame = 1;
  }
  a->frameTimer--;
  if(a->frameTimer <= 0)
  {
    a->frameTimer = a->frameTime;
    a->currentFrame++;
  }
  switch(a->currentFrame)
  {
    case 1: a->currentSprite = tex_fireball1; break;
    case 2: a->currentSprite = tex_fireball2; break;
    case 3: a->currentSprite = tex_fireball3; break;
    case 4: a->currentSprite = tex_fireball4; break;
  }
}



U0 DrawFireBalls(CDC *dc)
{
  FireBall *temp = fireball_que.next;
  while(temp != &fireball_que)
  {
    FireBall *next = temp->next;
    AnimateFireBall(temp);
    GrBlot(dc,
    temp->myCollider->position.x,
    temp->myCollider->position.y,
    temp->currentSprite);
    temp = next;
  }
}

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


U0 NewScoreParticle(Vector2 *position, U64 amount)
{
  ScorePart *new = CAlloc(sizeof(ScorePart));
  new->amount = amount;
  new->position.x = position->x;
  new->position.y = position->y;
  QueIns(new, score_que.last);
  
}

U0 DeleteScoreParticle(ScorePart *a)
{
  QueRem(a);
  Free(a);
}

U0 ScoreParticleLogic(CDC *dc)
{
  ScorePart *temp = score_que.next;
  dc->color = WHITE;
  while(temp != &score_que)
  {
    ScorePart *next = temp->next;
    GrPrint(dc,
    temp->position.x,
    temp->position.y,
    "%d",temp->amount);
    temp->position.y -= 0.75;
    temp->dieTime++;
    if(temp->dieTime > 50)
    {
      DeleteScoreParticle(temp);
    }
    temp = next;
  }
  dc->color = BLACK;
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
    a->animTime = 7;
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
  QueInit(&score_que);
  QueInit(&fireball_que);
  plr.lives = 3;
  plr.invincible = FALSE;
  plr.myCollider = NewCollider(317, 396, 12, 24, 1);
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
    switch(temp->type)
    {
      case 3:
      GrBlot(dc,
      temp->position.x + temp->Soffset.x,
      temp->position.y + temp->Soffset.y,
      tex_tile);
      break;
      case 4:
      GrBlot(dc,
      temp->position.x + temp->Soffset.x,
      temp->position.y + temp->Soffset.y,
      tex_pow);
      break;
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

U0 DrawHearts(CDC *dc)
{
  I64 i;
  for(i=0;i<plr.lives;i++)
  {
    GrBlot(dc, 300 + (i * 14), 80, tex_heart1);
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
      turtle->velocity.x = 2 + turtle->velocityMultiplier;
    }else{
      turtle->velocity.x = -2 + turtle->velocityMultiplier;
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
          turtle->myCollider->position.y = 96;
	  I64 pipe = RandU16 % 2;
	  if(pipe == 1)
          {
	    turtle->myCollider->position.x = 72;           
          }else{
	    turtle->myCollider->position.x = 567;
          }
	  break;
          turtle->velocityMultiplier += 0.25;
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

I64 g_turtleSpawnTimer = game.spawnRate;

U0 KillAllTurtles()
{
  Turtle *temp = turtle_que.next;
  while(temp != &turtle_que)
  {
    Turtle *next = temp->next;
    NewTurtlePop(&temp->myCollider->position);
    DeleteTurtle(temp);
    temp = next;
  }
}


U0 KillPlayer()
{
  if(plr.invincible)
  {
    return;
  }
  plr.lives--;
  plr.invincible = TRUE;
}


U0 FireBallLogic()
{
  FireBall *temp = fireball_que.next;
  while(temp!= &fireball_que)
  {
    FireBall *next = temp->next;
    temp->myCollider->position.x += 4;
    if(isColliding(temp->myCollider, plr.myCollider))
    {
      KillPlayer;
    }
    if(temp->myCollider->position.x > 640 || temp->myCollider->position.x < -20)
    {
      DeleteFireBall(temp);
    }
    temp = next;
  }
}

I64 g_intermissionTimer = 8 * 30;

U0 SpawnFireBall()
{
  U64 randX = RandU16Range(24, 616);
  U64 randY = RandU16Range(24, 408);
  Vector2 myPos;
  myPos.x = randX;
  myPos.y = randY;
  NewFireBall(&myPos);
}



U0 GameLoop()
{
  game.spawnRate = (4 * 30) - (game.round * 4);

  if(!game.intermission)
  {
    game.fireballTimer--; 
    if(game.fireballTimer <= 0)
    {
      SpawnFireBall;
      game.fireballTimer = RandU16Range(5*30, 5 * 30);
    }
  }

  if(game.intermission)
  {
     if(g_intermissionTimer <= 0)
     {
       game.intermission = FALSE;
       g_intermissionTimer = 8 * 30;
     }
     g_intermissionTimer--;
  }
  if(plr.score >= 1000)
  {
    game.intermission = TRUE;
    KillAllTurtles;
    game.round++;
    plr.score = 0;
    
  }
  if(!game.intermission)
  {
    if(g_turtleSpawnTimer <= 0)
    {
      g_turtleSpawnTimer = 0;
      I64 pipe = RandU16 % 2;
      if(pipe == 1)
      {
        NewTurtle(72, 96, TRUE);
      }else{
        NewTurtle(567, 96, FALSE);
      }
      g_turtleSpawnTimer = game.spawnRate;
    }else{
      g_turtleSpawnTimer--;
    }
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



U0 StunAllTurtles()
{
  Turtle *temp = turtle_que.next;
  while(temp != &turtle_que)
  {
    Turtle *next = temp->next;
    temp->stunTime = 4 * 30;
    temp->state = 2;
    temp = next;
  }
}

U0 PowBlock()
{
  if(!g_powBlockHit && g_powBlockAmount < 3)
  {
    StunAllTurtles;
    g_powBlockHit = TRUE;
    g_powBlockAmount++;
  }
}

I64 g_powBlockCounter = 5 * 30;

U0 PowBlockLoop()
{
  if(g_powBlockHit)
  {
    powCollider->position.x = 800;
    g_powBlockCounter--;

    if(g_powBlockCounter <= 0)
    {
      g_powBlockHit = FALSE;
      g_powBlockCounter = 5 * 30;
      powCollider->position.x = 312;
    }   
  }

  if(g_powBlockAmount >= 3)
  {
    powCollider->position.x = 800;
  }
}


Bool g_Running = TRUE;


Bool g_plrFlashing = FALSE;
I64 g_plrFlashingTimer = 1 * 5;

I64 g_plrInvincibleTimer = 3 * 30;

U0 DrawPlayer(CDC *dc)
{
  dc->color = RED;

  if(plr.invincible)
  {


    g_plrFlashingTimer--;
    if(g_plrFlashingTimer <= 0)
    {
      g_plrFlashingTimer = 1 * 5;
      g_plrFlashing = !g_plrFlashing;
    }

    if(g_plrFlashing)
    {
      GrRect(dc, 
        plr.myCollider->position.x,
        plr.myCollider->position.y,
        plr.myCollider->size.x + 1,
        plr.myCollider->size.y + 1);
    }

    g_plrInvincibleTimer--;
    if(g_plrInvincibleTimer <= 0)
    {
       g_plrInvincibleTimer = 3 * 30;
       plr.invincible = FALSE;
    }
  }
  else
  {
  GrRect(dc, 
    plr.myCollider->position.x,
    plr.myCollider->position.y,
    plr.myCollider->size.x + 1,
    plr.myCollider->size.y + 1);
  }
  dc->color = BLACK;
}

I64 g_intermBlinkTimer = 1 * 15;
Bool g_intermBlink = FALSE;
U0 DrawIntermission(CDC *dc)
{
  dc->color = LTRED;
  if(game.intermission)
  {
    g_intermBlinkTimer--;
    if(g_intermBlinkTimer <= 0)
    {
      g_intermBlink = !g_intermBlink;
      g_intermBlinkTimer = 1 * 15;
    }

    if(!g_intermBlink)
    {
      GrPrint(dc, 275, 200, "Intermission");
      if(g_intermissionTimer <= 3 * 30)
      {
        dc->color = YELLOW;
        GrPrint(dc, 285, 210, "Get ready!");
      }
    }

   
  }
  dc->color = WHITE;
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
    speedLimit = 12; 
  }else{
    speedLimit = 8;
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
      if(temp->type == 2 || temp->type == 3 || temp->type == 4 || temp->type == 5 || temp->type == 6)
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
	      plr.score += 100;
	      plr.highScore += 100;
	      NewScoreParticle(&temp_turtle->myCollider->position, 100);
	      DeleteTurtle(temp_turtle);
            }else{
              KillPlayer;
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

  if(plr.velocity.y > 15)
  {
    plr.velocity.y = 15;
  }

  temp = collider_que.next;
  while(temp != &collider_que)
  {
    next = temp->next;
    if(temp != plr.myCollider && isColliding(plr.myCollider, temp))
    {
      if(temp->type == 2 || temp->type == 3 || temp->type == 4 || temp->type == 5 || temp->type == 6)
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
          if(temp->type == 4)
          {
            PowBlock;
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
    plr.velocity.y = -19;
    plr.grounded = FALSE;
  }

  if(!keys.up && plr.velocity.y < 0)
  {
    plr.velocity.y *= 0.5;
  }
  
}

U0 ResetGame(CDC *dc)
{
  plr.lives = 3;
  plr.score = 0;
  plr.highScore = 0;
  KillAllTurtles;  
  game.intermission = TRUE;
  game.round = 0;
  game.spawnRate = (4 * 30) - (game.round * 4);
  plr.myCollider->position.x = 317;
  plr.myCollider->position.y = 396;

}

U0 DrawIt(CTask *task, CDC *dc)
{
  DCFill(dc, BLACK);
  // DrawColliders(dc);
  dc->color = WHITE;
  GrPrint(dc, 290, 60, "Score: %d", plr.score);
  GrPrint(dc, 282, 70, "HScore: %d", plr.highScore);
  dc->color = BLACK;
  UpdateTileAnimations;
  DrawMap(dc);
  DrawHitTiles(dc);
  TurtleLogic;
  DrawTurtles(dc);
  DrawPlayer(dc);
  DrawFireBalls(dc);
  UpdateTurtlePops;
  DrawTurtlePop(dc);
  DrawIntermission(dc);
  ScoreParticleLogic(dc);
  FireBallLogic;
  DrawHearts(dc);
  PowBlockLoop;
  MovePlayer;
  if(plr.lives <= 0)
  {
    ResetGame(dc);
  }
  GameLoop;
  dc->color = WHITE;
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