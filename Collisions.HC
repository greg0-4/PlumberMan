class Vector2
{
  F64 x,y;
};

class Collider : CQue
{
  Vector2 position;
  Vector2 size;
  I64 type;
};

Collider collider_que;

Collider NewCollider(F64 x1, F64 y1, F64 x2, F64 y2, I64 type)
{
  Collider *new = CAlloc(sizeof(Collider));
  new->position.x = x1;
  new->position.y = y1;
  new->size.x = x2;
  new->size.y = y2;
  new->type = type;
  QueIns(new, collider_que.last);
  return new;
}

Bool isColliding(Collider *a, Collider *b)
{
  if(a->position.x > b->position.x + b->size.x){
    return FALSE;
  }
  if(a->position.x + a->size.x < b->position.x){
    return FALSE;
  }
  if(a->position.y > b->position.y + b->size.y){
    return FALSE;
  }
  if(a->position.y + a->size.y < b->position.y){
    return FALSE;
  }

  return TRUE;
}

Bool CheckMapCollision(Collider *plrCollider)
{
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    if(temp->type == 2)
    {
      if(isColliding(plrCollider, temp))
      {
	return TRUE;
      } 
    }
    temp = next;
  }
  return FALSE;
}

U0 DrawColliders(CDC *dc)
{
  dc->color = GREEN;
  Collider *temp = collider_que.next;
  while(temp != &collider_que)
  {
    Collider *next = temp->next;
    GrRect3(dc,
    temp->position.x,
    temp->position.y,
    1,
    temp->size.x,
    temp->size.y);
    temp = next;
  }
  dc->color = BLACK;
}