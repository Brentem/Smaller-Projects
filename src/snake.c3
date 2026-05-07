import std::collections;
import types;

struct Snake
{
	List {SnakeBlock} blocks;
}

fn void initialize(Snake* snake, int x_index, int y_index)
{
	SnakeBlock block = {PLAYER_HEAD_BLOCK, x_index, y_index};
	snake.blocks.push(block);
}

fn void? add(Snake* snake)
{
	SnakeBlock block = snake.blocks.last()!;

	// TODO: Block placement like this isn't correct.
	SnakeBlock new_block = {PLAYER_BODY_BLOCK, block.x_index, (block.y_index + 1)};
	snake.blocks.push(new_block);
}

fn void? move(Snake* snake, MovementDirection direction)
{
	// NOTE: Get old index info of head block.
	SnakeBlock temp_block = snake.blocks.first()!;

	// NOTE: Set new index info of head block.
	// NOTE: C3 uses implicit break for switch statements.
	switch(direction)
	{
	case MOVING_UP:
		snake.blocks[0].y_index--;
	case MOVING_DOWN:
		snake.blocks[0].y_index++;
	case MOVING_RIGHT:
		snake.blocks[0].x_index++;
	case MOVING_LEFT:
		snake.blocks[0].x_index--;
	default:
		// TODO: Error handling?
	}

	// NOTE: Change index info of other blocks.
	for(int i = 1; i < snake.blocks.len(); i++)
	{
		SnakeBlock curr_block = snake.blocks[i];
		snake.blocks[i].x_index = temp_block.x_index;
		snake.blocks[i].y_index = temp_block.y_index;
		temp_block = curr_block;
	}
}